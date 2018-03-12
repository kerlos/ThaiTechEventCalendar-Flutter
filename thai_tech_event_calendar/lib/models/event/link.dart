class Link {
  final String type;
  final String url;
  final String title;
  final String detail;
  final String price;

  Link.fromJson(Map<String, dynamic> json)
      : type = json['type'] != null ? json['type'] : "",
        url = json['url'] != null ? json['url'] : "",
        title = json['title'] != null ? json['title'] : "",
        detail = json['detail'] != null ? json['detail'] : "",
        price = json['price'] != null ? json['price'] : "";
}
