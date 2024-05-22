class Website {
  final String name;
  final String url;

  const Website({required this.name, required this.url});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory Website.fromJson(Map<String, dynamic> json) {
    return Website(
      name: json['name'],
      url: json['url'],
    );
  }
}
