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

  Future<dynamic> patch(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    // La mayoría de los PATCH requieren autenticación (como Marcar como Leído)
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

      // Los PATCH exitosos suelen devolver 200 (OK) o 204 (No Content)
      if (response.statusCode == HttpStatus.ok || response.statusCode == HttpStatus.noContent) {
        // Devuelve true para indicar éxito, o decodifica si hay cuerpo (200)
        if (response.body.isEmpty) {
          return true;
        }
        return jsonDecode(response.body); 
      } else {
        // Manejo de errores estándar de HTTP
        throw HttpException('Error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      rethrow;
    }
  }
  
    Future<Map<String, dynamic>> postFile(
    String endpoint, {
    required File file,
    required String fieldName, // El nombre del campo en el formulario (ej: 'PhotoFile')
  
  }) async {
    
    // 1. Construir la URI de forma segura
    final uri = Uri.parse(_buildUrl(endpoint));
    final token = await tokenStorage.getToken(); // Obtener el token guardado

    print('DEBUG API CLIENT: Intentando POST FILE (Multipart) a -> $uri');



    // 2. Crear la solicitud Multipart
    final request = http.MultipartRequest('POST', uri);


    // 4. Adjuntar el archivo
    final fileStream = http.ByteStream(file.openRead());
    final fileLength = await file.length();

    final multipartFile = http.MultipartFile(
      fieldName, // Ejemplo: 'PhotoFile'
      fileStream,
      fileLength,
      filename: file.path.split('/').last, // Nombre original del archivo para el servidor
    );

    request.files.add(multipartFile);

    try {
      // 5. Enviar la solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      // 6. Manejar la respuesta
      if (response.statusCode == HttpStatus.ok) { // Esperamos 200 OK
        // El backend devuelve un JSON: { "photoUrl": "string" }
        return json.decode(response.body) as Map<String, dynamic>;
      } else {
        // Intenta decodificar el error si es JSON
        String errorMessage = 'File upload failed with status ${response.statusCode}: ${response.reasonPhrase}';
        try {
          final errorBody = json.decode(response.body);
          errorMessage = errorBody['detail'] ?? errorBody['title'] ?? errorMessage;
        } catch (_) {
          // El cuerpo no es JSON, usa el mensaje de error HTTP básico
        }
        print('❌ ERROR HTTP ${response.statusCode}: $errorMessage');
        throw HttpException(errorMessage);
      }
    } catch (e) {
      rethrow;
    }
  }

  
}