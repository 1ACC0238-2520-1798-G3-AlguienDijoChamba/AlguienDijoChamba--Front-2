import 'package:alguiendijochamba_app_flutter/features/auth/domain/usecases/register_user.dart';
import 'package:alguiendijochamba_app_flutter/features/shared/widgets/TopBar.dart';
import 'package:alguiendijochamba_app_flutter/features/auth/presentation/widgets/text_field.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final RegisterUser registerUser;

  const RegisterPage({super.key, required this.registerUser});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // Controllers
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  // Password visibility
  bool _passwordVisible = false;
  bool _confirmPasswordVisible = false;
  bool _termsAccepted = false;

  // Form key
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Validaciones
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'This field is required';
    return null;
  }


  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!regex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone is required';
    if (!RegExp(r'^\d+$').hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value != passwordController.text) return 'Passwords do not match';
    return null;
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_termsAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must accept the terms')),
      );
      return;
    }

    try {
      final user = await widget.registerUser.call(
        email: emailController.text,
        password: passwordController.text,
        nombres: firstNameController.text,
        apellidos: lastNameController.text,
        celular: phoneController.text,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User registered successfully! ID: ${user.id}')),
      );

      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
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
                  title: 'Register',
                ),
                const SizedBox(height: 24),
                const Text(
                  'Join AlguienDijoChamba',
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
                  'Connect with trusted technicians in your area',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 16,
                    fontFamily: 'Arimo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 24),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'or',
                        style: TextStyle(
                          color: Color(0xFF6B7280),
                          fontSize: 14,
                          fontFamily: 'Arimo',
                        ),
                      ),
                    ),
                    Expanded(child: Container(height: 1, color: const Color(0xFFE5E7EB))),
                  ],
                ),
                const SizedBox(height: 16),
                IconTextField(
                  label: 'First Name',
                  hint: 'Enter your first name',
                  icon: Icons.person_outline,
                  controller: firstNameController,
                  keyboard: TextInputType.name,
                  obscureText: false,
                  validator: _validateName,
                ),
                IconTextField(
                  label: 'Last Name',
                  hint: 'Enter your last name',
                  icon: Icons.person_outline,
                  controller: lastNameController,
                  keyboard: TextInputType.name,
                  obscureText: false,
                  validator: _validateName,
                ),
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
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  icon: Icons.phone_outlined,
                  controller: phoneController,
                  keyboard: TextInputType.phone,
                  obscureText: false,
                  validator: _validatePhone,
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
                IconTextField(
                  label: 'Confirm Password',
                  hint: 'Confirm your password',
                  icon: Icons.lock_outlined,
                  controller: confirmPasswordController,
                  obscureText: true,
                  showVisibilityToggle: true,
                  isPasswordVisible: _confirmPasswordVisible,
                  togglePasswordVisibility: () {
                    setState(() => _confirmPasswordVisible = !_confirmPasswordVisible);
                  },
                  validator: _validateConfirmPassword,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _termsAccepted,
                      onChanged: (v) => setState(() => _termsAccepted = v ?? false),
                      activeColor: const Color(0xFF2563EB),
                    ),
                    Expanded(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            color: Color(0xFF6B7280),
                            fontSize: 14,
                            fontFamily: 'Arimo',
                          ),
                          children: [
                            const TextSpan(text: 'I accept the '),
                            TextSpan(
                              text: 'Terms of Service',
                              style: const TextStyle(color: Color(0xFF006AFF)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                            const TextSpan(text: ' and '),
                            TextSpan(
                              text: 'Privacy Policy',
                              style: const TextStyle(color: Color(0xFF006AFF)),
                              recognizer: TapGestureRecognizer()..onTap = () {},
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
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
                    text: 'Already have an account? ',
                    style: const TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 14,
                      fontFamily: 'Arimo',
                      fontWeight: FontWeight.w400,
                    ),
                    children: [
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: Color(0xFF006AFF),
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamed(context, '/login');
                          },
                      ),
                    ],
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}
