import 'dart:async';

import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/models/event/event.dart';
import 'event_client.dart';
import 'dart:developer';

import 'event_list.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Thai Tech Event',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new HomePage(title: 'Thai Tech Event'),
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
  List<Event> events = new List<Event>();
  EventClient client;
  
  void updateData() async {
    await client.loadData();
    setState(() {
      events = client.getUpcomingEvents();
    });
  }

  _HomePageState() {
    client = new EventClient();
  }

  @override
  void initState() {
    super.initState();
    updateData();
  }

  @override
  Widget build(BuildContext context){
    return new EventList(events: events);
  }
}
