import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'route_handlers.dart';

class Routes {
  static void configRoutes(Router router) {
    router.define("/events/:id", handler: eventHandler);
  }
}