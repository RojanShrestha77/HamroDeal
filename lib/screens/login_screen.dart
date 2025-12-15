import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/bottom_navigation_screen.dart';
import 'package:hamro_deal/screens/bottom_screen/home_screen.dart';
import 'package:hamro_deal/screens/register_screen.dart';
import 'package:hamro_deal/widgets/my_button.dart';
import 'package:hamro_deal/widgets/my_textformfield.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
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
                  Text(
                    "Welcome",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E1E1E),
                    ),
                  ),
                  Text(
                    "Login to your account",
                    style: TextStyle(fontSize: 18, color: Color(0xFF1E1E1E)),
                  ),
                  const SizedBox(height: 25),
                  MyTextformfield(
                    firstcontroller: usernameController,
                    text: 'Username',
                  ),
                  const SizedBox(height: 20),
                  MyTextformfield(
                    firstcontroller: passwordController,
                    text: 'Password',
                  ),
                  const SizedBox(height: 90),
                  MyButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(),
                          ),
                        );
                      }
                    },
                    text: "Login",
                    width: double.infinity,
                    height: 65,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RegisterScreen(),
                        ),
                      );
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?",
                        style: TextStyle(
                          fontSize: 17,
                          color: Color(0xFF1E1E1E),
                        ),
                        children: [
                          TextSpan(
                            text: "Sign Up",
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
