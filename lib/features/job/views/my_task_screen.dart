import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/job/provider/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/widgets/task_claim_card.dart';
import 'package:provider/provider.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TaskClaim> taskClaims = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Gọi sau khi widget đã build lần đầu
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadTasks();
    });
  }

Future<void> _loadTasks() async {
  final provider = Provider.of<TaskClaimProvider>(context, listen: false);
  await provider.fetchClaimedTasks();
  if (!mounted) return;
  setState(() {
    taskClaims = provider.claimedTasks;
    isLoading = false;
  });
}

  List<TaskClaim> get filteredTasks {
    final status = ['ALL', 'CLAIMED', 'COMPLETED'][_tabController.index];
    return status == 'ALL'
        ? taskClaims
        : taskClaims.where((e) => e.detail?.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
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
          onTap: (_) => setState(() {}),
        ),
        centerTitle: false,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(3, (_) => _buildTaskList()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList() {
    if (isLoading) return const Center(child: CircularProgressIndicator());
    final tasks = filteredTasks;
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks found'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskClaimCard(claim: task);
        // return Padding(
        //   padding: const EdgeInsets.all(8.0),
        //   child: TaskCard(
        //     bookingDetail: task.detail!,
        //     showActions: true,
        //     onJobDetail: (_) {},
        //     onClaimJob: (_) {},
        //     onCompleteJob: (_) {},
        //   ),
        // );
      },
    );
  }
}
