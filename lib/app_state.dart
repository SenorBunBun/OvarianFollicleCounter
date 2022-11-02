import 'package:shared_preferences/shared_preferences.dart';
import 'flutter_flow/lat_lng.dart';

class FFAppState {
  static final FFAppState _instance = FFAppState._internal();

  factory FFAppState() {
    return _instance;
  }

  FFAppState._internal() {
    initializePersistedState();
  }

  Future initializePersistedState() async {
    prefs = await SharedPreferences.getInstance();
    _Test = prefs.getStringList('ff_Test') ?? _Test;
  }

  late SharedPreferences prefs;

  List<String> _Test = ['Hello World', 'Hello World2', 'Hello World3'];
  List<String> get Test => _Test;
  set Test(List<String> _value) {
    _Test = _value;
    prefs.setStringList('ff_Test', _value);
  }

  void addToTest(String _value) {
    _Test.add(_value);
    prefs.setStringList('ff_Test', _Test);
  }

  void removeFromTest(String _value) {
    _Test.remove(_value);
    prefs.setStringList('ff_Test', _Test);
  }

  int primordial = 0;

  int Transitional = 0;

  int Primary = 0;

  int Secondary = 0;

  int EarlyAntral = 0;

  int Antral = 0;

  int Dead = 0;

  int AddToggle = 1;
}

LatLng? _latLngFromString(String? val) {
  if (val == null) {
    return null;
  }
  final split = val.split(',');
  final lat = double.parse(split.first);
  final lng = double.parse(split.last);
  return LatLng(lat, lng);
}
