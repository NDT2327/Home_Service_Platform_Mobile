import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
import 'package:hsp_mobile/features/home/housekeeper_home_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home_page.dart';
import 'package:hsp_mobile/features/auth/views/login_screen.dart';
import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
import 'package:hsp_mobile/features/introduction/splash_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';

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
  static const String housekeeperProfile = '/housekeeper/profile';
  static const String housekeeperMyTask = '/housekeeper/my-task';
  static const String categoryScreen = '/category-screen';

  static const String editProfile = '/profile/edit';
  static const String privacy = '/privacy';
  static const String termsConditions = '/terms';
  static const String profile = '/profile';
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
        return MaterialPageRoute(
          builder: (_) => const BookingSummaryScreen(serviceId: 1),
        );
      case AppRoutes.jobList:
        return MaterialPageRoute(builder: (_) => const JobListScreen());
      case AppRoutes.housekeeperHome:
        return MaterialPageRoute(
          builder: (_) => const HousekeeperHomeScreen(currentUserName: "Thinh"),
        );
      case AppRoutes.mainListBooking:
        return MaterialPageRoute(
          builder: (_) => const MainListBooking(),
        ); // Assuming this is the main
      case AppRoutes.housekeeperProfile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.housekeeperMyTask:
        return MaterialPageRoute(builder: (_) => const MyTaskScreen());
      case AppRoutes.categoryScreen:
        return MaterialPageRoute(builder: (_) => const CategoryScreen());
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case AppRoutes.editProfile:
        final account = settings.arguments as Account;
        return MaterialPageRoute(
          builder: (_) => EditProfileScreen(account: account),
        );
      default:
        return MaterialPageRoute(
          builder:
              (_) =>
                  const Scaffold(body: Center(child: Text('No Route defined'))),
        );
    }
  }
}
