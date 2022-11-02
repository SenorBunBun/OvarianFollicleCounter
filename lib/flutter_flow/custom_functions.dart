import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';

String toggleText(int? toggle) {
  if (toggle! > 0) {
    return "Currently Adding (Tap to Switch)";
  } else {
    return "Currently Subtracting (Tap to Switch)";
  }
  // Add your function code here!
}

int toggleIncrement(int? toggle) {
  if (toggle! > 0) {
    return -1;
  } else {
    return 1;
  }
  // Add your function code here!
}
