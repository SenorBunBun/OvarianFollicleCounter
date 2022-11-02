import '../flutter_flow/flutter_flow_animations.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import '../flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:ovarian_counter/SQLFlite Testing/SQLflite.dart';

class CounterWidget extends StatefulWidget {
  final Model prevPos;
  //int primordial;
  CounterWidget({ Key? key, required this.prevPos}) : super(key: key);


  @override
  _CounterWidgetState createState() => _CounterWidgetState();
}


Color CounterColorToggle(int toggle) {
  if(toggle > 0) {
    return Color(0xFFCB3847);
  }
  else {
      return Color(0xFF2745F2);
  }

}
Color FABColorToggle(int toggle) {
  if (toggle > 0) {
    return Color(0xFFBDC5F2);
  }
  else {
    return Color(0xFFF2BDBD);
  }
}
Color DeadColorToggle(int toggle) {
  if (toggle > 0) {
    return Color(0xFF000837);
  }
  else  {
    return Color(0xFF242B58);
  }
}

class _CounterWidgetState extends State<CounterWidget>
    with TickerProviderStateMixin {
  final animationsMap = {
    'columnOnPageLoadAnimation': AnimationInfo(
      trigger: AnimationTrigger.onPageLoad,
      duration: 600,
      hideBeforeAnimating: true,
      fadeIn: true,
      initialState: AnimationState(
        offset: Offset(0, 0),
        scale: 1,
        opacity: 0,
      ),
      finalState: AnimationState(
        offset: Offset(0, 0),
        scale: 1,
        opacity: 1,
      ),
    ),
  };
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    //widget.primordial += 2;

    super.initState();
    startPageLoadAnimations(
      animationsMap.values
          .where((anim) => anim.trigger == AnimationTrigger.onPageLoad),
      this,
    );
    Model prevPos = widget.prevPos;
    FFAppState().primordial = prevPos.primordial as int;
    FFAppState().Transitional = prevPos.transitional as int;
    FFAppState().Primary = prevPos.primary as int;
    FFAppState().Secondary = prevPos.secondary as int;
    FFAppState().EarlyAntral = prevPos.earlyantral as int;
    FFAppState().Antral = prevPos.earlyantral as int;
    FFAppState().Dead = prevPos.dead as int;
  }


  @override
  Widget build(BuildContext context) {




    /*
    int primordial = prevPos.primordial as int;
    int transitional = prevPos.transitional as int;
    int primary = prevPos.primary as int;
    int secondary = prevPos.secondary as int;
    int earlyantral = prevPos.earlyantral as int;
    int antral = prevPos.antral as int;
    int dead = prevPos.dead as int;
     */



    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: CounterColorToggle(FFAppState().AddToggle),
        //automaticallyImplyLeading: false,
        title: Align(
          alignment: AlignmentDirectional(0, 0),
          child: Text(
            'Follicle Counts for Section ${widget.prevPos.section}',
            textAlign: TextAlign.center,
            /*
            style: FlutterFlowTheme.of(context).title2.override(
                  fontFamily: 'Ubuntu',
                  color: Colors.white,
                  //fontSize: 22,
                ),

             */
          ),
        ),

        actions: <Widget>[
          IconButton(onPressed: () async{
            await DatabaseHelper.instance.saveFollicleCounts(Model(
                id: widget.prevPos.id, experiment: widget.prevPos.experiment, dog: widget.prevPos.dog, treatment: widget.prevPos.treatment, section: widget.prevPos.section,
                primordial: FFAppState().primordial, transitional: FFAppState().Transitional, primary: FFAppState().Primary, secondary: FFAppState().Secondary, earlyantral: FFAppState().EarlyAntral, antral: FFAppState().Antral, dead: FFAppState().Dead)
            );
          },
              icon: Icon(Icons.save))
        ],
        centerTitle: false,
        elevation: 2,
      ),
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          setState(() => FFAppState().AddToggle =
              functions.toggleIncrement(FFAppState().AddToggle));
        },
        backgroundColor: FABColorToggle(FFAppState().AddToggle),
        elevation: 8,
        label: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(
                  functions.toggleText(FFAppState().AddToggle),
                  style: FlutterFlowTheme.of(context).bodyText1,
                ),
              ],
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: AnimatedContainer(
            width: double.infinity,
            height:  double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
            ),
            duration: const  Duration(milliseconds: 500),
            child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 20, 2, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().primordial =
                                FFAppState().primordial +
                                    FFAppState().AddToggle);
                          },
                          text: FFAppState().primordial.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                          child: Text(
                            'Primordial',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(100, 20, 32, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().Transitional =
                                FFAppState().Transitional +
                                    FFAppState().AddToggle);
                          },
                          text: FFAppState().Transitional.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius:  BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(100, 0, 32, 0),
                          child: Text(
                            'Transitional',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 20, 2, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().Primary =
                                FFAppState().Primary + FFAppState().AddToggle);
                          },
                          text: FFAppState().Primary.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius:  BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                          child: Text(
                            'Primary',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(104, 20, 32, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().Secondary =
                                FFAppState().Secondary +
                                    FFAppState().AddToggle);
                          },
                          text: FFAppState().Secondary.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(100, 0, 32, 0),
                          child: Text(
                            'Secondary',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ) ,
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(32, 20, 2, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().EarlyAntral =
                                FFAppState().EarlyAntral +
                                    FFAppState().AddToggle);
                          },
                          text: FFAppState().EarlyAntral.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius:  BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(32, 0, 0, 0),
                          child: Text(
                            'Early Antral',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(100, 10, 32, 2),
                        child: FFButtonWidget(
                          onPressed: () async {
                            setState(() => FFAppState().Antral =
                                FFAppState().Antral  + FFAppState().AddToggle);
                          },
                          text: FFAppState().Antral.toString(),
                          options: FFButtonOptions(
                            width: 100,
                            height: 100,
                            color: CounterColorToggle(FFAppState().AddToggle),
                            textStyle:
                                FlutterFlowTheme.of(context).subtitle2.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.white,
                                      fontSize: 25,
                                    ),
                            borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 1,
                            ),
                            borderRadius:  BorderRadius.circular(75),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0.3, 0),
                        child: Padding(
                          padding:
                              EdgeInsetsDirectional.fromSTEB(100, 0, 32, 0),
                          child: Text(
                            'Antral',
                            textAlign: TextAlign.center,
                            style:
                                FlutterFlowTheme.of(context).bodyText1.override(
                                      fontFamily: 'Ubuntu',
                                      color: Colors.black,
                                      fontSize: 20,
                                      fontWeight: FontWeight.normal,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                          padding:
                          EdgeInsetsDirectional.fromSTEB(135, 20, 133, 2),
                          child: FFButtonWidget(
                            onPressed: () async {
                              setState(() => FFAppState().Dead =
                                  FFAppState().Dead + FFAppState().AddToggle);
                            },
                            text: FFAppState().Dead.toString(),
                            options: FFButtonOptions(
                              width: 100,
                              height: 100,
                              color: DeadColorToggle(FFAppState().AddToggle),
                              textStyle: FlutterFlowTheme.of(context)
                                  .subtitle2
                                  .override(
                                fontFamily: 'Ubuntu',
                                color: Colors.white,
                                fontSize: 25,
                              ),
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1,
                              ),
                              borderRadius:  BorderRadius.circular(75),
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Text(
                          'Dead',
                          textAlign: TextAlign.center,
                          style:
                          FlutterFlowTheme.of(context).bodyText1.override(
                            fontFamily: 'Ubuntu',
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          )
        ),
      ),
    );
  }
}
