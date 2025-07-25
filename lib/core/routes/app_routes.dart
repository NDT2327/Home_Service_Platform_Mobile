import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home/views/home_page_screen.dart';
import 'package:hsp_mobile/features/home/views/housekeeper_home_screen.dart';
import 'package:hsp_mobile/features/auth/views/login_screen.dart';
import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
import 'package:hsp_mobile/features/introduction/splash_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';

class AppRoutes {
  // static const String onBoarding = '/on-boarding';
  // static const String splash = '/splash';
  // static const String home = '/';
  // static const String login = '/login';
  // static const String register = '/sign-in';
  // static const String bookingSummary = '/booking-summary';
  // static const String jobList = '/task-list';
  // static const String housekeeperHome = "/housekeeper/home";
  // static const String mainListBooking = '/main-list-booking';
  // static const String housekeeperProfile = '/housekeeper/profile';
  // static const String housekeeperMyTask = '/housekeeper/my-task';
  // static const String categoryScreen = '/category-screen';

  // static const String editProfile = '/profile/edit';
  // static const String privacy = '/privacy';
  // static const String termsConditions = '/terms';
  // static const String profile = '/profile';

  // static const String mainLayout ='/main';

  static const String splash = '/splash';
  static const String onBoarding = '/on-boarding';
  static const String login = '/login';
  static const String register = '/register';

  // Main layout (NavigationLayout)
  static const String mainLayout = '/cozycare';
  static const String home = '/home';
  static const String categoryScreen = '/categories';
  static const String mainListBooking = '/bookings';
  static const String bookingSummary = '/bookings/summary';
  static const String profile = '/profile';
  static const String jobList = '/tasks-list';
  //static const String housekeeperHome = '/housekeeper-home';
  //static const String housekeeperProfile = '/housekeeper-profile';
  static const String housekeeperMyTask = '/my-tasks';

  // Static pages
  static const String privacy = '/main/privacy';
  static const String termsConditions = '/main/terms';

  // Special routes
  static const String editProfile = '/profile/edit'; 

  static const String service = '/service';
  static const String serviceDetail = '/service-detail';


    static String getEditProfileRoute(int roleId) {
    switch (roleId) {
      case 1:
        return '$mainLayout/admin$editProfile';
      case 2:
        return '$mainLayout/customer$editProfile';
      case 3:
        return '$mainLayout/housekeeper$editProfile';
      default:
        return '$mainLayout/default$editProfile';
    }
  }
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
        return MaterialPageRoute(builder: (_) => const HomePageScreen());
      // case AppRoutes.bookingSummary:
      //   return MaterialPageRoute(
      //     builder: (_) => const BookingSummaryScreen(serviceId: 1),
      //   );
      case AppRoutes.jobList:
        return MaterialPageRoute(builder: (_) => const JobListScreen());
      // case AppRoutes.housekeeperHome:
      //   return MaterialPageRoute(builder: (_) => const HousekeeperHomepage());
      case AppRoutes.mainListBooking:
        return MaterialPageRoute(
          builder: (_) => const MainListBooking(),
        ); // Assuming this is the main
      // case AppRoutes.housekeeperProfile:
      //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
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
