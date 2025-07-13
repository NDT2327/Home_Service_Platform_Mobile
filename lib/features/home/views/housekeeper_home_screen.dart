import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';

class HousekeeperHomepage extends StatefulWidget {
  const HousekeeperHomepage({super.key});

  @override
  State<HousekeeperHomepage> createState() => _HousekeeperHomepageState();
}

class _HousekeeperHomepageState extends State<HousekeeperHomepage> {
  final int currentHousekeeperId = 4;

  final List<Map<String, dynamic>> availableTasks = [
    {
      'detailId': 1,
      'bookingId': 1,
      'serviceId': 1,
      'scheduleDatetime': '2025-07-08T10:58:00Z',
      'quantity': 1,
      'unitPrice': 50.00,
      'bookingNumber': 'BOOK001',
      'notes': 'Please clean living room thoroughly',
      'serviceName': 'Basic Cleaning',
      'customerName': 'John Smith',
      'address': '123 Main St, Ho Chi Minh City'
    },
    {
      'detailId': 4,
      'bookingId': 4,
      'serviceId': 1,
      'scheduleDatetime': '2025-07-10T08:58:00Z',
      'quantity': 1,
      'unitPrice': 80.00,
      'bookingNumber': 'BOOK004',
      'notes': 'Use eco-friendly products',
      'serviceName': 'Deep Cleaning',
      'customerName': 'Jane Doe',
      'address': '456 Oak Ave, District 1'
    }
  ];

  final List<Map<String, dynamic>> myClaims = [
    {
      'claimId': 2,
      'detailId': 2,
      'housekeeperId': 4,
      'claimDate': '2025-07-08T08:58:00Z',
      'statusId': 2,
      'statusName': 'COMPLETED',
      'bookingNumber': 'BOOK002',
      'serviceName': 'Premium Cleaning',
      'customerName': 'Alice Johnson',
      'scheduleDatetime': '2025-07-09T08:58:00Z',
      'unitPrice': 100.00,
      'notes': 'Focus on kitchen and bathroom',
      'rating': 5,
      'review': 'Excellent service, very thorough!'
    },
    {
      'claimId': 3,
      'detailId': 3,
      'housekeeperId': 3,
      'claimDate': '2025-07-08T08:58:00Z',
      'statusId': 1,
      'statusName': 'CLAIMED',
      'bookingNumber': 'BOOK003',
      'serviceName': 'Window Cleaning',
      'customerName': 'Bob Wilson',
      'scheduleDatetime': '2025-07-08T13:58:00Z',
      'unitPrice': 30.00,
      'notes': 'Clean all windows'
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: Row(
          children: [
            if (Responsive.isDesktop(context)) _buildDesktopSidebar(),
            Expanded(
              child: SingleChildScrollView(
                padding: Responsive.getPadding(context),
                child: _buildMainContent(context),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Responsive.isMobile(context) ? _buildBottomNavigationBar() : null,
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.backgroundLight,
      elevation: 0,
      title: Text(
        'CozyCare',
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: Responsive.getFontSize(context, base: 24),
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        if (!Responsive.isMobile(context)) ...[
          IconButton(icon: const Icon(Icons.search, color: AppColors.textLight), onPressed: () {}),
          IconButton(icon: const Icon(Icons.settings, color: AppColors.textLight), onPressed: () {}),
        ],
        IconButton(icon: const Icon(Icons.notifications, color: AppColors.textLight), onPressed: () {}),
        IconButton(icon: const Icon(Icons.person, color: AppColors.textLight), onPressed: () {}),
        if (Responsive.isDesktop(context)) const SizedBox(width: 16),
      ],
      automaticallyImplyLeading: false,
    );
  }

  Widget _buildDesktopSidebar() {
    return Container(
      width: 250,
      color: AppColors.textLight,
      child: Column(
        children: [
          const SizedBox(height: 20),
          _buildSidebarItem(Icons.home, 'Home', true),
          _buildSidebarItem(Icons.work, 'My Jobs', false),
          _buildSidebarItem(Icons.star, 'Reviews', false),
          _buildSidebarItem(Icons.analytics, 'Analytics', false),
          _buildSidebarItem(Icons.person, 'Profile', false),
          _buildSidebarItem(Icons.settings, 'Settings', false),
          const Spacer(),
          _buildSidebarItem(Icons.logout, 'Logout', false),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: Icon(icon, color: isActive ? AppColors.primaryDark : AppColors.mediumGray),
        title: Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryDark : AppColors.mediumGray,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        selected: isActive,
        selectedTileColor: const Color(0xFF2E7D32).withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        onTap: () {},
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primaryDark ,
      unselectedItemColor: AppColors.mediumGray,
      currentIndex: 0,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: 'My Jobs'),
        BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Reviews'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }

  Future<void> _refreshData() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {});
  }

  Widget _buildMainContent(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Available Tasks',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: availableTasks.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: screenWidth > 900 ? 3 : 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.4,
          ),
          itemBuilder: (context, index) {
            final task = availableTasks[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(task['serviceName'],
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('Customer: ${task['customerName']}'),
                    Text('Address: ${task['address']}'),
                    Text('Schedule: ${task['scheduleDatetime']}'),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.assignment_turned_in),
                        label: const Text('Nhận việc'),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 24),
        Text('My Jobs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: myClaims.length,
          itemBuilder: (context, index) {
            final claim = myClaims[index];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(claim['serviceName']),
                subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Customer: ${claim['customerName']}'),
                      Text('Schedule: ${claim['scheduleDatetime']}'),
                      Text('Status: ${claim['statusName']}'),
                      if (claim['statusName'] == 'CLAIMED')
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.check_circle_outline),
                          label: const Text('Hoàn thành'),
                        ),
                      if (claim['statusName'] == 'COMPLETED')
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber),
                            const SizedBox(width: 4),
                            Text('Rating: ${claim['rating']}'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {},
                              child: const Text('Xem đánh giá'),
                            )
                          ],
                        )
                    ]),
              ),
            );
          },
        )
      ],
    );
  }
}
