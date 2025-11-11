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
    Map<String, String>? customHeaders
  }) async {
    // ... (Código de _getHeaders intacto)
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
    // 🛑 USAR LA FUNCIÓN DE CONSTRUCCIÓN SEGURA 🛑
    final uri = Uri.parse(_buildUrl(endpoint)); 
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

  // GET (USANDO _buildUrl)
  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    bool requiresAuth = true, 
    Map<String, dynamic>? queryParams, 
  }) async {
    
    // 1. Inicia con la URI base (USANDO LA FUNCIÓN SEGURA)
    Uri uri = Uri.parse(_buildUrl(endpoint));


    // 2. Si hay parámetros, adjúntalos usando Uri.replace (¡seguro!)
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
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
      );
      
      if (response.statusCode == HttpStatus.ok) {
        return jsonDecode(response.body);
      } else {
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
    final uri = Uri.parse(_buildUrl(endpoint));
    print('DEBUG API CLIENT: Intentando DELETE a -> $uri');
    
    try {
      final response = await http.delete(
        uri,
        headers: await _getHeaders(requiresAuth: requiresAuth, customHeaders: headers),
      );

      // Los DELETEs exitosos suelen devolver 200 (OK) o 204 (No Content)
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        // Si el cuerpo está vacío (204), devolvemos true
        if (response.body.isEmpty) {
          return true;
        }
        // Si hay cuerpo (200), lo decodificamos y lo devolvemos
        return jsonDecode(response.body); 
      } else {
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
}