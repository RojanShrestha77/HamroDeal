import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hamro_deal/features/auth/domain/entities/auth_entity.dart';
import 'package:hamro_deal/features/auth/presentation/pages/login_screen.dart';
import 'package:hamro_deal/features/auth/presentation/providers/auth_provider.dart';
import 'package:hamro_deal/widgets/my_button.dart';
import 'package:hamro_deal/widgets/my_textformfield.dart';

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }

      if (!next.isLoading &&
          previous?.isLoading == true &&
          next.isAuthenticated) {
        // Success SnackBar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Registration successful! Please login.'),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => LoginScreen()),
        );
      }
    });

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
                  const SizedBox(height: 70),
                  Image.asset(
                    'assets/images/registerlogo.png',
                    width: 250,
                    height: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Register",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  const Text(
                    "Create your new account",
                    style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 25),
                  MyTextformfield(
                    firstcontroller: fullNameController,
                    text: "Full Name",
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    firstcontroller: emailController,
                    text: "Email",
                    validator: validateEmail,
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    firstcontroller: passwordController,
                    text: "Password",
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
                        : () {
                            if (_formKey.currentState!.validate()) {
                              final entity = AuthEntity(
                                userName: fullNameController.text,
                                email: emailController.text,
                                password: passwordController.text,
                              );

                              ref
                                  .read(authControllerProvider.notifier)
                                  .register(entity);
                            }
                          },
                    text: authState.isLoading ? "Registering..." : "Register",
                    width: double.infinity,
                    height: 65,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: const Text.rich(
                      TextSpan(
                        text: "Already have an account?",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1E1E1E),
                        ),
                        children: [
                          TextSpan(
                            text: " Sign in",
                            style: TextStyle(
                              fontSize: 17,
                              color: Color(0xFF147AFF),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
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
