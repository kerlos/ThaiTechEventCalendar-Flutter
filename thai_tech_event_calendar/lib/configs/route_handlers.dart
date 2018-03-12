import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import '../tte_event/event_detail.dart';

Handler eventHandler = new Handler(handlerFunc: (BuildContext context, Map<String,dynamic> params) { 
  return new EventDetail(params["id"]);
});