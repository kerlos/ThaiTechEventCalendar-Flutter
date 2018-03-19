import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'managers/notification_manager.dart';
import 'models/event/event.dart';
import 'tte/event_list.dart';
import 'configs/application.dart';
import 'configs/routes.dart';
import 'tte/event_client.dart';

void main() => runApp(new App());

class App extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new AppState();
}

class AppState extends State<App> {
  AppState() {
    final router = new Router();
    Routes.configRoutes(router);
    Application.router = router;
    new NotificationManager();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Thai Tech Event',
        theme: new ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: "Prompt"
        ),
        home: new HomePage(title: 'Thai Tech Event'));
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Event> upcomingEvent = new List<Event>();

  void updateData() async {
    var eventClient = new EventClient();
    await eventClient.loadData();
    setState(() {
      upcomingEvent = eventClient.getUpcomingEvents();
    });
  }

  void refreshData() async {
    var eventClient = new EventClient();
    await eventClient.loadData(forceLoad: true);
    setState(() {
      upcomingEvent = eventClient.getUpcomingEvents();
    });
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return new EventList(events: upcomingEvent, onRefreshPull: refreshData);
  }
}
