import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:path/path.dart';

import '../models/event/event.dart';
import 'package:path_provider/path_provider.dart';

class EventClient extends Object {
  static final EventClient _eventClient = new EventClient._internal();

  EventClient._internal();

  factory EventClient() {
    return _eventClient;
  }

  List<Event> data = new List<Event>();

  final String calendarBase = 'thaiprogrammer-tech-events-calendar.spacet.me';
  Future<List<Event>> loadData({bool forceLoad = false}) async {
    data.clear();
    Uri uri = new Uri.https(calendarBase, 'calendar.json');
    String jsonString = await readJson(uri, forceLoad);
    List<Map<String, dynamic>> json = JSON.decode(jsonString);
    json.forEach((item) => data.add(new Event.fromJson(item)));
    return data;
  }

  Future<String> loadJson(Uri uri) async {
    try{
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.getUrl(uri);
      HttpClientResponse response = await request.close();
      String responseBody = await response.transform(UTF8.decoder).join();
      return responseBody;
    } catch (e) {
      return null;
    }
  }

  Future<String> readJson(Uri uri, bool forceLoad) async {
    Directory dir = await getApplicationDocumentsDirectory();
    String path = join(dir.path, "calendar.json");
    File file;
    if (!forceLoad &&
        FileSystemEntity.typeSync(path) != FileSystemEntityType.NOT_FOUND) {
      file = new File(path);
      DateTime fileDate = file.lastModifiedSync();
      if (fileDate
          .add(const Duration(hours: 1))
          .difference(new DateTime.now())
          .isNegative) {
        String jsonString = await loadJson(uri);
        if(jsonString != null) {
          file = new File(path);
          file.writeAsStringSync(jsonString);
          return jsonString;
        }
      }
    } else {
      String jsonString = await loadJson(uri);
      file = new File(path);
      file.writeAsStringSync(jsonString);
      return jsonString;
    }
    var json = file.readAsStringSync();
    return json;
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
