import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/task_claim.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';

class MyTaskScreen extends StatefulWidget {
  const MyTaskScreen({super.key});

  @override
  State<MyTaskScreen> createState() => _MyTaskScreenState();
}

class _MyTaskScreenState extends State<MyTaskScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<TaskClaim> taskClaims = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadTasks();
  }

  void _loadTasks() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      taskClaims = [TaskClaim(
            claimId: 1,
            detailId: 2,
            housekeeperId: 3,
            claimDate: DateTime.parse("2025-07-08T08:58:00Z"),
            statusId: 1, // CLAIMED
            note: null,
            detail: BookingDetail(
              detailId: 2,
              bookingId: 2,
              serviceId: 2,
              scheduleDatetime: DateTime.parse("2025-07-09T08:58:00Z"),
              quantity: 2,
              unitPrice: 100.0,
              serviceName: "Deep Cleaning",
              customerName: "Lê Thị Hoa",
              customerPhone: "0912345678",
              customerAddress: "456 Nguyễn Trãi, Hà Nội",
              totalAmount: 200.0,
              notes: "Focus on kitchen and bathroom",
              status: "CLAIMED",
              image: null,
            ),
          ),
          TaskClaim(
            claimId: 2,
            detailId: 3,
            housekeeperId: 4,
            claimDate: DateTime.parse("2025-07-08T08:58:00Z"),
            statusId: 1, // CLAIMED
            note: null,
            detail: BookingDetail(
              detailId: 3,
              bookingId: 3,
              serviceId: 3,
              scheduleDatetime: DateTime.parse("2025-07-08T13:58:00Z"),
              quantity: 3,
              unitPrice: 30.0,
              serviceName: "Window Cleaning",
              customerName: "Nguyễn Văn B",
              customerPhone: "0909876543",
              customerAddress: "789 Lý Thường Kiệt, TP.HCM",
              totalAmount: 90.0,
              notes: "Clean all windows",
              status: "CLAIMED",
              image: null,
            ),
          ),
          TaskClaim(
            claimId: 3,
            detailId: 4,
            housekeeperId: 3,
            claimDate: DateTime.parse("2025-07-07T08:58:00Z"),
            statusId: 2, // COMPLETED
            note: null,
            detail: BookingDetail(
              detailId: 4,
              bookingId: 4,
              serviceId: 1,
              scheduleDatetime: DateTime.parse("2025-07-07T10:00:00Z"),
              quantity: 1,
              unitPrice: 80.0,
              serviceName: "General Cleaning",
              customerName: "Trần Văn C",
              customerPhone: "0898765432",
              customerAddress: "321 Điện Biên Phủ, Đà Nẵng",
              totalAmount: 80.0,
              notes: "Regular cleaning",
              status: "COMPLETED",
              image: null,
            ),
          ),
        ];; // Load your mock data here
      isLoading = false;
    });
  }

  List<TaskClaim> get filteredTasks {
    final status = ['ALL', 'CLAIMED', 'COMPLETED'][_tabController.index];
    return status == 'ALL' ? taskClaims : taskClaims.where((e) => e.detail?.status == status).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        title: const Text("My Tasks", style: TextStyle(
          color: AppColors.textLight,
          fontWeight: FontWeight.bold
        ),),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: "All"), Tab(text: "Active"), Tab(text: "Completed")],
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
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TaskCard(
            bookingDetail: task.detail!,
            showActions: true,
            onJobDetail: (_) {},
            onClaimJob: (_) {},
            onCompleteJob: (_) {},
          ),
        );
      },
    );
  }
}
