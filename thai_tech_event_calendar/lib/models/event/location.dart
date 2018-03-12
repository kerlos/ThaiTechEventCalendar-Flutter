class Location {
  final String title;
  final String url;
  final String detail;

  Location.fromJson(Map json)
      : title = json['title'] != null ? json['title'] : "",
        url = json['url'] != null ? json['url'] : "",
        detail = json['detail'] != null ? json['detail'] : "";
}
