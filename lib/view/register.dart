import 'package:flutter/material.dart';
import 'package:flutter_application_1/constant/color.dart';
import 'package:flutter_application_1/constant/image.dart';
import 'package:flutter_application_1/controller/register_controller.dart'; // قم بتغيير المسار حسب مكان الكونترولر
import 'package:flutter_application_1/view/login.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final registerController = Get.put(Register()); // استدعاء الكونترولر

  bool _isPasswordVisible = false; // State for password visibility
  bool _isConfirmPasswordVisible =
      false; // State for confirm password visibility

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              AppImageAsset.slider2,
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
                      'Register',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColor.purple,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        labelStyle: TextStyle(color: AppColor.purple),
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
                        labelStyle: const TextStyle(color: AppColor.purple),
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
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        labelStyle: const TextStyle(color: AppColor.purple),
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isConfirmPasswordVisible =
                                  !_isConfirmPasswordVisible;
                            });
                          },
                        ),
                      ),
                      obscureText: !_isConfirmPasswordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        } else if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    // Centered Register button with custom color
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColor.orange,
                          minimumSize:
                              const Size(200, 50), // Make the button wider
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            registerController.register(
                              _usernameController.text,
                              _passwordController.text,
                            );
                           
                          }
                        },
                        child: const Text('Register'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Get.to(() => const LoginPage());
                        },
                        child: const Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center, // Center the row
                          children: [
                            Text(
                              'Have an account? ', // Display "Login" as the text for navigation
                              style: TextStyle(
                                color: AppColor.purple,
                              ),
                            ),
                            Text(
                              'Login', // Display "Login" as the text for navigation
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
