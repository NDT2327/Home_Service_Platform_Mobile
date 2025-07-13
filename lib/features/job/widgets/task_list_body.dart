import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_content.dart';

// Dữ liệu mock cho danh sách công việc chưa được nhận
final List<Map<String, dynamic>> mockAvailableTasks = [
  {
    'detailId': 1,
    'bookingId': 1,
    'serviceId': 1,
    'scheduleDatetime': '2025-07-08T10:58:00Z',
    'quantity': 1,
    'unitPrice': 50.00,
    'bookingNumber': 'BOOK001',
    'customerName': 'Nguyễn Văn An',
    'serviceName': 'Standard House Cleaning',
    'status': 'Available',
  },
  {
    'detailId': 4,
    'bookingId': 4,
    'serviceId': 1,
    'scheduleDatetime': '2025-07-10T08:58:00Z',
    'quantity': 1,
    'unitPrice': 80.00,
    'bookingNumber': 'BOOK004',
    'customerName': 'Trần Thị Bình',
    'serviceName': 'Standard House Cleaning',
    'status': 'Available',
  },
];

class TaskListBody extends StatelessWidget {
  const TaskListBody({super.key});

  @override
  Widget build(BuildContext context) {
        // Chuyển đổi mock dữ liệu thành List<BookingDetail>
    final List<BookingDetail> bookingDetails = mockAvailableTasks
        .map((json) => BookingDetail.fromJson(json))
        .toList();
    return LayoutBuilder(
      builder: (context, constraints) {
        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.getMaxWidth(context),
            ),
            child: TaskListContent(
              availableTasks: bookingDetails,
            ), // Truyền dữ liệu mock
          ),
        );
      },
    );
  }
}
