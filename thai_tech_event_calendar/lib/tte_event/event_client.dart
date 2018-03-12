import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

import '../models/event/event.dart';

class EventClient extends Object {
  static final EventClient _eventClient = new EventClient._internal();

  EventClient._internal();

  factory EventClient() {
    return _eventClient;
  }

  List<Event> data = new List<Event>();
  HttpClient httpClient = new HttpClient();
  final String calendarBase = 'thaiprogrammer-tech-events-calendar.spacet.me';
  Future<List<Event>> loadData() async {
    data.clear();
    var uri = new Uri.https(calendarBase, 'calendar.json');
    var request = await httpClient.getUrl(uri);
    var response = await request.close();
    var responseBody = await response.transform(UTF8.decoder).join();
    List<Map<String, dynamic>> json = JSON.decode(responseBody);
    json.forEach((item) => data.add(new Event.fromJson(item)));
    return data;
  }

  List<Event> getUpcomingEvents() {
    return data
        .where((event) =>
            event.startDate.difference(new DateTime.now()).inDays >= 0)
        .toList();
  }

  List<Event> getEvents() => data;

  Event getEventById(String id) {
    var result = data.firstWhere((item) => item.id == id);
    return result;
  }
}
