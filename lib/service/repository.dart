import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;
import 'package:huba_checker/database/repository.dart';

import '../models/ad_model.dart';

class AdRepository {
  final DatabaseRepository _databaseRepository = DatabaseRepository();

  Future<List<Ad>> fetchData({required String url}) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final html = response.body;

      final articleHtmlStrings = findArticles(html);

      var parsedAds = articleHtmlStrings.map((articleHtml) => parseAdFromHtml(articleHtml, url)).toList();

      print('tutaj jeszcze d');

      var news = updateAdsInCache(allAds: parsedAds, url: url);


      return news;
    } else {
      throw Exception('Failed to load data');
    }
  }

    Future<List<Ad>> fetchAllData({required String url}) async {
    var response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final html = response.body;

      final articleHtmlStrings = findArticles(html);

      var parsedAds = articleHtmlStrings.map((articleHtml) => parseAdFromHtml(articleHtml, url)).toList();

      return parsedAds;
    } else {
      throw Exception('Failed to load data');
    }
  }

  List<String> findArticles(String html) {
    final document = parser.parse(html);

    final elements = document.querySelectorAll('article');

    List<String> articles = [];
    for (final element in elements) {
      if (!element.outerHtml.contains('Betalt plassering')) {
        if (element.outerHtml.startsWith('<article class=') && element.outerHtml.endsWith('</article>')) {
          articles.add(element.outerHtml);
        }
      }
    }
    return articles;
  }

  Future<List<Ad>> updateAdsInCache({required List<Ad> allAds, required String url}) async {
    List<Ad> newAds = allAds.take(10).toList();
    List<Ad> adsToInsert = [];
    int insertedCount = 0;

    print('Starting update of ads in cache for websiteUrl: $url');

    // Sprawdź, które ogłoszenia już istnieją w bazie danych
    for (Ad ad in newAds) {
      if (await _databaseRepository.isAdNew(ad: ad, url: url)) {
        adsToInsert.add(ad);
      }
    }

    print('${adsToInsert.length} new ads found for websiteUrl: $url');

    // Jeśli wszystkie ogłoszenia już są w bazie, zwróć pustą listę
    if (adsToInsert.isEmpty) {
      print('All ads are already in the cache. No update needed.');
      return [];
    }

    // W przeciwnym razie zapisz brakujące ogłoszenia do bazy danych
    for (Ad ad in adsToInsert) {
      bool success = await _databaseRepository.saveAdToCache(ad);
      if (!success) {
        print('Failed to insert ad with title: ${ad.title}');
      }
      insertedCount++;
    }

    print('Inserted $insertedCount new ads into the cache.');

    await _databaseRepository.removeOldAdsIfNeeded(url);

    for (Ad ad in adsToInsert) {
      print(ad.title);
    }

    //await _databaseRepository.printAllAdTitles();

    // Zwróć listę nowych ogłoszeń, które zostały dodane
    return adsToInsert;
  }
}
