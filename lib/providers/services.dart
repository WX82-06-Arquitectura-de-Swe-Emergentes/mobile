import '../shared/globals.dart';

class AppServices {
  String get baseUrl => Globals.baseApiUrl;
  //String get baseUrl => 'http://localhost:8080/swagger-ui/index.html#/';
  String get api => 'api/v1';
  String get trip => 'trips';
  String get destination => 'destination';
  String get tripseason => 'season';
  String get tripDestination => 'destination';
}
