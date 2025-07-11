import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/services/task_service.dart';

class TaskClaimProvider with ChangeNotifier {
  // This class can be used to manage the state and logic related to task claims.
  // It can include methods for fetching tasks, claiming tasks, and updating task statuses.

  //Danh sách các bookings detail có thể nhận (chưa có housekeeper nhận)
  List<BookingDetail> _availableTasks = [];
  //Danh sách các bookings detail đã nhận (đã có housekeeper nhận)
  List<TaskClaim> _claimedTasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  final _taskService =
      TaskService(); // Assuming you have a TaskService to fetch tasks

  List<BookingDetail> get availableTasks => _availableTasks;
  List<TaskClaim> get claimedTasks => _claimedTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Example method to fetch available tasks
  Future<void> fetchAvailableTasks() async {
    _isLoading = true;
    notifyListeners();
    try {
      _availableTasks = await _taskService.getBookingDetails();
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Failed to load tasks: $error';
    }
    _isLoading = false;
    notifyListeners();
  }

  // Example method to fetch claimed tasks
  Future<void> fetchClaimedTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate a network call to fetch claimed tasks
      await Future.delayed(Duration(seconds: 2));
      // Here you would typically fetch data from an API or database
      _claimedTasks = []; // Replace with actual data fetching logic
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Failed to load claimed tasks';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example method to claim a task
  Future<void> claimTask({
    required int detailId,
    required int housekeeperId,
  }) async {
    _isLoading = true;
    notifyListeners(); //notify all the listeners of a ChangeNotifier object that some change has occurred, prompting them to rebuild their widgets.
    // Logic to claim a task
    try {
      //TODO: send request claim task to server
      await Future.delayed(Duration(seconds: 2)); // Simulate network delay
      //after successful claim, add to claimed tasks
      _claimedTasks.add(
        TaskClaim(
          claimId: DateTime.now().millisecondsSinceEpoch, // Example claim ID
          detailId: detailId,
          housekeeperId: housekeeperId,
          claimDate: DateTime.now(),
          statusId: 1, // Assuming 1 means claimed
          note: null,
        ),
      );
      // Remove from available tasks
      _availableTasks.removeWhere((task) => task.detailId == detailId);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Failed to claim task';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example method to complete a task
  Future<void> completeTask(int taskId) async {
    _isLoading = true;
    notifyListeners();
    // Logic to mark a task as completed
    try {
      // Simulate a network call to mark a task as completed
      await Future.delayed(Duration(seconds: 2));
      // Here you would typically update the task status in your database or API
      //find the task in claimed tasks and update its status
      final idx = _claimedTasks.indexWhere((task) => task.detailId == taskId);
      if (idx != -1) {
        _claimedTasks[idx] = TaskClaim(
          claimId: _claimedTasks[idx].claimId,
          detailId: _claimedTasks[idx].detailId,
          housekeeperId: _claimedTasks[idx].housekeeperId,
          claimDate: _claimedTasks[idx].claimDate,
          statusId: 2, // 2: completed
          note: _claimedTasks[idx].note,
        );
      }
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Failed to complete task';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Example method to cancel a task claim
  Future<void> cancelTaskClaim(int detailId, String note) async {
    _isLoading = true;
    notifyListeners();
    // Logic to cancel a task claim
    try {
      // Simulate a network call to cancel a task claim
      await Future.delayed(Duration(seconds: 2));
      // Here you would typically update the task status in your database or API
      _claimedTasks.add(
        TaskClaim(
          claimId: DateTime.now().millisecondsSinceEpoch,
          detailId: detailId,
          housekeeperId: 0,
          statusId: 3,
          note: note
        ),
      );
      //remove from claimed tasks
      _claimedTasks.removeWhere((task) => task.detailId == detailId);
      _errorMessage = null;
    } catch (error) {
      _errorMessage = 'Failed to cancel task claim';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
