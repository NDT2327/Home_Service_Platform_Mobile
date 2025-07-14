import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/services/booking_detail_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';

class TaskAvailableRepository {
  final BookingDetailService bookingDetailService;
  final BookingService bookingService;
  final AccountService accountService;
  final CatalogService catalogService;

  TaskAvailableRepository({
    required this.bookingDetailService,
    required this.bookingService,
    required this.accountService,
    required this.catalogService,
  });

  Future<List<TaskAvailableViewModel>> getEnrichedTasks() async {
    final response = await bookingDetailService.fetchAvailableTasks();
    if (response.data == null) return [];

    return Future.wait(
      response.data!.map((task) async {
        final booking = await bookingService.fetchBookingByBookingId(
          task.bookingId,
        );
        final customer = await accountService.getAccountById(
          booking.customerId,
        );
        final service = await catalogService.getServiceById(task.serviceId);
        return TaskAvailableViewModel(
          task: task,
          customerName: customer.data?.fullName ?? '',
          customerPhone: customer.data?.phone ?? '',
          customerAddress: customer.data?.address ?? '',
          serviceName: service.serviceName,
        );
      }),
    );
  }
}
