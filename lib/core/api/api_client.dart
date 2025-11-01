import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          ...?headers,
        },
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> get(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        throw HttpException(
          'Error ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
