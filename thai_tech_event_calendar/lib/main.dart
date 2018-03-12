import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/models/event/event.dart';
import 'package:thai_tech_event_calendar/tte_event/event_list.dart';
import 'dart:developer';

import 'configs/application.dart';
import 'configs/routes.dart';
import 'tte_event/event_client.dart';

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
      ),
      home: new HomePage(title: 'Thai Tech Event')
    );
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

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context) {
    return new EventList(events: upcomingEvent);
  }
}
