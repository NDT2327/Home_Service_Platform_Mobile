import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_body.dart';

class JobListScreen extends StatelessWidget {
  const JobListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('taskClaim.title'.tr(), style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: AppColors.textLight,
        )),
        centerTitle: false,

        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
      ),
      body: const TaskListBody(),
    );
  }
}