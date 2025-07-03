import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/index.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;

  //toggle password visibility
  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  //login function
  void _login() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // Perform login logic here
      // For example, call an API to authenticate the user
      //show success message
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Đăng nhập thành công')));
    }
  }

  //forgot password function
  void _forgotPassword() {
    // Navigate to forgot password screen or show a dialog
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Quên mật khẩu?')));
  }

  //sign up function
  void _signUp() {
    // Navigate to sign up screen
    Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              // Logo
              const AppLogo(),
              const SizedBox(height: 16),
              // Welcome back text
              Text(
                'login.welcomeBack'.tr(),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              // Subtitle text
              Text(
                'login.subtitle'.tr(),
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.gray, // Màu #888888
                ),
              ),
              const SizedBox(height: 32),
              // Email input
              CustomTextField(
                controller: _emailController,
                labelText: 'login.email'.tr(),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Password input
              CustomTextField(
                controller: _passwordController,
                labelText: 'login.password'.tr(),
                keyboardType: TextInputType.visiblePassword,
                obscureText: _obscureText,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: AppColors.gray, // Màu #888888
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 16),
              // Forgot Password
              Align(
                alignment: Alignment.centerRight,
                child: LinkButton(
                  text: 'login.forgotPassword'.tr(),
                  onPressed: _forgotPassword,
                  textColor: AppColors.info,
                ),
              ),
              const SizedBox(height: 24),
              // Login Button
              CustomButton(
                text: 'login.loginButton'.tr(),
                onPressed: _login,
                backgroundColor: AppColors.primary,
                textColor: AppColors.white,
              ),
              const SizedBox(height: 16),
              // Sign Up Button
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'login.dontHaveAccount'.tr(),
                    style: TextStyle(color: AppColors.gray),
                  ),
                  LinkButton(
                    text: 'login.signUpLink'.tr(),
                    textColor: AppColors.info,
                    onPressed: _signUp,
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
