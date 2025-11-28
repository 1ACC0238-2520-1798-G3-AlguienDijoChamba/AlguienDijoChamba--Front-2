import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';

import '../../domain/entities/customer_profile.dart';
import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';
import '../blocs/profile_state.dart';

class EditProfilePage extends StatefulWidget {
  final CustomerProfile profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nombresController;
  late TextEditingController _apellidosController;
  late TextEditingController _celularController;

  late int _paymentMethod;
  late bool _acceptsBookingUpdates;
  late bool _acceptsPromotions;
  late bool _acceptsNewsletter;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nombresController = TextEditingController(text: widget.profile.nombres);
    _apellidosController = TextEditingController(
      text: widget.profile.apellidos,
    );
    _celularController = TextEditingController(text: widget.profile.celular);

    _paymentMethod = _paymentMethodStringToInt(widget.profile.preferredPaymentMethod);
    _acceptsBookingUpdates = widget.profile.acceptsBookingUpdates;
    _acceptsPromotions = widget.profile.acceptsPromotionsAndOffers;
    _acceptsNewsletter = widget.profile.acceptsNewsletter;
  }

  int _paymentMethodStringToInt(String method) {
    switch (method.toLowerCase()) {
      case 'credit card':
      case 'debit card':
      case 'credit/debit card':
      case 'card':
        return 0;
      case 'digital wallet':
      case 'wallet':
        return 1;
      default:
        return 0;
    }
  }

  String _paymentMethodIntToString(int method) {
    switch (method) {
      case 0:
        return 'Credit/Debit Card';
      case 1:
        return 'Digital Wallet';
      default:
        return 'Credit/Debit Card';
    }
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    try {
      final tokenStorage = injector<TokenStorage>();
      final customerId = await tokenStorage.getCustomerId();

      if (customerId == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('❌ Error: No customer ID found'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }

      final updatedProfile = CustomerProfile(
        id: widget.profile.id,
        userId: widget.profile.userId,
        nombres: _nombresController.text.trim(),
        apellidos: _apellidosController.text.trim(),
        celular: _celularController.text.trim(),
        photoUrl: widget.profile.photoUrl,
        preferredPaymentMethod: _paymentMethodIntToString(_paymentMethod),
        acceptsBookingUpdates: _acceptsBookingUpdates,
        acceptsPromotionsAndOffers: _acceptsPromotions,
        acceptsNewsletter: _acceptsNewsletter,
      );

      debugPrint('📝 EDIT PROFILE: Guardando y recargar...');

      if (mounted) {
        context.read<ProfileBloc>().add(
          UpdateProfileEvent(customerId, updatedProfile),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileUpdated) {
          // ✅ Mostrar snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('✅ Perfil actualizado correctamente'),
              backgroundColor: Color(0xFF4CAF50),
            ),
          );
          
          // ✅ Pequeño delay para que se vea el snackbar
          Future.delayed(const Duration(milliseconds: 500), () {
            // ✅ Recargar el perfil
            if (mounted) {
              context.read<ProfileBloc>().add(
                LoadProfile(widget.profile.userId),
              );
            }
            
            // ✅ Cerrar EditProfilePage después de un poco
            Future.delayed(const Duration(milliseconds: 300), () {
              if (mounted) {
                Navigator.pop(context);
              }
            });
          });
        } else if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('❌ Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildEditField(
                  label: 'First Name',
                  controller: _nombresController,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  label: 'Last Name',
                  controller: _apellidosController,
                ),
                const SizedBox(height: 16),
                _buildEditField(
                  label: 'Phone Number',
                  controller: _celularController,
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 16),
                _buildPaymentMethodField(),
                const SizedBox(height: 16),
                _buildToggleEditField(
                  label: 'Accept Booking Updates',
                  value: _acceptsBookingUpdates,
                  onChanged: (val) =>
                      setState(() => _acceptsBookingUpdates = val),
                ),
                const SizedBox(height: 12),
                _buildToggleEditField(
                  label: 'Accept Promotions & Offers',
                  value: _acceptsPromotions,
                  onChanged: (val) => setState(() => _acceptsPromotions = val),
                ),
                const SizedBox(height: 12),
                _buildToggleEditField(
                  label: 'Accept Newsletter',
                  value: _acceptsNewsletter,
                  onChanged: (val) => setState(() => _acceptsNewsletter = val),
                ),
                const SizedBox(height: 32),
                _buildReadOnlyEditField(
                  label: 'User ID',
                  value: widget.profile.userId,
                ),
                const SizedBox(height: 32),
                
                // ✅ BOTÓN SAVE: Guarda, recarga y cierra
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isSaving ? null : _saveProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2196F3),
                      disabledBackgroundColor: const Color(0xFFBDBDBD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Save',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReadOnlyEditField({
    required String label,
    required String value,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
            color: const Color(0xFFF5F5F5),
          ),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF757575)),
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF9E9E9E),
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int>(
          value: _paymentMethod,
          items: [
            const DropdownMenuItem(
              value: 0,
              child: Text('Credit/Debit Card'),
            ),
            const DropdownMenuItem(
              value: 1,
              child: Text('Digital Wallet'),
            ),
          ],
          onChanged: (value) {
            setState(() => _paymentMethod = value ?? 0);
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToggleEditField({
    required String label,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF212121),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF2196F3),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _nombresController.dispose();
    _apellidosController.dispose();
    _celularController.dispose();
    super.dispose();
  }
}
