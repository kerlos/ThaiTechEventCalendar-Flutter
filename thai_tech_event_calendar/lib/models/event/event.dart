import 'link.dart';
import 'location.dart';
import 'resource.dart';
import 'time.dart';
import 'package:thai_tech_event_calendar/extensions/parser.dart';

class Event extends Object {
  String id;
  String title;
  String summary;
  String description;
  String agenda;
  DateTime startDate;
  DateTime endDate;
  Location location;
  List<String> categories = new List<String>();
  List<String> topics = new List<String>();
  List<Time> times = new List<Time>();
  List<Link> links = new List<Link>();
  List<Resource> resources = new List<Resource>();
  List<String> tags = new List<String>();
  
  Event.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    summary = json['summary'];
    description = json['description'];
    startDate = Parser.parseDate(json['start']);
    endDate = Parser.parseDate(json['end']);
    location = new Location.fromJson(json['location']);
    if (json['time'] != null) {
      json['time'].forEach((value) => times.add(new Time.fromJson(value)));
    }
    json['links'].forEach((value) => links.add(new Link.fromJson(value)));
    json['resources']
        .forEach((value) => resources.add(new Resource.fromJson(value)));
    json['topics'].forEach((value) => topics.add(value));
    json['categories'].forEach((value) => categories.add(value));

    tags = new List.from(categories)..addAll(topics);
  }
}
