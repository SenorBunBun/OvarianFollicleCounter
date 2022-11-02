import 'dart:io';

import 'package:ovarian_counter/SQLFlite%20Testing/SectionWidget.dart';
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

class TreatmentWidget extends StatefulWidget {
  final Model prevPos;
  const TreatmentWidget({Key? key, required this.prevPos}) : super(key: key);

  @override
  _TreatmentWidgetState createState() => _TreatmentWidgetState();
}

class _TreatmentWidgetState extends State<TreatmentWidget> {
  late TextEditingController TextController;
  String name = '';
  List<Model> queuedTreatments = [];

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
          title: Text("Your Treatments for  ${widget.prevPos.dog}"),

      ),

      body: Center(
        child: FutureBuilder<Map<String, List<Model>>>(
            future: DatabaseHelper.instance.getExpData(['id', 'experiment', 'Dog_ID', 'Treatment'] , 'experiment=? and Dog_ID=?', [widget.prevPos.experiment, widget.prevPos.dog], 'Treatment'),
            builder: (BuildContext context,

                AsyncSnapshot<Map<String, List<Model>>> snapshot) {
              if (!snapshot.hasData) {
                return Center(child: Text('Loading...'));
              }
              queuedTreatments = snapshot.data!['queue']!;
              return snapshot.data!['display']!.isEmpty
                  ? Center(child: Text("No Treatments Added for ${widget.prevPos.dog}"))
                  : ListView(
                children: snapshot.data!['display']!.map((treatment) {

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
                                        body: SectionWidget(prevPos: Model(experiment: widget.prevPos.experiment, dog: widget.prevPos.dog, treatment: treatment.treatment) )
                                    ),
                                  ),

                                   */
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                          body: SectionWidget(prevPos: Model(experiment: widget.prevPos.experiment, dog: widget.prevPos.dog, treatment: treatment.treatment) )
                                      ),
                                    )
                                ).then( (val) => setState(() {}));
                              },



                        //editing
                        leading: IconButton(
                          icon: Icon(const IconData(0xe91c, fontFamily: 'MaterialIcons') ),
                          onPressed: () async {

                            TextController.text = treatment.treatment!;
                            final name = await openDialog('Enter New Treatment', 'Your Treatment');
                            if (name == null || name.isEmpty) return;
                            setState( ()  {
                              this.name = name;

                              DatabaseHelper.instance.update(
                                  ['id', 'experiment', 'Dog_ID', 'Treatment'],
                                  "experiment=? and Dog_ID=? and Treatment=?",
                                  [widget.prevPos.experiment, widget.prevPos.dog, treatment.treatment],
                                  'Treatment', name);
                              TextController.clear();
                            });

                          },
                        ),

                        title: Text(treatment.treatment.toString()),

                        //deleting
                        trailing: IconButton(
                            icon: Icon( const IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                            onPressed: () {
                              setState(() {
                                DatabaseHelper.instance.removeExpData(['id', 'experiment', 'Dog_ID', 'Treatment'], 'experiment=? and Dog_ID=? and Treatment=?', [widget.prevPos.experiment, widget.prevPos.dog, treatment.treatment], widget.prevPos);
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
          final name = await openDialog('Enter Treatment', 'Your Treatment');
          if (name == null || name.isEmpty) return;

          setState( () => this.name = name);

          await DatabaseHelper.instance.add(queuedTreatments,
            Model(experiment: widget.prevPos.experiment, dog: widget.prevPos.dog, treatment: name),
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

