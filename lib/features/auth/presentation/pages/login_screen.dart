import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/auth/presentation/providers/auth_provider.dart';
import 'package:hamro_deal/screens/bottom_navigation_screen.dart';
import 'package:hamro_deal/features/auth/presentation/pages/register_screen.dart';
import 'package:hamro_deal/widgets/my_button.dart';
import 'package:hamro_deal/widgets/my_textformfield.dart';

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Email validation
  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  // Password validation
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login1.png',
                    width: 330,
                    height: 400,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 25),
                  MyTextformfield(
                    firstcontroller: usernameController,
                    text: 'Email',
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    firstcontroller: passwordController,
                    text: 'Password',
                    obscureText: true,
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 40),
                  if (authState.errorMessage != null)
                    Text(
                      authState.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  const SizedBox(height: 20),
                  MyButton(
                    onPressed: authState.isLoading
                        ? () {}
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              await ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    usernameController.text,
                                    passwordController.text,
                                  );

                              final state = ref.read(authControllerProvider);

                              if (state.isAuthenticated) {
                                // Show success SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Login successful!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );

                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => BottomNavigationScreen(),
                                  ),
                                );
                              } else if (state.errorMessage != null) {
                                // Show error SnackBar
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(state.errorMessage!),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          },
                    text: authState.isLoading ? "Logging in..." : "Login",
                    width: double.infinity,
                    height: 65,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => RegisterScreen()),
                      );
                    },
                    child: const Text(
                      "Don't have an account? Sign Up",
                      style: TextStyle(
                        fontSize: 17,
                        color: Color(0xFF147AFF),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
