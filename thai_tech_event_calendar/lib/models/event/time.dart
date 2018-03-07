import 'package:thai_tech_event_calendar/extensions/parser.dart';

class Time {
  String from;
  String to;
  bool after;
  String agenda;

  Time.fromJson(Map<String, dynamic> json)
      : from = Parser.parseTime(json['from']),
        to = Parser.parseTime((json['to'])),
        after = json['after'],
        agenda = json['agenda'];
}
