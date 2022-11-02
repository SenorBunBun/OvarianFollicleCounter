import 'dart:io';

import 'package:ovarian_counter/SQLFlite%20Testing/TreatmentWidget.dart';

import '../flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';

import 'SQLflite.dart';
import 'TreatmentWidget.dart';

/*
runApp(
    MaterialApp(
        home: Dogs()AA
    )
    );
}

 */

class DogWidget extends StatefulWidget {
  final Model prevPos;
  const DogWidget({Key? key, required this.prevPos}) : super(key: key);

  @override
  _DogWidgetState createState() => _DogWidgetState();
}

class _DogWidgetState extends State<DogWidget> {
  late TextEditingController TextController;
  String name = '';
  List<Model> queuedDogs = [];

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
          title: Text("Your Dog ID's in ${widget.prevPos.experiment}")
        ),

        body: Center(
          child: FutureBuilder<Map<String, List<Model>>>(
            future: DatabaseHelper.instance.getExpData(['id', 'experiment', 'Dog_ID'] , 'experiment=?', [widget.prevPos.experiment], 'Dog_ID'),
            builder: (BuildContext context,

                AsyncSnapshot<Map<String, List<Model>>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              queuedDogs = snapshot.data!['queue']!;
              return snapshot.data!['display']!.isEmpty
                ? Center(child: Text("No Dog ID's Added in ${widget.prevPos.experiment}"))
                : ListView(
                    children: snapshot.data!['display']!.map((dog) {

                        return Center(
                          child: ListTile(

                            //navigating
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  /*
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 8),
                                    reverseDuration: Duration(milliseconds: 8),
                                    child: Scaffold(
                                        body: TreatmentWidget(prevPos: Model(experiment: widget.prevPos.experiment, dog: dog.dog),)
                                    ),
                                  )
                                  ,

                                   */

                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                          body: TreatmentWidget(prevPos: Model(experiment: widget.prevPos.experiment, dog: dog.dog),)
                                      ),
                                    )

                                ).then( (val) => setState(() {}));
                              },



                            //editing
                            leading: IconButton(
                              icon: Icon( const IconData(0xe91c, fontFamily: 'MaterialIcons') ),
                              onPressed: () async {

                                TextController.text = dog.dog!;
                                final name = await openDialog('Enter New Dog ID', 'Your Dog ID');
                                if (name == null || name.isEmpty) return;
                                setState( ()  {
                                  this.name = name;

                                  DatabaseHelper.instance.update(
                                      ['id', 'experiment', 'Dog_ID'],
                                      "experiment=? and Dog_ID=?",
                                      [widget.prevPos.experiment, dog.dog],
                                      'Dog_ID', name);
                                  TextController.clear();
                                });

                             },
                            ),

                            title: Text(dog.dog.toString()),

                            //deleting
                            trailing: IconButton(
                              icon: Icon( const IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                              onPressed: () {
                                setState(() {
                                  DatabaseHelper.instance.removeExpData(['id', 'experiment', 'Dog_ID'], 'experiment=? and Dog_ID=?', [widget.prevPos.experiment, dog.dog], widget.prevPos);
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
            final name = await openDialog('Enter Dog ID', 'Your Dog ID');
            if (name == null || name.isEmpty) return;

            setState( () => this.name = name);

            await DatabaseHelper.instance.add(queuedDogs,
              Model(experiment: widget.prevPos.experiment, dog: name),
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

