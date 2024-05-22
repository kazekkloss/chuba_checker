import 'package:html/parser.dart' show parse;

class Ad {
  final String websiteUrl;
  final String title;
  final String url;
  final String location;
  final String year;
  final String mileage;
  final String price;
  final String sellerType;
  final String imageUrl;
  final DateTime? createdTime; 

  Ad({
    required this.websiteUrl,
    required this.title,
    required this.url,
    required this.location,
    required this.year,
    required this.mileage,
    required this.price,
    required this.sellerType,
    required this.imageUrl,
    this.createdTime, 
  });

  Map<String, dynamic> toJson() {
    return {
      'websiteUrl': websiteUrl,
      'title': title,
      'url': url,
      'location': location,
      'year': year,
      'mileage': mileage,
      'price': price,
      'sellerType': sellerType,
      'imageUrl': imageUrl,
      'createdTime': DateTime.now().toIso8601String(),
    };
  }

  factory Ad.fromJson(Map<String, dynamic> json) {
    return Ad(
      websiteUrl: json['websiteUrl'] as String,
      title: json['title'] as String,
      url: json['url'] as String,
      location: json['location'] as String,
      year: json['year'] as String,
      mileage: json['mileage'] as String,
      price: json['price'] as String,
      sellerType: json['sellerType'] as String,
      imageUrl: json['imageUrl'] as String,
      createdTime: json.containsKey('createdTime') 
          ? DateTime.tryParse(json['createdTime'] as String) 
          : null,
    );
  }
}

Ad parseAdFromHtml(String htmlString, String websiteUrl) {
  try {
    var document = parse(htmlString);
    var titleElement = document.querySelector('h2 a');
    if (titleElement == null) throw Exception('Title element not found');

    var locationElement = document.querySelector('.text-gray-500 span');
    if (locationElement == null) throw Exception('Location element not found');

    var yearElement = document.querySelectorAll('.mb-8.flex span')[0];
    var mileageElement = document.querySelectorAll('.mb-8.flex span')[1];
    var priceElement = document.querySelectorAll('.mb-8.flex span')[2];

    if (yearElement == null || mileageElement == null || priceElement == null) {
      throw Exception('Year, mileage or price element not found');
    }

    var sellerTypeElement = document.querySelector('.flex.flex-col.text-12 span');
    if (sellerTypeElement == null) throw Exception('Seller type element not found');

    var imageElement = document.querySelector('img');
    if (imageElement == null) throw Exception('Image element not found');

    // Jeśli wszystkie elementy są obecne, zwróć nowo utworzony obiekt Ad
    return Ad(
      websiteUrl: websiteUrl,
      title: titleElement.text.trim(),
      url: titleElement.attributes['href'] ?? '',
      location: locationElement.text.trim(),
      year: yearElement.text.trim(),
      mileage: mileageElement.text.trim().replaceAll(' km', '').replaceAll('\u00A0', ' '),
      price: priceElement.text.trim().replaceAll(' kr', '').replaceAll('\u00A0', ''),
      sellerType: sellerTypeElement.text.trim(),
      imageUrl: imageElement.attributes['src'] ?? '',
    );
  } catch (e) {
    // W przypadku wyjątku, logujemy błąd i możemy zdecydować co dalej zrobić
    print('Exception caught while parsing HTML: $e');
    // Możesz zdecydować o re-throw wyjątku lub zwrócić null, lub specjalny obiekt Ad
    rethrow;
  }
}
