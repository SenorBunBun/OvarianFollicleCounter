import 'dart:io';

import 'package:ovarian_counter/SQLFlite%20Testing/TreatmentWidget.dart';

import '../flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';

import 'SQLflite.dart';
import 'TreatmentWidget.dart';

main() {
  var a = Model(experiment: "test");
  print(a.toMap());
  var b = Model(experiment: "test", primordial: 1, transitional: 1, primary: 1, secondary: 1, earlyantral: 1, antral: 1, dead: 1);
  var c = b.toMap();
  print(Model.fromMap(c).toMap());

}