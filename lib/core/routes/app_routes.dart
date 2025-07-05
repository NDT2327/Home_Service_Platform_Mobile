import 'package:flutter/material.dart';
import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
import 'package:hsp_mobile/features/home_page.dart';
import 'package:hsp_mobile/features/auth/views/login_screen.dart';
import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
import 'package:hsp_mobile/features/introduction/splash_screen.dart';

class AppRoutes {
  static const String onBoarding = '/onBoarding';
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/sign-in';
  static const String bookingSummary = '/booking-summary';
}

//Route generator
class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.onBoarding:
        return MaterialPageRoute(builder: (_) => const OnBoardingScreen());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case AppRoutes.bookingSummary:
        return MaterialPageRoute(builder: (_) => const BookingSummaryScreen(serviceId: 1));
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No Route defined'))),
        );
    }
  }
}
