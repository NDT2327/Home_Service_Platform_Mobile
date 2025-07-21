import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/providers/task_claim_provider.dart';
import 'package:hsp_mobile/core/utils/enums/task_claim_status.dart';
import 'package:hsp_mobile/core/utils/helpers.dart';
import 'package:hsp_mobile/core/widgets/custom_card.dart';
import 'package:hsp_mobile/features/job/widgets/task_detail_dialog.dart';
import 'package:provider/provider.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) return;
      setState(() {}); // Cập nhật giao diện khi đổi tab
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context, listen: false);

    // Tải dữ liệu khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      provider.fetchClaimedTasksByHousekeeperId();
    });

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        title: const Text(
          "My Tasks",
          style: TextStyle(
            color: AppColors.textLight,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "All"),
            Tab(text: "Active"),
            Tab(text: "Completed"),
          ],
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Consumer<TaskClaimProvider>(
        builder: (context, provider, child) {
          return Column(
            children: [
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildTaskList(provider, null), // All
                    _buildTaskList(provider, TaskClaimStatus.claimed), // Active
                    _buildTaskList(
                      provider,
                      TaskClaimStatus.completed,
                    ), // Completed
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTaskList(TaskClaimProvider provider, TaskClaimStatus? status) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (provider.errorMessage != null) {
      return Center(child: Text(provider.errorMessage!));
    }

    final tasks =
        status != null
            ? provider.filterByStatus(status)
            : provider.claimedTasks;
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final task = tasks[index];
        final claim = task['taskClaim'] as TaskClaim;
        final detail = task['bookingDetail'] as Map<String, dynamic>?;
        final service = task['service'] as Map<String, dynamic>?;
        final booking = task['booking'] as Map<String, dynamic>?;

        final serviceName = service?['serviceName'] ?? 'N/A';
        final schedule = detail?['scheduleDatetime']?.toString() ?? 'N/A';
        final address = booking?['address'] ?? 'No address';
        final price =
            detail != null
                ? '${detail['quantity']} × ${Helpers.formatMoney(detail['unitPrice'])} = ${Helpers.formatMoney(detail['quantity'] * detail['unitPrice'])}'
                : 'N/A';

        return CustomCard(
          title: serviceName,
          subtitle: address,
          badge: TaskClaimStatusExt.fromId(claim.statusId).label,
          footer: "$schedule\n$price",
          gradient: LinearGradient(
            colors: [AppColors.primary, AppColors.primaryLight],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          onTap: () {
            // Navigate to detail dialog
            showDialog(
              context: context,
              builder: (context) => TaskDetailDialog(task: task),
            );
          },
        );
      },
    );
  }
}
