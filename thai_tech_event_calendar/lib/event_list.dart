import 'package:flutter/material.dart';
import 'package:thai_tech_event_calendar/models/event/event.dart';
import 'package:thai_tech_event_calendar/extensions/parser.dart';

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

  @override
  Widget build(BuildContext context) {
    return new Flex(
      direction: Axis.vertical,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Card(
            elevation: 3.0,
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
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              new Text(
                                event.summary,
                                textScaleFactor: 0.8,
                                textAlign: TextAlign.left,
                              )
                            ]))
                  ]),
            ))
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
            ))
          ],
        ),
      ),
    );
  }
}
