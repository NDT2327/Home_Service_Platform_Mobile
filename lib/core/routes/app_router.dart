import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/core/widgets/navigation/root_layout.dart';
import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
import 'package:hsp_mobile/features/account/views/profile_screen.dart';
import 'package:hsp_mobile/features/auth/views/login_screen.dart';
import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
import 'package:hsp_mobile/features/booking/views/booking_detail_screen.dart';
import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
import 'package:hsp_mobile/features/home/views/home_page_screen.dart';
import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
import 'package:hsp_mobile/features/introduction/splash_screen.dart';
import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

final GoRouter router = GoRouter(
  initialLocation: AppRoutes.splash,
  redirect: (context, state) async {
    final isLoggedIn = await SharedPrefsUtils.isLoggedIn();
    //lấy token và kiểm tra token xem đã hết hạn hay chưa
    final token = await SharedPrefsUtils.getAccessToken();
    final roleId = await SharedPrefsUtils.getRoleId() ?? 0;

    final isProtectedRoute =
        state.uri.toString().startsWith(AppRoutes.mainLayout) ||
        state.uri.toString() == AppRoutes.editProfile;

    //check token is expired or not
    final isTokenExpired = token == null || JwtDecoder.isExpired(token);

    // Nếu chưa đăng nhập hoặc hết hạn token và cố gắng truy cập tuyến đường bảo vệ, chuyển hướng đến login
    if ((!isLoggedIn || isTokenExpired) && isProtectedRoute) {
      //remove token
      await SharedPrefsUtils.clearSession();
      return AppRoutes.login;
    }

    // Nếu đã đăng nhập, chuyển hướng đến màn hình chính của vai trò từ splash
    if (isLoggedIn &&
        !isTokenExpired &&
        state.uri.toString() == AppRoutes.splash) {
      switch (roleId) {
        case 1: // Admin
          return '${AppRoutes.mainLayout}/admin${AppRoutes.home}';
        case 2: // Customer
          return '${AppRoutes.mainLayout}/customer${AppRoutes.home}';
        case 3: // Housekeeper
          return '${AppRoutes.mainLayout}/housekeeper${AppRoutes.jobList}';
        default:
          return '${AppRoutes.mainLayout}/default${AppRoutes.home}';
      }
    }

    // Kiểm tra quyền truy cập tuyến đường dựa trên vai trò
    if (isLoggedIn && !isTokenExpired && isProtectedRoute) {
      if (roleId == 1 &&
          !state.uri.toString().startsWith('${AppRoutes.mainLayout}/admin')) {
        return '${AppRoutes.mainLayout}/admin${AppRoutes.home}';
      } else if (roleId == 2 &&
          !state.uri.toString().startsWith(
            '${AppRoutes.mainLayout}/customer',
          )) {
        return '${AppRoutes.mainLayout}/customer${AppRoutes.home}';
      } else if (roleId == 3 &&
          !state.uri.toString().startsWith(
            '${AppRoutes.mainLayout}/housekeeper',
          )) {
        return '${AppRoutes.mainLayout}/housekeeper${AppRoutes.jobList}';
      } else if (roleId == 0 &&
          !state.uri.toString().startsWith('${AppRoutes.mainLayout}/default')) {
        return '${AppRoutes.mainLayout}/default${AppRoutes.home}';
      }
    }

    return null;
  },
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onBoarding,
      builder: (context, state) => const OnBoardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const SignUpScreen(),
    ),
    // ShellRoute cho Customer (roleId = 2)
    ShellRoute(
      builder: (context, state, child) => RootLayout(screen: child),
      routes: [
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.home}',
          builder: (context, state) => const HomePageScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.categoryScreen}',
          builder: (context, state) => const CategoryScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.mainListBooking}',
          builder: (context, state) => const MainListBooking(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.bookingSummary}',
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Booking Summary Screen')),
              ),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.profile}',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/customer${AppRoutes.editProfile}',
          builder: (context, state) {
            final account = state.extra as Account;
            print("Edit Profile route: $account"); // Debug tại đây

            return EditProfileScreen(account: account);
          },
        ),
        GoRoute(
          path: '/booking-detail',
          builder: (context, state) {
            final booking = state.extra as Booking;
            return BookingDetailScreen(booking: booking);
          },
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Privacy Screen'))),
        ),
        GoRoute(
          path: AppRoutes.termsConditions,
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Terms and Conditions Screen')),
              ),
        ),
      ],
    ),
    // ShellRoute cho Housekeeper (roleId = 3)
    ShellRoute(
      builder: (context, state, child) => RootLayout(screen: child),
      routes: [
        GoRoute(
          path: '${AppRoutes.mainLayout}/housekeeper${AppRoutes.jobList}',
          builder: (context, state) => const JobListScreen(),
        ),
        GoRoute(
          path:
              '${AppRoutes.mainLayout}/housekeeper${AppRoutes.housekeeperMyTask}',
          builder: (context, state) => const MyTaskScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/housekeeper${AppRoutes.profile}',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/housekeeper${AppRoutes.editProfile}',
          builder: (context, state) {
            final account = state.extra as Account;
            debugPrint("Edit Profile route: $account"); // Debug tại đây

            return EditProfileScreen(account: account);
          },
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Privacy Screen'))),
        ),
        GoRoute(
          path: AppRoutes.termsConditions,
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Terms and Conditions Screen')),
              ),
        ),
      ],
    ),
    // ShellRoute cho Admin (roleId = 1)
    ShellRoute(
      builder: (context, state, child) => RootLayout(screen: child),
      routes: [
        GoRoute(
          path: '${AppRoutes.mainLayout}/admin${AppRoutes.home}',
          builder: (context, state) => const HomePageScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/admin${AppRoutes.mainListBooking}',
          builder: (context, state) => const MainListBooking(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/admin${AppRoutes.profile}',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) {
            final account = state.extra as Account;
            return EditProfileScreen(account: account);
          },
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Privacy Screen'))),
        ),
        GoRoute(
          path: AppRoutes.termsConditions,
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Terms and Conditions Screen')),
              ),
        ),
      ],
    ),
    // ShellRoute cho Default (roleId = 0 hoặc không xác định)
    ShellRoute(
      builder: (context, state, child) => RootLayout(screen: child),
      routes: [
        GoRoute(
          path: '${AppRoutes.mainLayout}/default${AppRoutes.home}',
          builder: (context, state) => const HomePageScreen(),
        ),
        GoRoute(
          path: '${AppRoutes.mainLayout}/default${AppRoutes.profile}',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: AppRoutes.editProfile,
          builder: (context, state) {
            final account = state.extra as Account;
            return EditProfileScreen(account: account);
          },
        ),
        GoRoute(
          path: AppRoutes.privacy,
          builder:
              (context, state) =>
                  const Scaffold(body: Center(child: Text('Privacy Screen'))),
        ),
        GoRoute(
          path: AppRoutes.termsConditions,
          builder:
              (context, state) => const Scaffold(
                body: Center(child: Text('Terms and Conditions Screen')),
              ),
        ),
      ],
    ),
  ],
  errorBuilder:
      (context, state) =>
          const Scaffold(body: Center(child: Text('No Route defined'))),
);
