import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';
import 'package:hsp_mobile/features/job/task_claim_provider.dart';
import 'package:hsp_mobile/features/job/views/job_detail_screen.dart';
import 'package:hsp_mobile/features/job/widgets/task_card.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class JobListScreen extends StatefulWidget {
  const JobListScreen({super.key});

  @override
  State<JobListScreen> createState() => _JobListScreenState();
}

class _JobListScreenState extends State<JobListScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch tasks when screen initializes
    Future.microtask(
      () =>
          Provider.of<TaskClaimProvider>(
            context,
            listen: false,
          ).fetchAvailableTasks(),
    );
  }

  double _getMaxWidth(BuildContext context) {
    if (Responsive.isMobile(context)) return MediaQuery.of(context).size.width;
    if (Responsive.isTablet(context)) return 500.w;
    return 600.w;
  }

  double _getFontSize(BuildContext context, {required double base}) {
    if (Responsive.isMobile(context)) return base * 0.9;
    if (Responsive.isTablet(context)) return base;
    return base * 1.2;
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (Responsive.isMobile(context))
      return EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    if (Responsive.isTablet(context))
      return EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h);
    return EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h);
  }

  void _showRejectDialog(
    BuildContext context,
    BookingDetail booking,
    TaskClaimProvider provider,
    int housekeeperId,
  ) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _getMaxWidth(context) * 0.9,
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'taskClaim.rejectReason'.tr(),
                    style: TextStyle(
                      fontSize: _getFontSize(context, base: 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.mediumGray,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  CustomTextField(
                    controller: noteController,
                    labelText: 'taskClaim.enterReason'.tr(),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'taskClaim.cancel'.tr(),
                          style: TextStyle(color: AppColors.mediumGray),
                        ),
                      ),
                      CustomButton(
                        text: 'taskClaim.submit'.tr(),
                        backgroundColor: AppColors.error,
                        textColor: AppColors.white,
                        onPressed: () {
                          provider
                              .cancelTaskClaim(
                                booking.detailId,
                                noteController.text,
                              )
                              .then((_) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'taskClaim.cancelSuccess'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: AppColors.error,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  void _showClaimDialog(
    BuildContext context,
    BookingDetail booking,
    TaskClaimProvider provider,
    int housekeeperId,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Theme.of(context).colorScheme.surface,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Container(
              constraints: BoxConstraints(
                maxWidth: _getMaxWidth(context) * 0.9,
              ),
              padding: EdgeInsets.all(16.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'taskClaim.claimConfirm'.tr(),
                    style: TextStyle(
                      fontSize: _getFontSize(context, base: 18),
                      fontWeight: FontWeight.bold,
                      color: AppColors.mediumGray,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'taskClaim.claimPrompt'.tr(args: [booking.serviceName]),
                    style: TextStyle(
                      fontSize: _getFontSize(context, base: 14),
                      color: AppColors.mediumGray,
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'taskClaim.cancel'.tr(),
                          style: TextStyle(color: AppColors.mediumGray),
                        ),
                      ),
                      CustomButton(
                        text: 'taskClaim.confirm'.tr(),
                        backgroundColor: AppColors.success,
                        textColor: AppColors.white,
                        onPressed: () {
                          provider
                              .claimTask(
                                detailId: booking.detailId,
                                housekeeperId: housekeeperId,
                              )
                              .then((_) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'taskClaim.claimSuccess'.tr(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    backgroundColor: AppColors.success,
                                    behavior: SnackBarBehavior.floating,
                                    margin: EdgeInsets.all(16.w),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                );
                              });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final housekeeperId = 3; // Match TaskDetailScreen
    final provider = Provider.of<TaskClaimProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text(
          'taskClaim.title'.tr(),
          style: TextStyle(
            fontSize: _getFontSize(context, base: 20),
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        color: AppColors.white,
        child: RefreshIndicator(
          onRefresh: () => provider.fetchAvailableTasks(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: _getMaxWidth(context)),
                  child:
                      provider.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : provider.errorMessage != null
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  provider.errorMessage!,
                                  style: TextStyle(
                                    fontSize: _getFontSize(context, base: 16),
                                    color: AppColors.error,
                                  ),
                                ),
                                SizedBox(height: 16.h),
                                CustomButton(
                                  text: 'taskDetail.retry'.tr(),
                                  backgroundColor: AppColors.primary,
                                  textColor: AppColors.white,
                                  onPressed:
                                      () => provider.fetchAvailableTasks(),
                                ),
                              ],
                            ),
                          )
                          : provider.availableTasks.isEmpty
                          ? Center(
                            child: Text(
                              'taskClaim.noTasks'.tr(),
                              style: TextStyle(
                                fontSize: _getFontSize(context, base: 16),
                                color: AppColors.mediumGray,
                              ),
                            ),
                          )
                          : ListView.builder(
                            padding: _getPadding(context),
                            itemCount: provider.availableTasks.length,
                            itemBuilder: (context, index) {
                              final booking = provider.availableTasks[index];
                              return TaskCard(
                                serviceName: booking.serviceName,
                                scheduleTime:
                                    booking.scheduleDatetime.toLocal(),
                                customerName: booking.customerName,
                                address: booking.customerAddress,
                                customerPhone: booking.customerPhone,
                                status: booking.status,
                                image: booking.image,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (_) => TaskDetailScreen(
                                            booking: booking,
                                          ),
                                    ),
                                  );
                                },
                                onCompleted:
                                    booking.status.toLowerCase() == 'claimed'
                                        ? () {
                                          provider
                                              .completeTask(booking.detailId)
                                              .then((_) {
                                                ScaffoldMessenger.of(
                                                  context,
                                                ).showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      'taskClaim.completeSuccess'
                                                          .tr(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    backgroundColor:
                                                        AppColors.success,
                                                    behavior:
                                                        SnackBarBehavior
                                                            .floating,
                                                    margin: EdgeInsets.all(
                                                      16.w,
                                                    ),
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            8.r,
                                                          ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        }
                                        : null,
                                onCancel:
                                    booking.status.toLowerCase() == 'claimed'
                                        ? () => _showRejectDialog(
                                          context,
                                          booking,
                                          provider,
                                          housekeeperId,
                                        )
                                        : booking.status.toLowerCase() ==
                                            'pending'
                                        ? () => _showClaimDialog(
                                          context,
                                          booking,
                                          provider,
                                          housekeeperId,
                                        )
                                        : null,
                              );
                            },
                          ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
