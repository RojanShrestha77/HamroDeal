import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/register_screen.dart';
import 'package:hamro_deal/widgets/my_button.dart';
import 'package:hamro_deal/widgets/my_textformfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextformfield(
                firstcontroller: usernameController,
                text: 'Username',
              ),

              const SizedBox(height: 20),

              MyTextformfield(
                firstcontroller: passwordController,
                text: 'Password',
              ),

              const SizedBox(height: 20),

              MyButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All fields valid
                    String username = usernameController.text;
                    String password = passwordController.text;

                    // ignore: avoid_print
                    print('Username: $username');
                    // ignore: avoid_print
                    print('Password: $password');
                  }
                },
                text: "Login",
                width: double.infinity,
                height: 50,
                color: Colors.blue,
              ),

              const SizedBox(height: 20),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterScreen()),
                  );
                },
                child: const Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
