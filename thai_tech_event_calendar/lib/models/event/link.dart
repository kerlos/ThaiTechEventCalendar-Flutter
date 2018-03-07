class Link {
  final String type;
  final String url;
  final String title;
  final String detail;
  final String price;

  Link.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        url = json['url'],
        title = json['title'],
        detail = json['detail'],
        price = json['price'];
}
