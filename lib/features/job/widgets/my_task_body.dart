import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/features/job/provider/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_item.dart';
import 'package:provider/provider.dart';

class MyTaskBody extends StatefulWidget {
  const MyTaskBody({super.key});

  @override
  State<MyTaskBody> createState() => _MyTaskBodyState();
}

class _MyTaskBodyState extends State<MyTaskBody> {
String filter = 'ALL'; // hoặc 'COMPLETED' | 'CLAIMED'

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TaskClaimProvider>(context, listen: false).fetchClaimedTasks();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context);
    final allTasks = provider.claimedTasks;

    final filteredTasks = allTasks.where((task) {
      if (filter == 'ALL') return true;
      if (filter == 'COMPLETED') return task.statusId == 2;
      if (filter == 'CLAIMED') return task.statusId == 1;
      return false;
    }).toList();

    return Column(
      children: [
        Padding(
          padding: Responsive.getPadding(context),
          child: ToggleButtons(
            isSelected: [
              filter == 'ALL',
              filter == 'CLAIMED',
              filter == 'COMPLETED',
            ],
            onPressed: (index) {
              setState(() {
                filter = ['ALL', 'CLAIMED', 'COMPLETED'][index];
              });
            },
            children: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Tất cả"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Đang nhận"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12),
                child: Text("Hoàn thành"),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: Responsive.getPadding(context),
            itemCount: filteredTasks.length,
            itemBuilder: (context, index) {
              final booking = filteredTasks[index];
              return TaskListItem(
                data: booking,
                showActions: false, // không cho nhận/hoàn thành nữa
              );
            },
          ),
        ),
      ],
    );
  }
}