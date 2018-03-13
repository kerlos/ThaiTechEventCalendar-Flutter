import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../tte/event_detail.dart';

Handler eventHandler = new Handler(
    handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  var id = params["id"];
  if (id is String) {
    return new EventDetail(id);
  } else if (id is List) {
    return new EventDetail(id.first);
  }
});
