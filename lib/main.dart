import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hsp_mobile/routes/app_routes.dart';
import 'package:hsp_mobile/utils/app_theme.dart';
import 'package:hsp_mobile/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      debugShowCheckedModeBanner: false,
    );
    
  }
}
