import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/services/task_service.dart';
import 'package:hsp_mobile/features/job/repository/task_available_repository.dart';
import 'package:hsp_mobile/features/job/view_model/task_available_view_model.dart';

class TaskClaimProvider with ChangeNotifier {
  // This class can be used to manage the state and logic related to task claims.
  // It can include methods for fetching tasks, claiming tasks, and updating task statuses.

  //Danh sách các bookings detail có thể nhận (chưa có housekeeper nhận)
  List<TaskAvailableViewModel> _availableTasks = [];
  //Danh sách các bookings detail đã nhận (đã có housekeeper nhận)
  List<TaskClaim> _claimedTasks = [];
  bool _isLoading = false;
  String? _errorMessage;
  //call services
  final TaskService _taskService;
  final TaskAvailableRepository _taskAvailableRepository;

  TaskClaimProvider({
    required TaskService taskService,
    required TaskAvailableRepository taskAvailableRepository,
  }) : _taskService = taskService,
       _taskAvailableRepository = taskAvailableRepository;

  List<TaskAvailableViewModel> get availableTasks => _availableTasks;
  List<TaskClaim> get claimedTasks => _claimedTasks;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Example method to fetch available tasks
  // Future<void> fetchAvailableTasks() async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     _availableTasks = await _taskService.getBookingDetails();
  //     _errorMessage = null;
  //   } catch (error) {
  //     _errorMessage = 'Failed to load tasks: $error';
  //   }
  //   _isLoading = false;
  //   notifyListeners();
  // }

  //GET: get claimed tasks

  Future<void> fetchClaimedTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate a network call to fetch claimed tasks
      await Future.delayed(Duration(seconds: 2));
      // Here you would typically fetch data from an API or database
      final response = await _taskService.fetchClaimedTasks();
      if (response.statusCode == 200) {
        _claimedTasks = response.data ?? [];
        _errorMessage = null;
      } else {
        _errorMessage = response.message ?? "Unkown error";
        _claimedTasks = [];
      }
    } catch (e) {
      _errorMessage = 'Failed to load claimed tasks: $e';
      _claimedTasks = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  //PUT: COMPLETE TASK
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

  //PUT: CANCEL TASK
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
          claimDate: DateTime.now(),
          housekeeperId: 0,
          statusId: 3,
          note: note,
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

  //available tasks
  Future<void> loadAvailableTasks() async {
    _isLoading = true;
    notifyListeners();

    try {
      _availableTasks = await _taskAvailableRepository.getEnrichedTasks();
      print(_availableTasks);
      _errorMessage = null;
    } catch (e) {
      _availableTasks = [];
      _errorMessage = 'Failed to load available tasks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
