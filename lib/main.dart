import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:hsp_mobile/core/providers/catalog_provider.dart';
import 'package:hsp_mobile/core/routes/app_router.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/services/booking_detail_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/core/services/task_service.dart';
import 'package:hsp_mobile/core/utils/app_theme.dart';
import 'package:hsp_mobile/core/utils/constants.dart';
import 'package:hsp_mobile/features/account/account_provider.dart';
import 'package:hsp_mobile/core/providers/auth_provider.dart';
import 'package:hsp_mobile/core/providers/booking_detail_provider.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/repository/task_available_repository.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
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

  usePathUrlStrategy();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('vi')],
      path: 'assets/lang',
      fallbackLocale: const Locale('vi', 'Vie'),
      child: MultiProvider(
        providers: [
          //nạp các provider
          ChangeNotifierProvider(create: (_) => AuthProvider()),
          ChangeNotifierProvider(create: (_) => AccountProvider()),
          ChangeNotifierProvider(
            create:
                (_) => TaskClaimProvider(
                  taskService: TaskService(),
                  taskAvailableRepository: TaskAvailableRepository(
                    bookingDetailService: BookingDetailService(),
                    bookingService: BookingService(),
                    accountService: AccountService(),
                    catalogService: CatalogService(),
                  ),
                ),
          ),
          ChangeNotifierProvider(create: (_) => BookingDetailProvider()),
          ChangeNotifierProvider(
            create: (_) => CatalogProvider(catalogService: CatalogService()),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   localizationsDelegates: context.localizationDelegates,
    //   supportedLocales: context.supportedLocales,
    //   locale: context.locale,
    //   title: AppConstants.appName,
    //   theme: AppTheme.lightTheme,
    //   //initialRoute: AppRoutes.login,
    //   onGenerateRoute: RouteGenerator.generateRoute,
    //   home: isLoggedIn ? const NavigationLayout() : const LoginScreen(),
    //   debugShowCheckedModeBanner: false,
    // );
    return MaterialApp.router(
      routerConfig: router,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
    );
  }
}
