import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as PathPkg;
import 'package:path_provider/path_provider.dart';


main() {

WidgetsFlutterBinding.ensureInitialized();

runApp(
    MaterialApp(
        home: listSandbox()
    )
    );
}

class listSandbox extends StatefulWidget {
  const listSandbox({Key? key}) : super(key: key);

  @override
  _listSandboxState createState() => _listSandboxState();
}

class _listSandboxState extends State<listSandbox> {
  late TextEditingController TextController;
  String name = '';

  @override
  void initState() {
    super.initState();
    TextController = TextEditingController();
  }

  @override
  void dispose() {
    TextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        appBar: AppBar(
          title: Text('Your Experiments')
        ),

        body: Center(
          child: FutureBuilder<List<Model>>(
            future: DatabaseHelperSandbox.instance.getExperiments(),
            builder: (BuildContext context,

                AsyncSnapshot<List<Model>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              return snapshot.data!.isEmpty
                ? Center(child: Text('No Experiments Added'))
                : ListView(
                    children: snapshot.data!.map((experiment) {
                        return Center(
                          child: ListTile(

                            leading: IconButton(
                              icon: Icon(IconData(0xe91c, fontFamily: 'MaterialIcons') ),
                              onPressed: () async {
                                TextController.text = experiment.experiment;
                                final name = await openDialog('Enter New Experiment Name', 'Your Experiment');
                                if (name == null || name.isEmpty) return;
                                setState( () => this.name = name);
                                await DatabaseHelperSandbox.instance.update(Model(id: experiment.id, experiment: name));
                                TextController.clear();
                             },
                            ),

                            title: Text(experiment.experiment),

                            trailing: IconButton(
                              icon: Icon( IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                              onPressed: () {
                                setState(() {
                                  DatabaseHelperSandbox.instance.remove(experiment.id!);
                                });
                              }),
                          )
                        );
                  }).toList(),
                );
            }

          ),
        ),

        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final name = await openDialog('Enter Experiment Name', 'Your Experiment');
            if (name == null || name.isEmpty) return;

            setState( () => this.name = name);

            await DatabaseHelperSandbox.instance.add(
              Model(experiment: name),
            );

            TextController.clear();

          },
        ),
    );
  }

  Future<String?> openDialog(String title, String hint) => showDialog<String?>(
    context:  context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: TextField(
        autofocus: true,
        decoration: InputDecoration(hintText: hint),
        controller: TextController,
    ),

      actions: [
        TextButton(
          child: Text('SUBMIT'),
          onPressed: () {
            Navigator.of(context).pop(TextController.text);
          },
        )
      ],

    ),
  ); // Future Dialog function end
}

class Model {
  final int? id;
  final String experiment;

  Model({this.id, required this.experiment});

  factory Model.fromMap(Map<String, dynamic> json) => new Model(
    id: json['id'],
    experiment: json['experiment']
  );

  Map<String, dynamic> toMap() {
    return {
      'id' : id,
      'experiment' : experiment
    };
  }
}

class DatabaseHelperSandbox {
  DatabaseHelperSandbox._privateConstructor();
  static final DatabaseHelperSandbox instance = DatabaseHelperSandbox._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = PathPkg.join(documentsDirectory.path, 'experiments.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE experiments(
        id INTEGER PRIMARY KEY,
        experiment TEXT
      )
    ''');
  }

  Future<List<Model>> getExperiments() async {
    Database db = await instance.database;
    var experiments = await db.query('experiments', orderBy: 'experiment');
    List<Model> experimentList = experiments.isNotEmpty
      ? experiments.map((c) => Model.fromMap(c)).toList()
        : [];
    return experimentList;
  }

  Future<int> add(Model experiment) async {
    Database db = await instance.database;
    return await db.insert('experiments', experiment.toMap());
  }

  Future<int> remove(int id) async {
    Database db = await instance.database;
    return await db.delete('experiments', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> update(Model experiment) async {
    Database db = await instance.database;
    return await db.update('experiments', experiment.toMap(), where: 'id = ?', whereArgs: [experiment.id]);
  }

}