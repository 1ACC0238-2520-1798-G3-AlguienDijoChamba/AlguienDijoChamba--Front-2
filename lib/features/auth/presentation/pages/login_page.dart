import 'package:alguiendijochamba_app_flutter/core/api/api_client.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/repositories/auth_repository.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/login_user.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/domain/entities/session.dart'; // Necesario para tipar la respuesta
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/widgets/text_field.dart';
import 'package:alguiendijochamba_app_flutter/core/widgets/main_navbar.dart';
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
    required this.authRepository, // Requerir el servicio de sesión
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Password visibility
  bool _passwordVisible = false;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validaciones
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

  // Archivo: LoginPage.dart (Método _login)

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final String email = emailController.text.trim(); 
      final String password = passwordController.text.trim();
      
      // 1. Ejecutar el LOGIN y obtener la sesión. 
      // ⚠️ IMPORTANTE: 'loginUser.call' DEBE devolver Future<Session>.
      final Session session = await widget.loginUser.call( 
        email, 
        password,
      );

      // 🛑 2. ELIMINACIÓN DE LA LLAMADA AL 404 Y ACCESO DIRECTO AL ID 🛑
      
      // Eliminamos estas líneas que fallaban:
      // final profileData = await widget.apiClient.get('/customers/me'); 
      // final String customerId = profileData['id'];

      // Asumiendo que Session tiene una propiedad 'user' que contiene el 'id':
      final String customerId = session.user.id; 

      // 🛑 3. GUARDAR EL ID DE CLIENTE REAL 🛑
      await widget.authRepository.saveCurrentUserId(customerId); 

      // Mostrar mensaje y navegar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
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
                 const TopBar(
                   title: 'Login',
                 ),
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
                   obscureText: true,
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
                     onPressed: _login,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFF2563EB),
                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(12),
                       ),
                     ),
                     child: const Text(
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
                         print('Forgot password clicked');
                         // Aquí puedes navegar a tu pantalla de recuperar contraseña
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
}