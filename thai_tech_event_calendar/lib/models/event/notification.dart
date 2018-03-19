import 'dart:async';
import 'dart:developer';
import 'package:sqflite/sqflite.dart';

final String table = "notifications";
final String columnId = "id";
final String columnEventId = "event_id";
final String columnDate = "date";
final String columnFinished = "is_finished";
final String columnRemindOffset = "remind_offset";

class NotificationData {
  int id;
  String eventId;
  DateTime date;
  int remindOffset;
  bool isFinished;

  NotificationData(this.date,this.remindOffset, this.eventId, this.isFinished);

  NotificationData.fromMap(Map map) {
    id = map[columnId];
    eventId = map[columnEventId];
    date = new DateTime.fromMillisecondsSinceEpoch(map[columnDate]);
    remindOffset = map[columnRemindOffset];
    isFinished = map[columnFinished] == 1;
  }

  Map toMap() {
    Map map = {
      columnEventId: eventId,
      columnDate: date.millisecondsSinceEpoch,
      columnRemindOffset: remindOffset,
      columnFinished: isFinished == true ? 1 : 0
    };

    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

class NotificationProvider {
  final String path;
  NotificationProvider(this.path);

  Database db;
  Future open() async {
    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute("""
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnEventId TEXT NOT NULL UNIQUE,
            $columnDate INTEGER NOT NULL,
            $columnRemindOffset INTEGER NOT NULL,
            $columnFinished INTEGER DEFAULT 0
          )""");
    });
  }

  void reset() {
    deleteDatabase(path);
  }

  Future<NotificationData> insert(NotificationData data) async {
    data.id = await db.insert(table, data.toMap());
    return data;
  }

  Future<NotificationData> getNotification(String eventId) async {
    List<Map> maps = await db.query(table,
        columns: [columnId, columnEventId, columnDate, columnRemindOffset, columnFinished],
        where: "$columnEventId = ?",
        whereArgs: [eventId]);

    if (maps.length > 0) {
      return new NotificationData.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(String eventId) async {
    return await db
        .delete(table, where: "$columnEventId = ?", whereArgs: [eventId]);
  }

  Future<int> update(NotificationData data) async {
    return await db.update(table, data.toMap(),
        where: "$columnId = ?", whereArgs: [data.id]);
  }

  Future close() async => db.close();
}
