// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:hsp_mobile/core/models/account.dart';
// import 'package:hsp_mobile/core/widgets/navigation_layout.dart';
// import 'package:hsp_mobile/features/account/views/edit_profile_screen.dart';
// import 'package:hsp_mobile/features/account/views/profile_screen.dart';
// import 'package:hsp_mobile/features/auth/views/login_screen.dart';
// import 'package:hsp_mobile/features/auth/views/sign_up_screen.dart';
// import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
// import 'package:hsp_mobile/features/booking/views/main_list_booking.dart';
// import 'package:hsp_mobile/features/catalog/view/category_screen.dart';
// import 'package:hsp_mobile/features/home/views/home_page_screen.dart';
// import 'package:hsp_mobile/features/home/views/housekeeper_home_screen.dart';
// import 'package:hsp_mobile/features/introduction/on_boarding_screen.dart';
// import 'package:hsp_mobile/features/introduction/splash_screen.dart';
// import 'package:hsp_mobile/features/job/views/job_list_screen.dart';
// import 'package:hsp_mobile/features/job/views/my_task_screen.dart';
// import 'package:hsp_mobile/features/account/account_provider.dart';
// import 'package:provider/provider.dart';

// final GoRouter appRouter = GoRouter(
//   initialLocation: '/splash',
//   routes: [
//     // Splash and Onboarding Routes
//     GoRoute(
//       path: '/splash',
//       builder: (context, state) => const SplashScreen(),

//     ),
//     GoRoute(
//       path: '/onBoarding',
//       builder: (context, state) => const OnBoardingScreen(),
//     ),
//     // Authentication Routes
//     GoRoute(
//       path: '/login',
//       builder: (context, state) => const LoginScreen(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount != null) {
//           return _getRoleDefaultRoute(accountProvider.currentAccount!.roleId);
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/sign-in',
//       builder: (context, state) => const SignUpScreen(),
//     ),
//     // Navigation Layout Route (for nested navigation)
//     GoRoute(
//       path: '/',
//       builder: (context, state) => const NavigationLayout(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         // Optionally redirect to role-specific default route
//         return null;
//       },
//       routes: [
//         GoRoute(
//           path: 'home',
//           builder: (context, state) => const HomePageScreen(),
//         ),
//         GoRoute(
//           path: 'categories',
//           builder: (context, state) => const CategoryScreen(),
//         ),
//         GoRoute(
//           path: 'bookings',
//           builder: (context, state) => const MainListBooking(),
//         ),
//         GoRoute(
//           path: 'jobs',
//           builder: (context, state) => const JobListScreen(),
//         ),
//         GoRoute(
//           path: 'tasks',
//           builder: (context, state) => const MyTaskScreen(),
//         ),
//         GoRoute(
//           path: 'profile',
//           builder: (context, state) => const ProfileScreen(),
//           routes: [
//             GoRoute(
//               path: 'edit',
//               builder: (context, state) {
//                 final account = state.extra as Account?;
//                 return EditProfileScreen(account: account ?? context.read<AccountProvider>().currentAccount!);
//               },
//             ),
//           ],
//         ),
//       ],
//     ),
//     // Role-specific default routes
//     GoRoute(
//       path: '/home',
//       builder: (context, state) => const HomePageScreen(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/jobs',
//       builder: (context, state) => const JobListScreen(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/housekeeper/home',
//       builder: (context, state) => const HousekeeperHomepage(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/main-list-booking',
//       builder: (context, state) => const MainListBooking(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/booking-summary/:serviceId',
//       builder: (context, state) {
//         final serviceId = int.tryParse(state.pathParameters['serviceId'] ?? '1') ?? 1;
//         return BookingSummaryScreen(serviceId: serviceId);
//       },
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/housekeeper/profile',
//       builder: (context, state) => const ProfileScreen(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     GoRoute(
//       path: '/housekeeper/my-task',
//       builder: (context, state) => const MyTaskScreen(),
//       redirect: (context, state) {
//         final accountProvider = context.read<AccountProvider>();
//         if (accountProvider.currentAccount == null) {
//           return '/login';
//         }
//         return null;
//       },
//     ),
//     // Fallback for unknown routes
//     GoRoute(
//       path: '/:path(.*)',
//       builder: (context, state) => Scaffold(
//         body: Center(child: Text('No route defined'.tr())),
//       ),
//     ),
//   ],
//   errorBuilder: (context, state) => Scaffold(
//     body: Center(child: Text('No route defined'.tr())),
//   ),
// );

// // Helper function to determine role-specific default route
// String _getRoleDefaultRoute(int roleId) {
//   switch (roleId) {
//     case 1: // Admin
//       return '/home';
//     case 2: // Customer
//       return '/home';
//     case 3: // Housekeeper
//       return '/jobs';
//     default:
//       return '/home';
//   }
// }