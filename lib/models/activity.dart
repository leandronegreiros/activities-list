import 'package:flutter/foundation.dart';

class Activity {
  String id;
  String title;
  bool active;
  DateTime date;

  Activity({
    required this.id,
    required this.title,
    required this.active,
    required this.date
  });
}