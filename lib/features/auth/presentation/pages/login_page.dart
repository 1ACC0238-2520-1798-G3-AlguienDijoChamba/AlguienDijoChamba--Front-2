import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart';
import 'package:alguiendijochamba_app_flutter/core/storage/token_storage.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart'; 
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/widgets/text_field.dart';
import 'package:alguiendijochamba_app_flutter/core/widgets/main_navbar.dart';
import 'package:alguiendijochamba_app_flutter/core/api/signalr_service.dart'; 
import 'package:alguiendijochamba_app_flutter/core/di/injector.dart'; 
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final LoginUser loginUser;
  final AuthRepository authRepository;
  final ApiClient apiClient;

  const LoginPage({
    super.key, 
    required this.loginUser,
    required this.apiClient,
    required this.authRepository,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _passwordVisible = false;
  bool _isLoading = false;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final String email = emailController.text.trim(); 
      final String password = passwordController.text.trim();
      final Session session = await widget.loginUser.call(email, password);
      final String customerId = session.user.id; 
      await widget.authRepository.saveCurrentUserId(customerId); 
      await injector<SignalRService>().connect();
      // 🛑 3. GUARDAR EL ID DE CLIENTE REAL 🛑
      await widget.authRepository.saveCurrentUserId(customerId); 

      // Mostrar mensaje y navegar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      
      debugPrint('🔹 LOGIN PAGE: Intentando login con email: $email');
      
      // 1. Ejecutar login
      final Session session = await widget.loginUser.call(email, password);
      
      debugPrint('🔹 LOGIN PAGE: Login exitoso');
      debugPrint('🔹 LOGIN PAGE: UserId recibido: ${session.user.id}');

      final tokenStorage = injector<TokenStorage>();
      final apiClient = injector<ApiClient>();
      
      // 2. Guardar credenciales
      await tokenStorage.saveToken(session.token);
      await tokenStorage.saveUserId(session.user.id);
      await tokenStorage.saveCustomerId(session.user.id);
      
      debugPrint('✅ LOGIN PAGE: Credenciales guardadas');
      debugPrint('✅ LOGIN PAGE: UserId: ${session.user.id}');

      // 3. ✅ Completar perfil automáticamente (sin datos de preferencias)
      try {
        debugPrint('🔹 LOGIN PAGE: Completando perfil del cliente...');
        
        await apiClient.post(
          '/Customer/${session.user.id}/profile/complete',
          body: {
            'preferredPaymentMethod': 'None',
            'acceptsBookingUpdates': false,
            'acceptsPromotionsAndOffers': false,
            'acceptsNewsletter': false,
          },
          requiresAuth: true,
        );
        
        debugPrint('✅ LOGIN PAGE: Perfil completado exitosamente');
      } catch (e) {
        debugPrint('⚠️ LOGIN PAGE: No se pudo completar perfil (continuando anyway): $e');
        // No fallar el login si no se puede completar el perfil
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Login successful!'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainPage()),
        );
      }
    } catch (e) {
      debugPrint('❌ LOGIN PAGE ERROR: $e');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Login failed: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const TopBar(title: 'Login'),
                const SizedBox(height: 24),
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF1F2937),
                    fontSize: 20,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Login to continue',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                IconTextField(
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email_outlined,
                  controller: emailController,
                  keyboard: TextInputType.emailAddress,
                  obscureText: false,
                  validator: _validateEmail,
                ),
                IconTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  icon: Icons.lock_outlined,
                  controller: passwordController,
                  obscureText: !_passwordVisible,
                  showVisibilityToggle: true,
                  isPasswordVisible: _passwordVisible,
                  togglePasswordVisibility: () {
                    setState(() => _passwordVisible = !_passwordVisible);
                  },
                  validator: _validatePassword,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      disabledBackgroundColor: const Color(0xFFBDBDBD),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(Colors.white),
                            ),
                          )
                        : const Text(
                            'Login',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontFamily: 'Arimo',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                RichText(
                  text: TextSpan(
                    text: 'Forgot your password?',
                    style: const TextStyle(
                      color: Color(0xFF006AFF),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        debugPrint('Forgot password clicked');
                      },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}