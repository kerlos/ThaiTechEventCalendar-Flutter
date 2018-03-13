import 'dart:async';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/extensions/parser.dart';

import '../configs/application.dart';
import '../models/event/event.dart';

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
    Application.router.navigateTo(context, "/events/${event.id}",
        transition: TransitionType.native,
        transitionDuration: const Duration(milliseconds: 100));
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
                    borderRadius:
                        new BorderRadius.all(const Radius.circular(4.0)),
                    border: new Border.all(color: Colors.orange.shade100)),
                padding: const EdgeInsets.all(2.0),
                child: new Text(tag,
                    textScaleFactor: 0.8,
                    softWrap: true,
                    style: new TextStyle(
                        color: Application.mainColor,
                        fontSize: 16.0,
                        fontFamily: "Prompt")),
              ),
              new Padding(padding: const EdgeInsets.symmetric(horizontal: 2.0))
            ],
          );
        }).toList());
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
                                  style: new TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                new Text(
                                  Parser.parseEventDateName(event.startDate),
                                  textScaleFactor: 0.9,
                                  textAlign: TextAlign.left,
                                  style: new TextStyle(
                                      fontFamily: "Prompt",
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold),
                                ),
                                new ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: event.times.length,
                                  itemBuilder: (context, i) => new Text(
                                        "${event.times[i].from} ~ ${event.times[i].to} ${event.times[i].after ? '++' : ''}",
                                        textScaleFactor: 0.6,
                                        textAlign: TextAlign.left,
                                        style: new TextStyle(
                                            fontFamily: "Prompt",
                                            fontSize: 16.0),
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
                                      fontFamily: "Prompt",
                                      color: Application.mainColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0),
                                ),
                                new Text(event.summary,
                                    textScaleFactor: 0.85,
                                    textAlign: TextAlign.left,
                                    style: new TextStyle(
                                        fontFamily: "Prompt", fontSize: 16.0)),
                                new Padding(
                                    padding: const EdgeInsets.only(top: 4.0)),
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
  final Function onRefreshPull;
  EventList({Key key, this.events, this.onRefreshPull}) : super(key: key);

  @override
  State<StatefulWidget> createState() => new EventListState(onRefreshPull);
}

class EventListState extends State<EventList> {
  final Function onRefreshPull;
  EventListState(this.onRefreshPull);

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
                child: new RefreshIndicator(
                    onRefresh: () {
                      return new Future.value(onRefreshPull());
                    },
                    child: new ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: widget.events.length,
                      itemBuilder: (context, i) =>
                          new EventListItem(widget.events[i]),
                    )))
          ],
        ),
      ),
    );
  }
}
