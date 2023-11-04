import 'package:frontend/common/shared/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiConnectivity {
  static const baseUrl = Globals.baseApiUrl;

  static Future<dynamic> get(
      String endpoint, Map<String, String>? headers) async {
    final response =
        await http.get(Uri.parse(baseUrl + endpoint), headers: headers);
    return response;
  }

  static Future<dynamic> post(String endpoint, Map<String, String>? headers,
      Map<String, dynamic>? body) async {
    final response = await http.post(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }

  static Future<dynamic> patch(String endpoint, Map<String, String>? headers,
      Map<String, dynamic>? body) async {
    final response = await http.patch(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }
}
