// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hsp_mobile/core/models/task_claim.dart';
// import 'package:hsp_mobile/core/utils/app_color.dart';
// import 'package:hsp_mobile/core/utils/responsive.dart';

// class ClaimTaskCard extends StatelessWidget {
//   final TaskClaim task;

//   const ClaimTaskCard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: EdgeInsets.only(bottom: 16.h),
//       child: Padding(
//         padding: Responsive.getPadding(context),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               task.serviceName,
//               style: TextStyle(
//                 fontSize: Responsive.getFontSize(context, base: 18),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             SizedBox(height: 8.h),
//             _row(Icons.person, task.customerName),
//             _row(Icons.location_on, task.address),
//             _row(Icons.access_time, Helpers.formatDate(task.claimedAt)),
//             _row(Icons.info, 'Trạng thái: ${task.status}'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _row(IconData icon, String text) {
//     return Padding(
//       padding: EdgeInsets.only(bottom: 6.h),
//       child: Row(
//         children: [
//           Icon(icon, size: 16, color: AppColors.mediumGray),
//           SizedBox(width: 8.w),
//           Expanded(
//             child: Text(
//               text,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: AppColors.textDark,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }