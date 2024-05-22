import 'package:huba_checker/database/database.dart';
import 'package:huba_checker/models/ad_model.dart';
import 'package:sqflite/sqflite.dart';

import '../models/website_model.dart';

class DatabaseRepository {
  /// WEBSITE ------------------------------------------------------------

  Future<bool> saveWebToCache(Website website) async {
    final Database db = await openAppDataDb();

    try {
      await db.insert(
        'Website',
        website.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error saving website to cache: $e');
      return false;
    }
  }

  Future<List<Website>> getAllWebsites() async {
    final Database db = await openAppDataDb();

    try {
      final List<Map<String, dynamic>> maps = await db.query('Website');
      return maps.map((map) => Website.fromJson(map)).toList();
    } catch (e) {
      print('Error retrieving all websites: $e');
      return [];
    }
  }

Future<bool> deleteWebsiteByUrl(String url) async {
  final Database db = await openAppDataDb();

  try {
    // Usuń stronę internetową
    int deletedWebsiteCount = await db.delete(
      'Website',
      where: 'url = ?',
      whereArgs: [url],
    );
    print('Deleted $deletedWebsiteCount website(s) with URL: $url');

    // Usuń wszystkie ogłoszenia powiązane z tą stroną internetową
    int deletedAdsCount = await db.delete(
      'Ad',
      where: 'websiteUrl = ?',
      whereArgs: [url],
    );
    print('Deleted $deletedAdsCount ad(s) associated with website URL: $url');

    return true;
  } catch (e) {
    print('Error deleting website and ads by URL: $e');
    return false;
  }
}

  /// AD ------------------------------------------------------------

  Future<bool> isAdNew({required Ad ad, required String url}) async {
    final Database db = await openAppDataDb();
    try {
      final List<Map<String, dynamic>> existingAds = await db.query(
        'Ad',
        where: 'websiteUrl = ? AND url = ?',
        whereArgs: [url, ad.url],
        limit: 1,
      );
      return existingAds.isEmpty;
    } catch (e) {
      print('Error saving ad to cache: $e');
      return false;
    }
  }

  Future<bool> saveAdToCache(Ad ad) async {
    final Database db = await openAppDataDb();

    try {
      await db.insert(
        'Ad',
        ad.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return true;
    } catch (e) {
      print('Error saving ad to cache: $e');
      return false;
    }
  }

// Sprawdź, czy liczba rekordów przekracza 10, i jeśli tak, usuń najstarsze
Future<void> removeOldAdsIfNeeded(String url) async {
  final Database db = await openAppDataDb();
  try {
    // Zlicz ogłoszenia dla danego URL
    int count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM Ad WHERE websiteUrl = ?', [url])) ?? 0;
    if (count > 10) {
      int overLimit = count - 10;
      // Usuwanie najstarszych ogłoszeń, które mają 'websiteUrl' równy 'url'
      await db.rawDelete('''
        DELETE FROM Ad 
        WHERE id IN (
          SELECT id FROM Ad 
          WHERE websiteUrl = ? 
          ORDER BY createdTime ASC, id ASC 
          LIMIT ?
        )
      ''', [url, overLimit]);

      print('Removed $overLimit old ads to maintain cache limit of 10.');
    } else {
      print('Cache limit is maintained. No need to remove ads.');
    }
  } catch (e) {
    print('Error removing old ads from cache: $e');
  }
}


  Future<void> printAllAdTitles() async {
    final Database db = await openAppDataDb();
    final List<Map<String, dynamic>> maps = await db.query('Ad');

    for (var map in maps) {
      Ad ad = Ad.fromJson(map);
      print(ad.title);
    }
  }
}
