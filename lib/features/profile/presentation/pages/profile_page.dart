import 'package:alguiendijochamba_app_flutter/features/profile/presentation/pages/edit_profile_page.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/presentation/widgets/profile_header_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/usecases/get_profile.dart';
import 'package:alguiendijochamba_app_flutter/features/profile/domain/usecases/update_profile.dart';

import '../blocs/profile_bloc.dart';
import '../blocs/profile_event.dart';
import '../blocs/profile_state.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileBloc? _profileBloc;
  bool _isLoadingUserId = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    debugPrint('🔹 PROFILE PAGE: initState');
    _initializeProfileBloc();
  }

  Future<void> _initializeProfileBloc() async {
    try {
      final tokenStorage = injector<TokenStorage>();
      
      final userId = await tokenStorage.getUserId();
      final customerId = await tokenStorage.getCustomerId();
      
      debugPrint('🔹 PROFILE PAGE: UserId recuperado: $userId');
      debugPrint('🔹 PROFILE PAGE: CustomerId recuperado: $customerId');
      
      if (userId != null && mounted) {
        _profileBloc = ProfileBloc(
          getProfile: injector<GetProfile>(),
          updateProfile: injector<UpdateProfile>(),
        );
        
        debugPrint('🔹 PROFILE PAGE: ProfileBloc creado. Enviando evento LoadProfile con customerId: $userId');
        _profileBloc!.add(LoadProfile(userId));
      } else {
        debugPrint('❌ PROFILE PAGE: UserId es null o widget desmontado');
        if (mounted) {
          setState(() => _errorMessage = 'No se encontró ID de usuario. Intenta hacer login nuevamente.');
        }
      }
    } catch (e) {
      debugPrint('❌ PROFILE PAGE ERROR: $e');
      if (mounted) {
        setState(() => _errorMessage = 'Error al inicializar perfil: $e');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingUserId = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUserId) {
      return const Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Cargando información de usuario...'),
            ],
          ),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(_errorMessage!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login');
                },
                child: const Text('Ir a Login'),
              ),
            ],
          ),
        ),
      );
    }

    return BlocBuilder<ProfileBloc, ProfileState>(
      bloc: _profileBloc,
      builder: (context, state) {
        debugPrint('🔹 PROFILE PAGE BLOC STATE: $state');

        if (state is ProfileLoading) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Obteniendo perfil del servidor...'),
                ],
              ),
            ),
          );
        }

        if (state is ProfileError) {
          return Scaffold(
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      'Error al cargar perfil:\n${state.message}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _initializeProfileBloc(),
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        if (state is ProfileLoaded || state is ProfileUpdated) {
          final profile = state is ProfileLoaded ? state.profile : (state as ProfileUpdated).profile;

          return Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Column(
                children: [
                  ProfileHeaderWidget(
                    nombres: profile.nombres,
                    apellidos: profile.apellidos,
                    photoUrl: profile.photoUrl,
                    location: 'Centro de Lima',
                    userId: profile.userId,
                    onPhotoUpdated: () {
                      _profileBloc?.add(LoadProfile(profile.id));
                    },
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        
                        _buildReadOnlyField(label: 'First Name', value: profile.nombres),
                        const SizedBox(height: 12),
                        _buildReadOnlyField(label: 'Last Name', value: profile.apellidos),
                        const SizedBox(height: 12),
                        _buildReadOnlyField(label: 'Phone Number', value: profile.celular),
                        const SizedBox(height: 12),
                        
                        const SizedBox(height: 16),
                        _buildPreferenceField(label: 'Payment Method', value: profile.preferredPaymentMethod),
                        const SizedBox(height: 12),
                        _buildToggleField(label: 'Accept Booking Updates', value: profile.acceptsBookingUpdates),
                        const SizedBox(height: 12),
                        _buildToggleField(label: 'Accept Promotions & Offers', value: profile.acceptsPromotionsAndOffers),
                        const SizedBox(height: 12),
                        _buildToggleField(label: 'Accept Newsletter', value: profile.acceptsNewsletter),
                        
                        const SizedBox(height: 32),

                        // ✅ User ID (al final, read-only)
                        _buildReadOnlyField(label: 'User ID', value: profile.userId),
                        
                        const SizedBox(height: 32),
                        
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: _profileBloc!,
                                    child: EditProfilePage(profile: profile),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'Edit',
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const Scaffold(
          body: Center(child: Text('Estado desconocido (ProfileInitial)')),
        );
      },
    );
  }

  Widget _buildReadOnlyField({required String label, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF9E9E9E))),
        const SizedBox(height: 6),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0)), borderRadius: BorderRadius.circular(8)),
          child: Text(value, style: const TextStyle(fontSize: 14, color: Color(0xFF212121))),
        ),
      ],
    );
  }

  Widget _buildPreferenceField({required String label, required String value}) {
    return _buildReadOnlyField(label: label, value: value);
  }

  Widget _buildToggleField({required String label, required bool value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(border: Border.all(color: const Color(0xFFE0E0E0)), borderRadius: BorderRadius.circular(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Color(0xFF212121))),
          Text(value ? 'Yes' : 'No', style: const TextStyle(fontSize: 14, color: Color(0xFF212121))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _profileBloc?.close();
    super.dispose();
  }
}
