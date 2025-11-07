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
    // AÑADE ESTO: Soporte para parámetros de consulta
    Map<String, dynamic>? queryParams, 
  }) async {
    
    // 1. Inicia con la URI base
    Uri uri = Uri.parse('$baseUrl$endpoint');


    // 2. Si hay parámetros, adjúntalos usando Uri.replace (¡seguro!)
    if (queryParams != null && queryParams.isNotEmpty) {
      uri = uri.replace(queryParameters: {
        ...uri.queryParameters,
        // Asegúrate de convertir todos los valores a String si es necesario
        ...queryParams.map((k, v) => MapEntry(k, v.toString())), 
      });
    }


    print('DEBUG API CLIENT: Intentando GET a -> $uri'); // Esto mostrará la URL COMPLETA
    
    try {
      final response = await http.get(
        uri, // Usa la URI completa con query
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
      );
      
      // ... el resto de tu lógica de status code ...
      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
        // Por favor, verifica de nuevo qué imprime aquí
        print('❌ ERROR HTTP ${response.statusCode}: ${response.reasonPhrase}');
        print('Cuerpo del error: ${response.body}');
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }


  
  Future<dynamic> put(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    // La mayoría de los PUTs requieren autenticación
    bool requiresAuth = true, 
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print('DEBUG API CLIENT: Intentando PUT a -> $uri');
    
    try {
      final response = await http.put(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );


      // Los PUTs exitosos a menudo devuelven 200 (OK) con cuerpo o 204 (No Content).
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        // Si el cuerpo está vacío (204), devolvemos true/null o un Map vacío.
        if (response.body.isEmpty) {
            return true; 
        }
        // Si hay cuerpo (200), lo decodificamos y lo devolvemos como dynamic.
        return jsonDecode(response.body); 
      } else {
        // Aquí puedes añadir manejo de errores más detallado si lo necesitas
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }


  // ✨ NUEVO: Método PATCH (agregado para Active Jobs)
  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    bool requiresAuth = true, 
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    print('DEBUG API CLIENT: Intentando PATCH a -> $uri');
    
    try {
      final response = await http.patch(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
        body: body != null ? jsonEncode(body) : null,
      );

      // Los PATCHes exitosos devuelven típicamente 200 (OK) o 204 (No Content)
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        // Si el cuerpo está vacío (204), devolvemos true
        if (response.body.isEmpty) {
            return true; 
        }
        // Si hay cuerpo (200), lo decodificamos y lo devolvemos como dynamic
        return jsonDecode(response.body); 
      } else {
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true, 
  }) async {
    final uri = Uri.parse('$baseUrl$endpoint');
    
    try {
      final response = await http.delete(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
      );


      // 200 (OK) o 204 (No Content) son comunes para DELETE exitoso.
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        // Usualmente un DELETE no devuelve contenido.
        return true; 
      } else {
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
