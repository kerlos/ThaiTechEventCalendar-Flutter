class Resource {
  final String type;
  final String url;
  final String title;

  Resource.fromJson(Map json)
      : type = json['type'],
        url = json['url'],
        title = json['title'];
}
