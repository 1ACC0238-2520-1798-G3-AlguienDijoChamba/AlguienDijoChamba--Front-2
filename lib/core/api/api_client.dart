import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart'; 

class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage; 

  ApiClient({required this.baseUrl, required this.tokenStorage});

  // 🛑 AÑADIR FUNCIÓN PARA CONSTRUCCIÓN SEGURA DE URL 🛑
  String _buildUrl(String endpoint) {
    // 1. Asegurar que baseUrl NO termine en '/'
    final cleanBaseUrl = baseUrl.endsWith('/') 
        ? baseUrl.substring(0, baseUrl.length - 1) 
        : baseUrl;

    // 2. Asegurar que el endpoint SÍ comience con '/'
    final cleanEndpoint = endpoint.startsWith('/') 
        ? endpoint 
        : '/$endpoint';

    // Devuelve una URL limpia, sin doble barra
    return cleanBaseUrl + cleanEndpoint;
  }

  Future<Map<String, String>> _getHeaders({
    bool requiresAuth = false,
    Map<String, String>? customHeaders,
  }) async {
    // ... (Código original de _getHeaders respetado)
    final headers = {
      'Content-Type': 'application/json',
      ...?customHeaders,
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      if (token != null && token.isNotEmpty) {
        final authHeader = 'Bearer $token';
        headers[HttpHeaders.authorizationHeader] = authHeader;

        print('--- DEBUG API CLIENT (Token Attach) ---');
        print('Token encontrado y adjuntado. Prefijo: ${token.substring(0, 20)}...');
        print('Endpoint: Request requires authentication.');
        print('---------------------------------------');
      } else {
        print('--- DEBUG API CLIENT (Token MISSING) ---');
        print('ADVERTENCIA: Solicitud protegida enviada SIN token. Esto causa 401/404.');
        print('----------------------------------------');
      }
    }

    return headers;
  }

  // POST (USANDO _buildUrl)
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false,
  }) async {
    final uri = Uri.parse(_buildUrl(endpoint));
    print('DEBUG API CLIENT: Intentando POST a -> $uri');

    try {
      final response = await http.post(
        uri,
        headers: await _getHeaders(
            requiresAuth: requiresAuth, customHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          return decoded;
        }

        throw const FormatException(
            'Se esperaba un objeto JSON (Map) en la respuesta del POST.');
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // GET (USANDO _buildUrl)
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
    Map<String, dynamic>? queryParams,
  }) async {
    Uri uri = Uri.parse(_buildUrl(endpoint));

    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        ...uri.queryParameters,
        ...queryParams.map((k, v) => MapEntry(k, v.toString())),
      });
    }

    print('DEBUG API CLIENT: Intentando GET a -> $uri');

    try {
      final response = await http.get(
        uri,
        headers: await _getHeaders(
            requiresAuth: requiresAuth, customHeaders: headers),
      );

      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        print('❌ ERROR HTTP ${response.statusCode}: ${response.reasonPhrase}');
        print('Cuerpo del error: ${response.body}');
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // PUT (USANDO _buildUrl)
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(_buildUrl(endpoint));
    print('DEBUG API CLIENT: Intentando PUT a -> $uri');

    try {
      final response = await http.put(
        uri,
        headers: await _getHeaders(
            requiresAuth: requiresAuth, customHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        if (response.body.isEmpty) return true;

        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // ✨ PATCH (USANDO _buildUrl)
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(_buildUrl(endpoint));
    print('DEBUG API CLIENT: Intentando PATCH a -> $uri');

    try {
      final response = await http.patch(
        uri,
        headers: await _getHeaders(
            requiresAuth: requiresAuth, customHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        if (response.body.isEmpty) return true;

        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // DELETE (USANDO _buildUrl)
  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true,
  }) async {
    final uri = Uri.parse(_buildUrl(endpoint));
    print('DEBUG API CLIENT: Intentando DELETE a -> $uri');

    try {
      final response = await http.delete(
        uri,
        headers: await _getHeaders(
            requiresAuth: requiresAuth, customHeaders: headers),
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.noContent) {
        if (response.body.isEmpty) return true;

        return jsonDecode(response.body);
      } else {
        throw HttpException(
            'Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
