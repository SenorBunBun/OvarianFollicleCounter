//import '../experiments/experiments_widget.dart';
import '../flutter_flow/flutter_flow_theme.dart';
import '../flutter_flow/flutter_flow_util.dart';
import '../flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ovarian_counter/SQLFlite Testing/MultiColTest.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Color(0xFFF2F2F2),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 260, 0, 0),
                  child: Text(
                    'Ovarian Cell Counter',
                    textAlign: TextAlign.center,
                    style: FlutterFlowTheme.of(context).title1.override(
                          fontFamily: 'Ubuntu',
                          fontSize: 32,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                  child: FFButtonWidget(
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        /*
                        PageTransition(
                          type: PageTransitionType.rightToLeft,
                          duration: Duration(milliseconds: 8),
                          reverseDuration: Duration(milliseconds: 8),
                          child: Scaffold(
                            body: MultiColTest()
                          ),
                        ),

                         */
                        MaterialPageRoute(
                          builder: (context) => Scaffold(
                          body: MultiColTest()
                          )
                        )
                      );
                    },
                    text: 'View Experiments\n',
                    options: FFButtonOptions(
                      width: 260,
                      height: 55,
                      color: Color(0xFF4762F5),
                      textStyle:
                          FlutterFlowTheme.of(context).subtitle2.override(
                                fontFamily: 'Ubuntu',
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                              ),
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(12)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
