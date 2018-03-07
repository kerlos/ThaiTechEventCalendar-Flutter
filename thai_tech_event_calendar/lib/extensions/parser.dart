import 'package:intl/intl.dart';

class Parser {
  static NumberFormat minuteFormat = new NumberFormat('00', 'en_US');
  static DateFormat eventDateFormat = new DateFormat('MMM d');
  static DateFormat eventDateNameFormat = new DateFormat('E');
  static DateTime parseDate(Map json) =>
      new DateTime(json['year'], json['month'], json['date']);

  static String parseTime(Map<String, dynamic> json) =>
      "${json['hour']}:${minuteFormat.format(json['minute'])}";

  static String parseEventDate(DateTime date) => eventDateFormat.format(date);
  static String parseEventDateName(DateTime date) =>
      eventDateNameFormat.format(date);
}
