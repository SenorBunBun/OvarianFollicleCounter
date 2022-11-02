import 'dart:io';

import 'package:ovarian_counter/SQLFlite%20Testing/TreatmentWidget.dart';

import '../flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';

import 'SQLflite.dart';


import 'package:ovarian_counter/counter/counter_widget.dart';
/*
runApp(
    MaterialApp(
        home: Dogs()AA
    )
    );
}

 */

class SectionWidget extends StatefulWidget {
  final Model prevPos;

  const SectionWidget({Key? key, required this.prevPos}) : super(key: key);

  @override
  _SectionWidgetState createState() => _SectionWidgetState();
}

class _SectionWidgetState extends State<SectionWidget> {
  late TextEditingController TextController;
  String name = '';
  List<Model> queuedSections = [];

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
          title: Text("Your Sections in ${widget.prevPos.treatment} for ${widget.prevPos.dog}")
      ),

      body: Center(
        child: FutureBuilder<Map<String, List<Model>>>(
            future: DatabaseHelper.instance.getExpData(['id', 'experiment', 'Dog_ID', 'Treatment', 'Section', 'Primordial', 'Transitional', 'Primary', 'Secondary', 'Early_Antral', 'Antral', 'Dead'],
                'experiment=? and Dog_ID=? and Treatment=?', [widget.prevPos.experiment, widget.prevPos.dog, widget.prevPos.treatment], 'Section'),
            builder: (BuildContext context,

                AsyncSnapshot<Map<String, List<Model>>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              queuedSections = snapshot.data!['queue']!;
              return snapshot.data!['display']!.isEmpty
                  ? Center(child: Text("No Sections Added in ${widget.prevPos.treatment} for ${widget.prevPos.dog}"))
                  : ListView(
                children: snapshot.data!['display']!.map((section) {

                  return Center(
                      child: ListTile(
                        //navigating

                              onTap: () async {

                                await Navigator.push(
                                  context,
                                  /*
                                  PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    duration: Duration(milliseconds: 20),
                                    reverseDuration: Duration(milliseconds: 8),
                                    child: Scaffold(
                                        body: CounterWidget(prevPos: Model(id: section.id, experiment: section.experiment, dog: section.dog, treatment: section.treatment, section: section.section,
                                        primordial: section.primordial, transitional:section.transitional, primary: section.primary, secondary: section.secondary, earlyantral: section.earlyantral, antral: section.antral, dead: section.dead) )
                                    ),
                                  ),
                                  
                                   */
                                  MaterialPageRoute(
                                    builder: (context) => Scaffold(
                                    body: CounterWidget(prevPos: Model(id: section.id, experiment: section.experiment, dog: section.dog, treatment: section.treatment, section: section.section,
                                        primordial: section.primordial, transitional:section.transitional, primary: section.primary, secondary: section.secondary, earlyantral: section.earlyantral, antral: section.antral, dead: section.dead) )
                                ),
                                )
                                ).then( (val) => setState(() {}));
                              },

                        //editing
                        leading: IconButton(
                          icon: Icon(const IconData(0xe91c, fontFamily: 'MaterialIcons') ),
                          onPressed: () async {

                            TextController.text = section.section!;
                            final name = await openDialog('Enter New Section', 'Your Section');
                            if (name == null || name.isEmpty) return;
                            setState( ()  {
                              this.name = name;

                              DatabaseHelper.instance.update(
                                  ['id', 'experiment', 'Dog_ID', 'Treatment', 'Section'],
                                  "experiment=? and Dog_ID=? and Treatment=? and Section=?",
                                  [widget.prevPos.experiment, widget.prevPos.dog, widget.prevPos.treatment, section.section],
                                  'Section', name);
                              TextController.clear();
                            });

                          },
                        ),

                        title: Text(section.section.toString()),

                        //deleting
                        trailing: IconButton(
                            icon: Icon( const IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                            onPressed: () {
                              setState(() {
                                DatabaseHelper.instance.removeExpData(['id', 'experiment', 'Dog_ID', 'Treatment', 'Section'],
                                    'experiment=? and Dog_ID=? and Treatment=? and Section=?',
                                    [widget.prevPos.experiment, widget.prevPos.dog, widget.prevPos.treatment, section.section], widget.prevPos);
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
          final name = await openDialog('Enter Section', 'Your Section');
          if (name == null || name.isEmpty) return;

          setState( () => this.name = name);

          await DatabaseHelper.instance.add(queuedSections,
            Model(experiment: widget.prevPos.experiment, dog: widget.prevPos.dog, treatment: widget.prevPos.treatment, section: name),
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

