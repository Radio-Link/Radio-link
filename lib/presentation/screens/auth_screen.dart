import 'package:flutter/material.dart';
import 'package:walkie_talkie/core/theme/colors.dart';
import 'package:walkie_talkie/core/theme/button_style.dart';
import 'package:walkie_talkie/core/theme/app_text_style.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void toggleForm() => setState(() => isLogin = !isLogin);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 450),
            padding: const EdgeInsets.all(40),
            decoration: BoxDecoration(
              color: AppColors.blackLight,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 15,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 🏷️ Title
                Text(
                  isLogin ? "Welcome Back" : "Create Account",
                  style: AppTextStyles.heading,
                ),
                const SizedBox(height: 40),

                // 👤 Name field (register only)
                if (!isLogin)
                  TextField(
                    controller: _nameController,
                    style: AppTextStyles.input,
                    decoration: InputDecoration(
                      labelText: "Name",
                      labelStyle: AppTextStyles.label,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.whiteGray),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.redLight),
                      ),
                    ),
                  ),
                if (!isLogin) const SizedBox(height: 16),

                // 📧 Email
                TextField(
                  controller: _emailController,
                  style: AppTextStyles.input,
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: AppTextStyles.label,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.whiteGray),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.redLight),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 🔒 Password
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  style: AppTextStyles.input,
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: AppTextStyles.label,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.whiteGray),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.redLight),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // ✅ Submit button
                ElevatedButton(
                  onPressed: () {
                    // TODO: API call
                  },
                  style: AppButtonStyles.primary,
                  child: Text(isLogin ? "Login" : "Register"),
                ),
                const SizedBox(height: 20),

                // 🔁 Toggle link
                TextButton(
                  onPressed: toggleForm,
                  child: RichText(
                    text: TextSpan(
                      style: AppTextStyles.toggleBase,
                      children: [
                        TextSpan(
                          text: isLogin
                              ? "Don't have an account? "
                              : "Already have an account? ",
                        ),
                        TextSpan(
                          text: isLogin ? "Register" : "Login",
                          style: AppTextStyles.toggleHighlight,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // 🌐 Google sign-in
                ElevatedButton.icon(
                  onPressed: () {
                    // TODO: Google sign-in
                  },
                  style: AppButtonStyles.secondary,
                  icon: const Icon(Icons.account_circle, color: AppColors.white),
                  label: const Text("Continue with Google"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
