import 'package:flutter/material.dart';
import 'package:hsp_mobile/routes/app_routes.dart';
import 'package:hsp_mobile/utils/app_theme.dart';
import 'package:hsp_mobile/utils/constants.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
    
  }
}
