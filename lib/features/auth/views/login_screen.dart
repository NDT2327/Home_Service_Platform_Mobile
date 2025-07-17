import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/widgets/index.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/providers/auth_provider.dart';
import 'package:provider/provider.dart';

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

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final input = _emailController.text.trim();
      final password = _passwordController.text.trim();

      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.login(context, input, password);
      if (success) {
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, AppRoutes.home); // hoặc Home
      } else {
        final error = authProvider.errorMessage ?? 'Đăng nhập thất bại';
        if (!mounted) return;
        Helpers.showSnackBar(context, error, isError: true);
      }
    }
  }

  void _forgotPassword() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Quên mật khẩu?')));
  }

  void _signUp() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  Widget _buildLoginForm(double maxWidth) {
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
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
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 8),
            // Subtitle text
            Text(
              'login.subtitle'.tr(),
              style: TextStyle(fontSize: 16, color: AppColors.mediumGray),
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
                  color: AppColors.mediumGray,
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
                textColor: AppColors.primaryLight,
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
                  style: TextStyle(color: AppColors.black),
                ),
                LinkButton(
                  text: 'login.signUpLink'.tr(),
                  textColor: AppColors.primaryLight,
                  onPressed: _signUp,
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<AuthProvider>().isLoading;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Responsive(
              mobile: _buildLoginForm(400),
              tablet: _buildLoginForm(500),
              desktop: _buildLoginForm(400),
            ),
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
