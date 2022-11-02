import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathPkg;
import 'package:path_provider/path_provider.dart';
import 'export.dart';
import 'package:share_plus/share_plus.dart';

import 'MultiColTest.dart';

String dbName = "experiments12";

class Model {

  final int? id;
  final String experiment;
  final String? dog;
  final String? treatment;
  final String? section;

  final int? primordial;
  final int? transitional;
  final int? primary;
  final int? secondary;
  final int? earlyantral;
  final int? antral;
  final int? dead;

  Model({this.id, required this.experiment, this.dog, this.treatment, this.section,
    primordial, transitional, primary, secondary, earlyantral, antral, dead})
      : this.primordial  = primordial ?? 0,
        this.transitional = transitional ?? 0,
        this.primary = primary ?? 0,
        this.secondary = secondary ?? 0,
        this.earlyantral = earlyantral ?? 0,
        this.antral = antral ?? 0,
        this.dead = dead ?? 0;

  factory Model.fromMap(Map<String, dynamic> json) => new Model(
    id: json['id'],
    experiment: json['experiment'],
    dog: json['Dog_ID'],
    treatment: json['Treatment'],
    section: json['Section'],

    primordial: json['Primordial'],
    transitional: json['Transitional'],
    primary: json['Primary'],
    secondary: json['Secondary'],
    earlyantral: json['Early_Antral'],
    antral: json['Antral'],
    dead: json['Dead']

  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'experiment' : experiment,
      'Dog_ID' : dog,
      'Treatment' : treatment,
      'Section' : section,

      'Primordial' : primordial,
      'Transitional' : transitional,
      'Primary' : primary,
      'Secondary' : secondary,
      'Early_Antral' : earlyantral,
      'Antral' : antral,
      'Dead' : dead

    };

  }

}

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = PathPkg.join(documentsDirectory.path, dbName + ".db");
    print(path);
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,


    );
  }
  /*
  void _onUpgrade(Database db, int oldVersion, int newVersion) {
    print("Upgrading...");
    if(newVersion == 2) {
      db.execute("ALTER TABLE experiments ADD COLUMN dog TEXT;");
    }
  }

   */

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $dbName(
        id INTEGER PRIMARY KEY,
        experiment TEXT,
        Dog_ID TEXT,
        Treatment TEXT,
        Section TEXT,
        Primordial INTEGER,
        Transitional INTEGER,
        "Primary" INTEGER,
        Secondary INTEGER,
        Early_Antral INTEGER,
        Antral INTEGER,
        Dead INTEGER
      )
    ''');
  }

  Future<List<Model>> getExperiments() async {
    Database db = await instance.database;
    var experiments = await db.query(dbName, distinct: true, columns: ['experiment'], orderBy: "experiment");
    

    //print(experiments);
    List<Model> experimentList = experiments.isNotEmpty
        ? experiments.map((c) => Model.fromMap(c)).toList()
        : [];
    return experimentList;
  }

  /*
  Future<List<Model>> getDogs(Model experiment) async {
    Database db = await instance.database;
    var experiments = await db.query(dbName, distinct: true, columns: ['experiment', 'dog'], where: 'experiment=?', whereArgs: [experiment.experiment], orderBy: 'dog');

    List<Model> experimentList = experiments.isNotEmpty
        ? experiments.map((c) => Model.fromMap(c)).toList()
        : [];
    return experimentList;
  }

   */

  Future<Map<String, List<Model>>> getExpData(List<String> cols, String whereStr, List<Object?> argList, String currentCol) async {
    Database db = await instance.database;
    bool nullFound = false;
    List<Map<String, Object?>> validData = [];
    List<Model> nullData = [];

    //groupBy acts like distinct for a single col
    var queriedData = await db.query(dbName, columns: cols, where: whereStr, whereArgs: argList, orderBy: currentCol, groupBy: currentCol);
    print(queriedData);
    queriedData.forEach((element) {
      if(!nullFound && element[currentCol] == null){
        /*
        print("Null Found");
        print(element);

         */
        nullData.add(Model.fromMap(element));
        //print(nullData);
        nullFound = true;
      }
      else {
        validData.add(element);
      }
    });

    List<Model> displayData = validData.isNotEmpty
        ? validData.map((c) => Model.fromMap(c)).toList()
        : [];
    print(nullData);
    print(displayData);
    return {'display': displayData, 'queue' : nullData};
  }

  Future<int> add(List<Model> queuedData, Model experiment) async {
    Database db = await instance.database;
    var expMap = experiment.toMap();
    //print(expMap);
    if (queuedData.isNotEmpty){
      int currentID = queuedData.elementAt(0).id!;
      expMap['id'] = currentID;
      //print(expMap);
      return await db.update(dbName, expMap, where: "id=?", whereArgs: [queuedData.elementAt(0).id]);
    }

    return await db.insert(dbName, expMap);
  }

  removeExp(Model experiment) async {
    Database db = await instance.database;
    return await db.delete(dbName, where: 'experiment = ?', whereArgs: [experiment.experiment]);
  }

  removeExpData(List<String> cols, String whereStr, List<Object?> argList, Model prevPos) async {
    Database db = await instance.database;
    var base;
    int counter = 0;

    var ids = await db.query(dbName, columns:  cols, where: whereStr, whereArgs: argList);
    ids.forEach((element) {
      if (counter == 0){
        //needs to be updated for additional cols, (I believe it requires previousPos for the current col to be null)
        base = Model(id: element['id'] as int, experiment: prevPos.experiment, dog: prevPos.dog, treatment: prevPos.treatment, section: prevPos.section,
            primordial: 0, transitional: 0, primary: 0, secondary: 0, earlyantral: 0, antral: 0, dead: 0
        );
        db.update(dbName, base.toMap(), where: 'id=?', whereArgs: [element['id']]);
        counter = 1;
      }
      else {
        db.delete(dbName, where: 'id = ?', whereArgs: [element['id']]);
      }
    });
  }

  update(List<String> cols, String whereStr, List<Object?> argList, String currentCol, String newName) async {
    Database db = await instance.database;
    var tempElement;
    var ids = await db.query(dbName, columns: cols, where: whereStr, whereArgs: argList);
    ids.forEach((element) {
      tempElement = Map.of(element);
      tempElement[currentCol] = newName;
      db.update(dbName, tempElement, where: "id=?", whereArgs: [tempElement['id']]);
    });
  }

  saveFollicleCounts(Model counterData) async {
    Database db = await instance.database;
    db.update(dbName, counterData.toMap(), where: "id=?", whereArgs: [counterData.id]);
  }

  Future<bool> export(String ExperimentName) async {
    Database db = await instance.database;
    //needs to be updated for additional cols
    var CleanExperiment = await db.query(dbName, columns: ['Dog_ID', 'Treatment', 'Section', 'Primordial', 'Transitional', 'Primary', 'Secondary', 'Early_Antral', 'Antral', 'Dead'],
        where: 'experiment=? and Dog_ID!=? and Treatment!=? and Section!=?', whereArgs: [ExperimentName, "null", "null", "null"]);

    if(CleanExperiment.isNotEmpty) {
      var csvString = await mapListToCsv(CleanExperiment);

      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      print(documentsDirectory);
      var csvFile = File('${documentsDirectory.path}/${ExperimentName}.csv');
      csvFile.writeAsString(csvString!);

      await Share.shareFiles([csvFile.path]);
      return true;
    }
    else {
      return false;
    }
  }

}


