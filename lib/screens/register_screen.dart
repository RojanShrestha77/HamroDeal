import 'package:flutter/material.dart';
import 'package:hamro_deal/screens/login_screen.dart';
import 'package:hamro_deal/widgets/my_button.dart';
import 'package:hamro_deal/widgets/my_textformfield.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 70),
              Image.asset(
                'assets/images/registerlogo.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 25),
              Text(
                "Register",
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E1E1E),
                  // letterSpacing: 1.2,
                ),
              ),

              // const SizedBox(height: 20),
              Text(
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
                firstcontroller: usernameController,
                text: "username",
              ),

              const SizedBox(height: 20),

              MyTextformfield(
                firstcontroller: passwordController,
                text: "password",
              ),

              const SizedBox(height: 100),

              MyButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // All fields valid
                    String fullName = fullNameController.text;
                    String username = usernameController.text;
                    String password = passwordController.text;

                    // ignore: avoid_print
                    print('Username: $username');
                    // ignore: avoid_print
                    print('Password: $password');
                    // ignore: avoid_print
                    print('Password: $fullName');
                  }
                },
                text: "Register",
                width: double.infinity,
                height: 65,
                // color: Colors.blue,
              ),

              const SizedBox(height: 10),

              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: RichText(
                  text: TextSpan(
                    text: "Already have an account?",
                    style: TextStyle(fontSize: 17, color: Color(0xFF1E1E1E)),
                    children: [
                      TextSpan(
                        text: "Sign up",
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
    );
  }
}
