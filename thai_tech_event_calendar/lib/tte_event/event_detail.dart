import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/application.dart';
import '../models/event/event.dart';
import '../models/event/link.dart';
import '../models/event/time.dart';
import 'event_client.dart';

class EventDetail extends StatefulWidget {
  final Event event;
  EventDetail(String eventId)
      : event = new EventClient().getEventById(eventId),
        super(key: new ObjectKey(eventId));

  @override
  State<StatefulWidget> createState() => new EventDetailState(event);
}

class EventDetailState extends State<EventDetail> {
  final Event event;
  EventDetailState(this.event);

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  void onLocationTapUp(TapUpDetails details) async {
    setState(() {
      _locationHover = false;
    });
    launchUrl(widget.event.location.url);
  }

  void onLocationTapDown(TapDownDetails details) {
    setState(() {
      _locationHover = true;
    });
  }

  void onLocationTapCancel() {
    setState(() {
      _locationHover = false;
    });
  }

  bool _locationHover = false;

  String parseLinkDetail(Link link) {
    var detail = "";
    if (link.detail != "") {
      detail += link.detail;
    }

    if (link.price != "") {
      if (detail != "") {
        detail += ", ";
      }
      detail += link.price;
    }
    return detail;
  }

  IconData getLinkIcon(String linkType) {
    switch (linkType) {
      case "rsvp":
        return FontAwesomeIcons.calendarCheckO;
      case "ticket":
        return FontAwesomeIcons.ticketAlt;
      default:
        return FontAwesomeIcons.link;
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.event.title),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Flexible(
              child: new ListView(
                  addAutomaticKeepAlives: true,
                  primary: true,
                  children: <Widget>[
                    new Container(
                        padding: const EdgeInsets.all(12.0),
                        child: new Text(widget.event.title,
                            textScaleFactor: 1.0,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0))),
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: new Text("Info",
                          textScaleFactor: 1.2,
                          style: new TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    new Container(
                      height: 50.0,
                      child: new ListTile(
                        leading: new Icon(FontAwesomeIcons.tags),
                        title: new Text(
                            widget.event.tags.reduce((a, b) => "$a, $b")),
                      ),
                    ),
                    //const Divider(),
                    new Container(
                      height: 50.0,
                      child: new ListTile(
                          leading: new Icon(FontAwesomeIcons.clockO),
                          title: new Text(new DateFormat("EEEE, d MMMM yyyy")
                              .format(widget.event.startDate)),
                          subtitle: new Text(
                            widget.event.times
                                .map((Time t) =>
                                    "${t.from} ~ ${t.to} ${t.after ? '++' : ''}")
                                .join(", "),
                            textScaleFactor: 0.9,
                          )),
                    ),
                    //const Divider(),
                    new Container(
                      height: 50.0,
                      child: new GestureDetector(
                          onTapDown: onLocationTapDown,
                          onTapUp: onLocationTapUp,
                          onTapCancel: onLocationTapCancel,
                          child: new Container(
                            color:
                                _locationHover ? Colors.blue : Colors.white10,
                            child: new ListTile(
                              leading: new Icon(FontAwesomeIcons.mapMarkerAlt),
                              title: new Text(
                                widget.event.location.title,
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Application.mainColor),
                              ),
                              subtitle: new Text(widget.event.location.detail,
                                  textScaleFactor: 0.9),
                              trailing:
                                  new Icon(FontAwesomeIcons.externalLinkAlt),
                            ),
                          )),
                    ),
                    const Divider(),
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 20.0, right: 8.0),
                      child: new Text("Links",
                          textScaleFactor: 1.2,
                          style: new TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    new ListView.builder(
                      shrinkWrap: true,
                      physics: new NeverScrollableScrollPhysics(),
                      primary: false,
                      itemCount: widget.event.links.length,
                      itemBuilder: (context, i) {
                        return new Container(
                          height: 50.0,
                          child: new ListTile(
                            onTap: () {
                              launchUrl(widget.event.links[i].url);
                            },
                            leading: new Icon(
                                getLinkIcon(widget.event.links[i].type)),
                            title: new Text(widget.event.links[i].title,
                                style: new TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Application.mainColor)),
                            subtitle: new Text(
                                parseLinkDetail(widget.event.links[i])),
                            trailing: new Text(
                                widget.event.links[i].type.toUpperCase(),
                                style:
                                    new TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        );
                      },
                    ),
                    const Divider(),
                    new Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, top: 8.0, right: 8.0),
                      child: new Text("Details",
                          textScaleFactor: 1.2,
                          style: new TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: new BoxDecoration(
                            color: Colors.white,
                            borderRadius: new BorderRadius.circular(8.0)),
                        child: new Text(widget.event.description),
                      ),
                    )
                  ]),
            )
          ],
        ));
  }
}
