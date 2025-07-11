import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/provider/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_content.dart';
import 'package:provider/provider.dart';

class TaskListBody extends StatefulWidget {
  const TaskListBody({super.key});

  @override
  State<TaskListBody> createState() => _TaskListBodyState();
}

class _TaskListBodyState extends State<TaskListBody> {
  @override
  void initState() {
    // Initialize any necessary data or state here
    super.initState();
    //call fetchAvailableTasks()
    Future.microtask(() {
      Provider.of<TaskClaimProvider>(
        context,
        listen: false,
      ).fetchAvailableTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context);
    return RefreshIndicator(
      onRefresh: () => provider.fetchAvailableTasks(),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.getMaxWidth(context),
              ),
              child: TaskListContent(provider: provider),
            ),
          );
        },
      ),
    );
  }
}
