import 'package:flutter/material.dart';
import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
import 'package:hsp_mobile/features/home/housekeeper_home_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/home_page.dart';
import 'package:hsp_mobile/features/auth/views/login_screen.dart';
import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
import 'package:hsp_mobile/features/introduction/splash_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';

class AppRoutes {
  static const String onBoarding = '/onBoarding';
  static const String splash = '/splash';
  static const String home = '/';
  static const String login = '/login';
  static const String register = '/sign-in';
  static const String bookingSummary = '/booking-summary';
  static const String jobList = '/task-list';
  static const String housekeeperHome = "/housekeeper/home";
  static const String mainListBooking = '/main-list-booking';
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
      case AppRoutes.jobList:
        return MaterialPageRoute(builder: (_) => const JobListScreen());
        case AppRoutes.housekeeperHome:
        return MaterialPageRoute(builder: (_) => const HousekeeperHomeScreen(currentUserName: "Thinh"));
      case AppRoutes.mainListBooking:
        return MaterialPageRoute(builder: (_) => const MainListBooking()); // Assuming this is the main
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No Route defined'))),
        );
    }
  }
}
