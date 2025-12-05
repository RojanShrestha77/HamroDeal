import 'package:flutter/material.dart';
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

              const SizedBox(height: 20),

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
                text: "Login",
                width: double.infinity,
                height: 50,
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
