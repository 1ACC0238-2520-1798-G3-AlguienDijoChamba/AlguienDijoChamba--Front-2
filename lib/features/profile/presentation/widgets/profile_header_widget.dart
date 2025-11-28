import 'package:flutter/material.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfileHeaderWidget extends StatefulWidget {
  final String nombres;
  final String apellidos;
  final String? photoUrl;
  final String location;
  final String userId;
  final VoidCallback? onPhotoUpdated;

  const ProfileHeaderWidget({
    super.key,
    required this.nombres,
    required this.apellidos,
    this.photoUrl,
    required this.location,
    required this.userId,
    this.onPhotoUpdated,
  });

  @override
  State<ProfileHeaderWidget> createState() => _ProfileHeaderWidgetState();
}

class _ProfileHeaderWidgetState extends State<ProfileHeaderWidget> {
  late String? _currentPhotoUrl;
  bool _isUploadingPhoto = false;

  @override
  void initState() {
    super.initState();
    _currentPhotoUrl = widget.photoUrl;
  }

  Future<void> _pickAndUploadPhoto() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) return;

      setState(() => _isUploadingPhoto = true);

      final apiClient = injector<ApiClient>();
      
      // Crear una solicitud multipart
      final request = http.MultipartRequest(
        'POST',
        Uri.parse('${apiClient.baseUrl}/api/v1/Customer/${widget.userId}/profile/photo'),
      );

      // Agregar token de autenticación
      final tokenStorage = injector<TokenStorage>();
      final token = await tokenStorage.getToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Agregar archivo
      request.files.add(
        await http.MultipartFile.fromPath(
          'photoFile',
          pickedFile.path,
        ),
      );

      // Enviar solicitud
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final photoUrl = jsonResponse['photoUrl'] ?? jsonResponse['url'];

        setState(() => _currentPhotoUrl = photoUrl);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Foto actualizada correctamente'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
        }

        // Callback para notificar al padre
        widget.onPhotoUpdated?.call();
      } else {
        throw Exception('Error al subir foto: ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error al subir foto: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      debugPrint('❌ Error uploading photo: $e');
    } finally {
      if (mounted) {
        setState(() => _isUploadingPhoto = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF2196F3),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                // 👤 Foto circular con overlay de carga
                Stack(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300],
                        image: _currentPhotoUrl != null
                            ? DecorationImage(
                                image: NetworkImage(_currentPhotoUrl!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _currentPhotoUrl == null
                          ? const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 40,
                            )
                          : null,
                    ),
                    // 📷 Botón flotante para cambiar foto
                    if (!_isUploadingPhoto)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _pickAndUploadPhoto,
                              borderRadius: BorderRadius.circular(14),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Color(0xFF2196F3),
                                size: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    else
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white,
                          ),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Color(0xFF2196F3)),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.nombres} ${widget.apellidos}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.location,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
