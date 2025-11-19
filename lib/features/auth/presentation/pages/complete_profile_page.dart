import 'dart:io';

import 'package:alguiendijochamba_app_flutter/features/auth/presentation/blocs/complete_profile_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/blocs/upload_photo_bloc.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart'; // Necesitas instalar este paquete

// Importa la página de Login para la navegación final
// import 'login_page.dart'; 


// Enum para mapear visualmente el método de pago (del backend)
enum PaymentOption {
  none, 
  creditDebitCard,
  digitalWallet,
}

// Convertir el enum local al int que espera el backend
int paymentOptionToInt(PaymentOption option) {
  switch (option) {
    case PaymentOption.creditDebitCard:
      return 1;
    case PaymentOption.digitalWallet:
      return 2;
    default:
      return 0; // None = 0
  }
}

class CompleteProfilePage extends StatefulWidget {
  final String customerId;

  const CompleteProfilePage({super.key, required this.customerId});

  @override
  State<CompleteProfilePage> createState() => _CompleteProfilePageState();
}

class _CompleteProfilePageState extends State<CompleteProfilePage> {
  // --- Estados Locales de la UI ---
  PaymentOption _preferredPaymentMethod = PaymentOption.none;
  bool _acceptsBookingUpdates = true; // Por defecto ON (ejemplo de tu widget)
  bool _acceptsPromotionsAndOffers = false; // Por defecto OFF
  bool _acceptsNewsletter = false; // Por defecto OFF
  
  File? _selectedPhoto;
  String? _uploadedPhotoUrl; // URL después de la subida exitosa

  // --- Funciones de Lógica de UI ---

  // 1. Selector de Foto
  Future<void> _pickAndUploadPhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final photoFile = File(pickedFile.path);
      setState(() {
        _selectedPhoto = photoFile;
      });
      
