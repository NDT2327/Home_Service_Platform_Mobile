import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/app_logo.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';
import 'package:hsp_mobile/core/widgets/link_button.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hsp_mobile/features/auth/widgets/otp_dialog.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String _otpValue = '';

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  void _onSignUp() async{
    if (_fullNameController.text.isEmpty) {
      _showError('signUp.fullNameRequired'.tr());
      return;
    }
    if (_emailController.text.isEmpty) {
      _showError('signUp.emailRequired'.tr());
      return;
    }
    if (_phoneController.text.isEmpty) {
      _showError('signUp.phoneRequired'.tr());
      return;
    }
    if (_passwordController.text.isEmpty) {
      _showError('signUp.passwordRequired'.tr());
      return;
    }
    if (_confirmPasswordController.text.isEmpty) {
      _showError('signUp.confirmPasswordRequired'.tr());
      return;
    }
    if (_passwordController.text.length < 6) {
      _showError('signUp.passwordMinLength'.tr());
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _showError('signUp.passwordsDoNotMatch'.tr());
      return;
    }

        // Hiển thị dialog nhập OTP
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OtpDialog(
        onConfirm: (otp) {
          // Xử lý khi nhập đúng OTP
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'signUp.signUpSuccess'.tr(),
                style: TextStyle(color: AppColors.white),
              ),
              backgroundColor: AppColors.success,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        },
      ),
    );

    final account = Account(
      accountId: 0,
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      avatar: null,
      address: null,
      phone: _phoneController.text,
      roleId: 1,
      statusId: 1,
      createdDate: null,
      createdBy: null,
      updatedDate: null,
      updatedBy: null,
    );

  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              // Logo
              const Center(child: AppLogo(size: 80)),
              const SizedBox(height: 24),
              // Title
              Text(
                'signUp.createAccount'.tr(),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              // Subtitle
              Text(
                'signUp.subtitle'.tr(),
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.gray,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              // Name
              CustomTextField(
                controller: _fullNameController,
                labelText: 'signUp.fullName'.tr(),
              ),
              const SizedBox(height: 16),
              // Email
              CustomTextField(
                controller: _emailController,
                labelText: 'signUp.email'.tr(),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              // Phone
              CustomTextField(
                controller: _phoneController,
                labelText: 'signUp.phone'.tr(),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              // Password
              CustomTextField(
                controller: _passwordController,
                labelText: 'signUp.password'.tr(),
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
              ),
              const SizedBox(height: 16),
              // Confirm Password
              CustomTextField(
                controller: _confirmPasswordController,
                labelText: 'signUp.confirmPassword'.tr(),
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
              ),
              const SizedBox(height: 24),
              // Signup Button
              CustomButton(
                text: 'signUp.signUp'.tr(),
                onPressed: _onSignUp,
              ),
              const SizedBox(height: 24),
              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'signUp.alreadyHaveAccount'.tr(),
                    style: TextStyle(color: AppColors.gray),
                  ),
                  LinkButton(
                    text: 'signUp.login'.tr(),
                    textColor: AppColors.primary,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.login);
                    },
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
    _confirmPasswordController.dispose();
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}