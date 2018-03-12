import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/models/event/event.dart';

import 'event_client.dart';


class EventDetail extends StatefulWidget {
  final Event event;
  EventDetail(String eventId)
    : event = new EventClient().getEventById(eventId),
      super (key: new ObjectKey(eventId));

  @override
  State<StatefulWidget> createState() => new EventDetailState(event);
}

class EventDetailState extends State<EventDetail> {
  final Event event;
  EventDetailState(this.event);

  Widget eventTags() {
    return new Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widget.event.tags.map((tag) {
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
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.event.title)
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new ListView(
            children: <Widget>[
              eventTags()
            ]
          )
        ],
      )
    );
  }

}