import 'dart:developer';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/models/event/event.dart';
import 'package:thai_tech_event_calendar/extensions/parser.dart';

import '../configs/application.dart';
import '../configs/routes.dart';
import 'event_client.dart';
class EventListItem extends StatefulWidget {
  final Event event;
  EventListItem(Event event)
      : event = event,
        super(key: new ObjectKey(event));

  @override
  State<StatefulWidget> createState() => new EventItemState(event);
}

class EventItemState extends State<EventListItem> {
  final Event event;
  EventItemState(this.event);
 
  bool _highlight = false;
  void _handleTap() {
      //debugger();
  }

 void _handleTapDown(TapDownDetails details) {
      setState(() => _highlight = true);
  }

  void _handleTapUp(TapUpDetails details) {
      setState(() {
        _highlight = false;
      });
      debugger();
      var x = new EventClient().getEventById(event.id);
      Application.router.navigateTo(context, "/events/${event.id}");
  }

  void _handleTapCancel() {
      setState(() => _highlight = false);
  }
  Widget eventTags() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: event.tags.map((tag) {
        return new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
              decoration: new BoxDecoration(
                color: const Color(0xfffaf8d1),
                borderRadius: new BorderRadius.all(const Radius.circular(4.0))
              ),
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                tag,
                textScaleFactor: 0.8,
                softWrap: true,
                style: new TextStyle(
                  color: const Color(0xfff49200)
                )
              ),
            ),
            new Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))
          ],
        );
      }).toList()
    );
  }
  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new GestureDetector(
          onTap: _handleTap,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          child: new Card(
            elevation: 3.0,
            color: _highlight ? Colors.blue : Colors.white,
            child: new Padding(
              padding: const EdgeInsets.all(8.0),
              child: new Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                        flex: 22,
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                Parser.parseEventDate(event.startDate),
                                textScaleFactor: 1.0,
                                textAlign: TextAlign.left,
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold),
                              ),
                              new Text(
                                Parser.parseEventDateName(event.startDate),
                                textScaleFactor: 0.9,
                                textAlign: TextAlign.left,
                              ),
                              new ListView.builder(
                                shrinkWrap: true,
                                itemCount: event.times.length,
                                itemBuilder: (context, i) => new Text(
                                      "${event.times[i].from} ~ ${event.times[i].to} ${event.times[i].after ? '++' : ''}",
                                      textScaleFactor: 0.6,
                                      textAlign: TextAlign.left,
                                    ),
                              )
                            ])),
                    new Expanded(
                        flex: 78,
                        child: new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                event.title,
                                textScaleFactor: 0.9,
                                textAlign: TextAlign.left,
                                style: new TextStyle(
                                  color: const Color(0xfff49200),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              new Text(
                                event.summary,
                                textScaleFactor: 0.85, 
                                textAlign: TextAlign.left,
                              ),
                              new Padding(padding: const EdgeInsets.only(top: 4.0)),
                              eventTags()
                            ]))
                  ]),
            )),
        )
      ],
    );
  }
}

class EventList extends StatefulWidget {
  final List<Event> events;
  EventList({Key key, this.events}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new EventListState();
}

class EventListState extends State<EventList> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Thai Tech Event Calendar"),
      ),
      body: new Container(
        padding: const EdgeInsets.all(2.0),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Container(
                padding: const EdgeInsets.all(4.0),
                child: new Text(
                  "Upcoming Events",
                  textScaleFactor: 1.6,
                  textAlign: TextAlign.left,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                )),
            new Expanded(
                child: new ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              itemCount: widget.events.length,
              itemBuilder: (context, i) => new EventListItem(widget.events[i]),
            )
            )
          ],
        ),
      ),
    );
  }
}
