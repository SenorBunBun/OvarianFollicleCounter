import 'dart:io';
import 'dart:math';

import '../flutter_flow/flutter_flow_util.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'SQLflite.dart';
import 'DogWidget.dart';

main() {

WidgetsFlutterBinding.ensureInitialized();

runApp(
    MaterialApp(
        home: MultiColTest()
    )
    );
}

class MultiColTest extends StatefulWidget {
  const MultiColTest({Key? key}) : super(key: key);

  @override
  _MultiColTestState createState() => _MultiColTestState();
}

class _MultiColTestState extends State<MultiColTest> {
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
            future: DatabaseHelper.instance.getExperiments(),
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
                          child: Slidable(

                            startActionPane: ActionPane(
                              extentRatio: 0.3,
                              motion: DrawerMotion(),
                              children: [
                                  SlidableAction(
                                      onPressed: ((context) async {
                                            var exportResult = await DatabaseHelper.instance.export(experiment.experiment);
                                            if (exportResult) {
                                              //openAlert("Export Successful", "${experiment.experiment} was successfully exported");
                                            }
                                            else {
                                              openAlert("Export Failed", "Error: ${experiment.experiment} did not have a Dog ID, Treatment, or Section");
                                            }
                                         }),
                                      backgroundColor: Colors.green,
                                      icon: Icons.share,

                                    )
                                  ],

                              ),

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
                                        body: DogWidget(prevPos: Model(experiment: experiment.experiment),)
                                      ),
                                    ),

                                    */
                                    MaterialPageRoute(
                                        builder: (context) => Scaffold(
                                            body: DogWidget(prevPos: Model(experiment: experiment.experiment),)
                                        ),
                                    )

                                  ).then( (val) => setState(() {}));
                                },

                                //editng
                                leading: IconButton(
                                  icon: Icon(const IconData(0xe91c, fontFamily: 'MaterialIcons') ),
                                  onPressed: () async {
                                    TextController.text = experiment.experiment;
                                    final name = await openDialog('Enter New Experiment Name', 'Your Experiment');
                                    if (name == null || name.isEmpty) return;
                                    setState( () {
                                      this.name = name;
                                      DatabaseHelper.instance.update(
                                          ['id', 'experiment'], "experiment=?",
                                          [experiment.experiment], 'experiment',
                                          name);
                                      TextController.clear();
                                    });

                                 },
                                ),

                                title: Text(experiment.experiment),

                                //deleting
                                trailing: IconButton(
                                  icon: Icon( const IconData(0xe1b9, fontFamily: 'MaterialIcons')),
                                  onPressed: () {
                                    setState(() {
                                      DatabaseHelper.instance.removeExp(experiment);
                                    });
                                  }),
                              ),

                          )
                        );
                  }).toList(),
                );
            }

          ),
        ),

        //adding
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () async {
            final name = await openDialog('Enter Experiment Name', 'Your Experiment');
            if (name == null || name.isEmpty) return;

            setState( () => this.name = name);

            await DatabaseHelper.instance.add(
              [], //empty for nullcheck for future cols
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

  openAlert(String title, String content) => showDialog<String?>(
    context:  context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(content),

      actions: [
        TextButton(
          child: Text('OK'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],

    ),
  );


}

