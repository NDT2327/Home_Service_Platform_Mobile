import 'package:hsp_mobile/core/models/dtos/response/task_available_response.dart';

class TaskAvailableViewModel {
  final TaskAvailableResponse task;
  final String serviceName;
  final String customerName;
  final String customerPhone;
  final String customerAddress;

  TaskAvailableViewModel({
    required this.task,
    required this.serviceName,
    required this.customerName, 
    required this.customerPhone,
    required this.customerAddress,
  });
}