import 'dart:io';
import 'dart:convert';
import 'package:thai_tech_event_calendar/models/event/event.dart';
import 'dart:async';

class EventClient extends Object {
  List<Event> data = new List<Event>();
  final String calendarBase = 'thaiprogrammer-tech-events-calendar.spacet.me';
  Future<List<Event>> loadData() async {
    data.clear();
    var httpClient = new HttpClient();
    var uri = new Uri.https(calendarBase, 'calendar.json');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    List<Map<String, dynamic>> json = JSON.decode(responseBody);
    json.forEach((item) => data.add(new Event.fromJson(item)));
    return data;
  }
  List<Event> getUpcomingEvents() {
    return data.where((event) => event.startDate.difference(new DateTime.now()).inDays >=0).toList();
  }
  List<Event> getEvents() => data;
}
