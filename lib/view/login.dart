import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/image.dart';
import 'package:flutter_application_1/controller/login_controller.dart'; // استيراد الكونترولر
import 'package:flutter_application_1/view/register.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController(text: "eyman");
  final _passwordController = TextEditingController(text: "eymaneyman");
  final _formKey = GlobalKey<FormState>();

  final loginController = Get.put(LoginController()); // استدعاء الكونترولر

  bool _isPasswordVisible = false; // State for password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppImageAsset.slider1,
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 400,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        } else if (value.length <= 4) {
                          return 'Username must be more than 4 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        } else if (value.length < 8 || value.length > 25) {
                          return 'Password must be between 8 and 25 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.orange,
                          minimumSize: const Size(200, 50),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // استدعاء طريقة login من الكونترولر
                            loginController.login(
                              _usernameController.text,
                              _passwordController.text,
                            );
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const RegisterPage());
                        },
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don’t have an account? ',
                              style: TextStyle(
                                color: AppColor.purple,
                              ),
                            ),
                            Text(
                              'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.purple,
                                decoration: TextDecoration.underline,
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
        ],
      ),
    );
  }
}
