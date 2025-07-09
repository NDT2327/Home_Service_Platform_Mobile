import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_appbar.dart';
import 'package:hsp_mobile/features/job/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/widgets/task_list_content.dart';
import 'package:provider/provider.dart';

class HousekeeperHomeScreen extends StatefulWidget {
  final String currentUserName;

  const HousekeeperHomeScreen({super.key, required this.currentUserName});

  @override
  State<HousekeeperHomeScreen> createState() => _HousekeeperHomeScreenState();
}

class _HousekeeperHomeScreenState extends State<HousekeeperHomeScreen>
    with TickerProviderStateMixin {
  //tab controller
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    //Fetch both task types
    final provider = Provider.of<TaskClaimProvider>(context, listen: false);
    provider.fetchAvailableTasks();
    provider.fetchClaimedTasks();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskClaimProvider>(context);
    return Scaffold(
      appBar: CustomAppbar(
        currentUserName: widget.currentUserName,
        showTabBar: true,
        tabController: _tabController,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: Responsive.getMaxWidth(context),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Tab 1: Available Tasks
                  RefreshIndicator(
                    onRefresh: () => provider.fetchAvailableTasks(),
                    child: TaskListContent(provider: provider),
                  ),

                  // Tab 2: My Claimed Tasks
                  RefreshIndicator(
                    onRefresh: () => provider.fetchClaimedTasks(),
                    child: TaskListContent(provider: provider),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
