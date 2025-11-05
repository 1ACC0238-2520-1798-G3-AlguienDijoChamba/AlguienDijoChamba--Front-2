import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../storage/token_storage.dart'; 

class ApiClient {
  final String baseUrl;
  final TokenStorage tokenStorage; 

  ApiClient({required this.baseUrl, required this.tokenStorage});

  Future<Map<String, String>> _getHeaders({
    bool requiresAuth = false, 
    Map<String, String>? customHeaders
  }) async {
    final headers = {
      'Content-Type': 'application/json',
      ...?customHeaders,
    };

    if (requiresAuth) {
      final token = await tokenStorage.getToken();
      
      if (token != null && token.isNotEmpty) {
        final authHeader = 'Bearer $token';
        headers[HttpHeaders.authorizationHeader] = authHeader; 
        
        // --- LÓGICA DE DEBUG AÑADIDA ---
        print('--- DEBUG API CLIENT (Token Attach) ---');
        print('Token encontrado y adjuntado. Prefijo: ${token.substring(0, 20)}...');
        print('Endpoint: Request requires authentication.');
        print('---------------------------------------');
        // ---------------------------------
      } else {
        // --- LÓGICA DE DEBUG AÑADIDA ---
        print('--- DEBUG API CLIENT (Token MISSING) ---');
        print('ADVERTENCIA: Solicitud protegida enviada SIN token. Esto causa 401/404.');
        print('----------------------------------------');
        // ---------------------------------
      }
    }
    return headers;
  }

  // POST mantiene el tipo de retorno Map, ya que se usa para login/registro que devuelven un objeto.
  Future<Map<String, dynamic>> post(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = false, 
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print('DEBUG API CLIENT: Intentando POST a -> $uri'); 
    
    try {
      final response = await http.post(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers), 
        body: body != null ? jsonEncode(body) : null,
      );

      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.created) {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
            return decoded;
        }
        throw const FormatException('Se esperaba un objeto JSON (Map) en la respuesta del POST.');
      } else {
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }

  // 🔑 CORRECCIÓN CLAVE: Cambiamos el tipo de retorno a dynamic.
  // Esto permite que la función devuelva una LISTA cuando el backend envía un array,
  // resolviendo el TypeError.
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true, 
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print('DEBUG API CLIENT: Intentando GET a -> $uri'); 
    
    try {
      final response = await http.get(
        uri, 
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
      );
      
      if (response.statusCode == HttpStatus.ok) {
        // Devuelve List<dynamic> o Map<String, dynamic>
        return jsonDecode(response.body);
      } else {
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}