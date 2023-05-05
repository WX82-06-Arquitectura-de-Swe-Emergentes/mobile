import 'package:frontend/shared/globals.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const baseUrl = Globals.baseApiUrl;

  static Future<dynamic> get(
      String endpoint, Map<String, String>? headers) async {
    final response =
        await http.get(Uri.parse(baseUrl + endpoint), headers: headers);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  static Future<dynamic> post(String endpoint, Map<String, String>? headers,
      Map<String, dynamic>? body) async {
    final response = await http.post(Uri.parse(baseUrl + endpoint),
        headers: headers, body: jsonEncode(body));
    return response;
  }
}