      // 🛑 Disparar el evento de subida 🛑
      context.read<UploadPhotoBloc>().add(
            SubmitUploadPhotoEvent(
              customerId: widget.customerId,
              photoFile: photoFile,
            ),
          );
    }
  }

  // 2. Acción Final
  void _submitProfile() {
    // 🛑 Disparar el evento de completar perfil 🛑
    context.read<CompleteProfileBloc>().add(
          SubmitCompleteProfileEvent(
            customerId: widget.customerId,
            preferredPaymentMethod: paymentOptionToInt(_preferredPaymentMethod),
            acceptsBookingUpdates: _acceptsBookingUpdates,
            acceptsPromotionsAndOffers: _acceptsPromotionsAndOffers,
            acceptsNewsletter: _acceptsNewsletter,
          ),
        );
  }

  // --- Widgets de Ayuda ---

  Widget _buildPaymentOptionCard(
    PaymentOption option,
    String emoji,
    String title,
  ) {
    final bool isSelected = _preferredPaymentMethod == option;
    return GestureDetector(
      onTap: () {
        setState(() {
          _preferredPaymentMethod = option;
        });
      },
      child: Container(
        width: 162.60,
        height: 120,
        padding: const EdgeInsets.all(17.35),
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.35,
              color: isSelected ? const Color(0xFF2563EB) : const Color(0xFFE5E7EB),
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          color: isSelected ? const Color(0x192563EB) : Colors.white, // Fondo ligeramente azul si está seleccionado
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF1F2937),
                fontSize: 14,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationToggle(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return Container(
      width: double.infinity,
      height: title == 'Booking Updates' ? 95.98 : 75.98, // Ajusta altura según el diseño
      padding: const EdgeInsets.symmetric(horizontal: 15.99),
      decoration: ShapeDecoration(
        color: const Color(0x4CF9FAFB),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: Colors.white,
            activeTrackColor: const Color(0xFF2563EB),
            inactiveTrackColor: const Color(0xFFD1D5DB),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: MultiBlocListener(
          listeners: [
            // 🛑 1. Listener para la subida de foto 🛑
            BlocListener<UploadPhotoBloc, UploadPhotoState>(
              listener: (context, state) {
                if (state is UploadPhotoLoading) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Subiendo foto...')));
                } else if (state is UploadPhotoSuccess) {
                  setState(() {
                    _uploadedPhotoUrl = state.photoUrl;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Foto subida con éxito!')));
                } else if (state is UploadPhotoFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al subir foto: ${state.error}')));
                  setState(() {
                    _selectedPhoto = null; // Limpiar la foto seleccionada si falla
                  });
                }
              },
            ),

            // 🛑 2. Listener para completar el perfil (acción final) 🛑
            BlocListener<CompleteProfileBloc, CompleteProfileState>(
              listener: (context, state) {
                if (state is CompleteProfileLoading) {
                  // Muestra un loader si es necesario
                } else if (state is CompleteProfileSuccess) {
                  // 🚨 Navegación CRÍTICA a Login 🚨
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Perfil completado. Por favor, inicia sesión.')));
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login', // Asume que la ruta de login es '/login'
                    (Route<dynamic> route) => false,
                  );
                } else if (state is CompleteProfileFailure) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error al finalizar el setup: ${state.error}')));
                }
              },
            ),
          ],
          child: Column(
            children: [
              // 1. TopBar
              const TopBar(title: 'Complete Profile'),
              
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // 2. Título y Subtítulo
                      _buildHeader(),
                      const SizedBox(height: 24),

                      // 3. Selector de Foto de Perfil
                      _buildPhotoSelector(),
                      const SizedBox(height: 32),

                      // 4. Preferred Payment Method Title
                      _buildPaymentMethodTitle(),
                      const SizedBox(height: 8),

                      // 5. Opciones de Pago (Clickables)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildPaymentOptionCard(
                            PaymentOption.creditDebitCard,
                            '💳',
                            'Credit/Debit Card',
                          ),
                          _buildPaymentOptionCard(
                            PaymentOption.digitalWallet,
                            '📱',
                            'Digital Wallet',
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),

                      // 6. Notification Preferences Title
                      _buildNotificationPreferencesTitle(),
                      const SizedBox(height: 8),

                      // 7. Toggles de Notificaciones
                      _buildNotificationToggle(
                        'Booking Updates',
                        'Get notified about your service appointments',
                        _acceptsBookingUpdates,
                        (newValue) => setState(() => _acceptsBookingUpdates = newValue),
                      ),
                      const SizedBox(height: 12),
                      _buildNotificationToggle(
                        'Promotions & Offers',
                        'Receive special deals and discounts',
                        _acceptsPromotionsAndOffers,
                        (newValue) => setState(() => _acceptsPromotionsAndOffers = newValue),
                      ),
                      const SizedBox(height: 12),
                      _buildNotificationToggle(
                        'Newsletter',
                        'Tips and updates from AlguienDijoChamba',
                        _acceptsNewsletter,
                        (newValue) => setState(() => _acceptsNewsletter = newValue),
                      ),
                      const SizedBox(height: 48),

                      // 8. Botón Finalizar Setup
                      _buildFinishButton(),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // --- Métodos que construyen los fragmentos de UI ---

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      child: Column(
        children: [
          const Text(
            'Almost Done!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1F2937),
              fontSize: 20,
              fontFamily: 'Arimo',
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: 263, // Ancho original
            child: Text(
              'Complete your profile to get the best experience',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 16,
                fontFamily: 'Arimo',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoSelector() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickAndUploadPhoto,
          child: Container(
            width: 95.98,
            height: 95.98,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFF9FAFB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(45372000), // Hace que sea un círculo
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Imagen de perfil seleccionada o cargada
                if (_selectedPhoto != null)
                  Image.file(
                    _selectedPhoto!,
                    fit: BoxFit.cover,
                    width: 95.98,
                    height: 95.98,
                  )
                else if (_uploadedPhotoUrl != null) 
                  // Muestra la foto si ya está en el servidor (opcional)
                  Image.network(
                    _uploadedPhotoUrl!,
                    fit: BoxFit.cover,
                    width: 95.98,
                    height: 95.98,
                  )
                else
                  // Icono Placeholder (el Stack vacío de tu diseño)
                  const Icon(Icons.person, color: Color(0xFF6B7280), size: 40), 

                // Ícono de Cámara/Cargar (el botón con el '+')
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 31.99,
                    height: 31.99,
                    decoration: ShapeDecoration(
                      color: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45372000),
                        side: const BorderSide(color: Colors.white, width: 2), // Borde blanco
                      ),
                    ),
                    child: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Add a profile photo (optional)',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 14,
            fontFamily: 'Arimo',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Text(
        'Preferred Payment Method',
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 14,
          fontFamily: 'Arimo',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildNotificationPreferencesTitle() {
    return const SizedBox(
      width: double.infinity,
      child: Text(
        'Notification Preferences',
        style: TextStyle(
          color: Color(0xFF1F2937),
          fontSize: 14,
          fontFamily: 'Arimo',
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _buildFinishButton() {
    return BlocBuilder<CompleteProfileBloc, CompleteProfileState>(
      builder: (context, state) {
        final bool isLoading = state is CompleteProfileLoading;
        return GestureDetector(
          onTap: isLoading ? null : _submitProfile,
          child: Container(
            width: double.infinity,
            height: 47.98,
            decoration: ShapeDecoration(
              color: isLoading ? const Color(0xFF6B7280) : const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadows: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                )
              ],
            ),
            alignment: Alignment.center,
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Text(
                    'Finish Setup',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
          ),
        );
      },
    );
  }
}