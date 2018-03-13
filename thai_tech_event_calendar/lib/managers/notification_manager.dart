import 'dart:developer';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/event/notification.dart';

class NotificationManager {
  static final NotificationManager _instance =
      new NotificationManager._internal();
  factory NotificationManager() {
    return _instance;
  }

  NotificationProvider notifications;
  NotificationManager._internal() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "tte.db");
    notifications = new NotificationProvider(path);
  }
}
