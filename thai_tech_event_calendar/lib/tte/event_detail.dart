import 'dart:async';
import 'dart:developer';
import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/application.dart';
import '../managers/notification_manager.dart';
import '../models/event/event.dart';
import '../models/event/link.dart';
import '../models/event/notification.dart';
import '../models/event/time.dart';
import 'event_client.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

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
  List<int> reminds = [30,60,180,360,720,1440,0];
  NotificationManager notiManager = new NotificationManager();

  void launchUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    }
  }

  @override
  void initState() {
    super.initState();
    loadNotification();
  }

  void loadNotification() async{
    await notiManager.notifications.open();
    var existNotification = await notiManager.notifications.getNotification(event.id);
    await notiManager.notifications.close();
    setState(() {
      notification = existNotification;
    });
  }

  String getNotificationRemindText(int remind) {
    switch(remind){
      case 30:
        return "30 Minutes before";
      case 60:
        return "1 Hour before";
      case 180:
        return "3 Hours before";
      case 360:
        return "6 Hours before";
      case 720:
        return "12 Hours before";
      case 1440:
        return "1 Day before";
      default:
        return "Never";
    }
  }

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

  IconData getNotificationIcon() {
    if(notification == null) {
      return FontAwesomeIcons.bellO;
    } else if(notification.isFinished || notification.remindOffset == 0) {
      return FontAwesomeIcons.bellO;
    } else {
      return FontAwesomeIcons.bell;
    }
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
  NotificationData notification;

  void activateNotification(int remind) async {
    if(notification == null){
      notification = new NotificationData(event.startDate,remind,event.id,false);
      await notiManager.notifications.open();
      await notiManager.notifications.insert(notification);
      await notiManager.notifications.close();

    }
    else {
      notification.isFinished = false;
      notification.remindOffset = remind;
      await notiManager.notifications.open();
      await notiManager.notifications.update(notification);
      await notiManager.notifications.close();
    }
  }

  void deactivateNotification(int remind) async {
    notification.isFinished = true;
    await notiManager.notifications.open();
    await notiManager.notifications.update(notification);
    await notiManager.notifications.close();
  }

  void updateNotification(int remind) async {
    notification.remindOffset = remind;
    await notiManager.notifications.open();
    await notiManager.notifications.update(notification);
    await notiManager.notifications.close();
  }

  void _setNotification(int remind) {
    //TODO Add working local notification
    setState(() {
      if (notification == null || notification.isFinished) {
        activateNotification(remind);
      }
      else if (notification.remindOffset != remind){
        updateNotification(remind);
      }
      else if (remind == 0) {
        deactivateNotification(remind);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.event.title),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
          actions: <Widget>[
            new PopupMenuButton<int>(
              onSelected: _setNotification,
              icon:  new Icon(getNotificationIcon()),
              itemBuilder: (BuildContext context) {
                return reminds.map((int remind)  {
                  return new PopupMenuItem<int>(
                    value: remind,
                    child: new Row(
                      children: <Widget>[
                        new Radio(
                          onChanged: _setNotification,
                          groupValue: notification != null && notification.remindOffset != null ? notification.remindOffset : 0,
                          value: remind,
                        ),
                        new Text(
                          getNotificationRemindText(remind),
                          textAlign: TextAlign.left,
                        )
                      ],
                    )
                  );
                }).toList();
              },
            )
          ],
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
                        leading:
                            new Center(child: new Icon(FontAwesomeIcons.tags)),
                        title: new Text(
                            widget.event.tags.reduce((a, b) => "$a, $b")),
                      ),
                    ),
                    //const Divider(),
                    new Container(
                      height: 50.0,
                      child: new ListTile(
                          leading: new Center(
                              child: new Icon(FontAwesomeIcons.clockO)),
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
                      child: new Container(
                        child: new ListTile(
                          onTap: () {
                            launchUrl(widget.event.location.url);
                          },
                          leading: new Center(
                              child: new Icon(FontAwesomeIcons.mapMarkerAlt)),
                          title: new Text(
                            widget.event.location.title,
                            style: new TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Application.mainColor),
                          ),
                          subtitle: new Text(widget.event.location.detail,
                              textScaleFactor: 0.9),
                          trailing: new Icon(FontAwesomeIcons.externalLinkAlt),
                        ),
                      ),
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
                            leading: new Center(
                              child: new Icon(
                                  getLinkIcon(widget.event.links[i].type)),
                            ),
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
                          padding: const EdgeInsets.all(12.0),
                          decoration: new BoxDecoration(
                              color: const Color(0xfff5f2f0),
                              border: new Border.all(
                                  color:
                                      const Color.fromARGB(255, 204, 204, 204)),
                              borderRadius: new BorderRadius.circular(8.0)),
                          child: new MarkdownBody(
                              data:
                                  "> ${widget.event.summary}\n\n${widget.event.description}",
                              styleSheet: new MarkdownStyleSheet(
                                a: const TextStyle(color: Colors.blue),
                                p: theme.textTheme.body1,
                                code: new TextStyle(
                                    color: Colors.grey.shade700,
                                    fontFamily: "monospace",
                                    fontSize:
                                        theme.textTheme.body1.fontSize * 0.85),
                                h1: theme.textTheme.headline,
                                h2: theme.textTheme.title,
                                h3: theme.textTheme.subhead,
                                h4: theme.textTheme.body2,
                                h5: theme.textTheme.body2,
                                h6: theme.textTheme.body2,
                                em: const TextStyle(
                                    fontStyle: FontStyle.italic),
                                strong: const TextStyle(
                                    fontWeight: FontWeight.bold),
                                blockquote: theme.textTheme.body1,
                                img: theme.textTheme.body1,
                                blockSpacing: 8.0,
                                listIndent: 32.0,
                                blockquotePadding: 8.0,
                                blockquoteDecoration: new BoxDecoration(
                                    color: Colors.amber.shade100,
                                    borderRadius:
                                        new BorderRadius.circular(2.0),
                                    border: new Border.all(
                                        color: Colors.orange.shade200)),
                                codeblockPadding: 8.0,
                                codeblockDecoration: new BoxDecoration(
                                    color: Colors.grey.shade100,
                                    borderRadius:
                                        new BorderRadius.circular(2.0)),
                                horizontalRuleDecoration: new BoxDecoration(
                                  border: new Border(
                                      top: new BorderSide(
                                          width: 5.0,
                                          color: Colors.grey.shade300)),
                                ),
                              ))),
                    )
                  ]),
            )
          ],
        ));
  }
}
