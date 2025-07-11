import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_theme.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/core/widgets/navigation_layout.dart';
import 'package:hsp_mobile/features/auth/providers/account_provider.dart';
import 'package:hsp_mobile/features/auth/providers/auth_provider.dart';
import 'package:hsp_mobile/features/job/provider/task_claim_provider.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tzdukpnhahxukhmxqfag.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InR6ZHVrcG5oYWh4dWtobXhxZmFnIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDgxNjYxMzIsImV4cCI6MjA2Mzc0MjEzMn0.nwDLqFRgblTcIk4gDkTKocUiG6Tzzpcf05MxXopjCF8',
  );
  HttpOverrides.global = MyHttpOverrides(); // Bỏ qua chứng chỉ SSL không hợp lệ
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/lang',
      fallbackLocale: const Locale('en', 'US'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AccountProvider()),
          ChangeNotifierProvider(create: (_) => TaskClaimProvider()),
          // Thêm các provider khác nếu cần
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Initialize ScreenUtil
    ScreenUtil.init(
      context,
      designSize: const Size(360, 690), // Kích thước thiết kế của bạn
      minTextAdapt: true,
      splitScreenMode: true,
    );
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      onGenerateRoute: RouteGenerator.generateRoute,
      home: NavigationLayout(),
      debugShowCheckedModeBanner: false,
    );
  }
}
