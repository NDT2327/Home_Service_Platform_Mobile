import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:provider/provider.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_content.dart';

class TaskListBody extends StatefulWidget {
  const TaskListBody({super.key});

  @override
  State<TaskListBody> createState() => _TaskListBodyState();
}

class _TaskListBodyState extends State<TaskListBody> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Future.microtask(() {
        Provider.of<TaskClaimProvider>(
          context,
          listen: false,
        ).loadAvailableTasks();
      });
      _isInit = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context);
    final isLoading = provider.isLoading;
    final error = provider.errorMessage;
    final bookingDetails = provider.availableTasks;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error != null) {
          return Center(child: Text('Error: $error'));
        }

        if (bookingDetails.isEmpty) {
          return const Center(child: Text('No available tasks found.'));
        }

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: Responsive.getMaxWidth(context),
            ),
            child: TaskListContent(availableTasks: bookingDetails),
          ),
        );
      },
    );
  }
}
