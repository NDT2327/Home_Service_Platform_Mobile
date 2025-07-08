import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/responsive.dart';
import 'package:hsp_mobile/core/widgets/custom_button.dart';
import 'package:hsp_mobile/core/widgets/custom_text_field.dart';
import 'package:hsp_mobile/features/job/task_claim_provider.dart';
import 'package:provider/provider.dart';

class TaskDetailScreen extends StatelessWidget {
  final BookingDetail booking;

  const TaskDetailScreen({super.key, required this.booking});

  double _getMaxWidth(BuildContext context) {
    if (Responsive.isMobile(context)) return MediaQuery.of(context).size.width;
    if (Responsive.isTablet(context)) return 500.w;
    return 600.w;
  }

  double _getFontSize(BuildContext context, {required double base}) {
    if (Responsive.isMobile(context)) return base * 0.95;
    if (Responsive.isTablet(context)) return base;
    return base * 1.15;
  }

  EdgeInsets _getPadding(BuildContext context) {
    if (Responsive.isMobile(context)) return EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h);
    if (Responsive.isTablet(context)) return EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h);
    return EdgeInsets.symmetric(horizontal: 32.w, vertical: 32.h);
  }

  void _showRejectDialog(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          constraints: BoxConstraints(maxWidth: _getMaxWidth(context) * 0.9),
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
                      provider.cancelTaskClaim(booking.detailId, noteController.text).then((_) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('taskClaim.cancelSuccess'.tr(), style: const TextStyle(color: Colors.white)),
                            backgroundColor: AppColors.error,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16.w),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                        );
                        Navigator.pop(context); // Quay lại JobListScreen
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

  void _showClaimDialog(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: Container(
          constraints: BoxConstraints(maxWidth: _getMaxWidth(context) * 0.9),
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
                style: TextStyle(fontSize: _getFontSize(context, base: 14), color: AppColors.mediumGray),
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
                      provider.claimTask(detailId: booking.detailId, housekeeperId: housekeeperId).then((_) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('taskClaim.claimSuccess'.tr(), style: const TextStyle(color: Colors.white)),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(16.w),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                          ),
                        );
                        Navigator.pop(context); // Quay lại JobListScreen
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

  Widget _buildDetailRow(BuildContext context, String label, String value, {Color? color}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: _getFontSize(context, base: 16),
              fontWeight: FontWeight.bold,
              color: AppColors.mediumGray,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: _getFontSize(context, base: 16),
                color: color ?? AppColors.getTextColor(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    return SingleChildScrollView(
      padding: _getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (booking.image != null && booking.image!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: Image.network(
                booking.image!,
                width: double.infinity,
                height: 150.h,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(),
              ),
            )
          else
            _buildPlaceholderImage(),
          SizedBox(height: 16.h),
          Text(
            booking.serviceName,
            style: TextStyle(
              fontSize: _getFontSize(context, base: 20),
              fontWeight: FontWeight.bold,
              color: AppColors.getTextColor(context),
            ),
          ),
          SizedBox(height: 12.h),
          _buildDetailRow(context, 'taskDetail.taskId'.tr(), booking.detailId.toString()),
          _buildDetailRow(context, 'taskDetail.customer'.tr(), booking.customerName),
          _buildDetailRow(context, 'taskDetail.phone'.tr(), booking.customerPhone),
          _buildDetailRow(context, 'taskDetail.address'.tr(), booking.customerAddress),
          _buildDetailRow(
            context,
            'taskDetail.date'.tr(),
            DateFormat('dd/MM/yyyy').format(booking.scheduleDatetime),
          ),
          _buildDetailRow(
            context,
            'taskDetail.time'.tr(),
            DateFormat('HH:mm').format(booking.scheduleDatetime),
          ),
          _buildDetailRow(context, 'taskDetail.quantity'.tr(), booking.quantity.toString()),
          _buildDetailRow(context, 'taskDetail.unitPrice'.tr(), '${booking.unitPrice.toStringAsFixed(2)} USD'),
          _buildDetailRow(context, 'taskDetail.total'.tr(), '${booking.totalAmount.toStringAsFixed(2)} USD'),
          if (booking.notes != null && booking.notes!.isNotEmpty)
            _buildDetailRow(context, 'taskDetail.notes'.tr(), booking.notes!),
          _buildDetailRow(
            context,
            'taskDetail.status'.tr(),
            booking.status,
            color: booking.status.toLowerCase() == 'pending'
                ? AppColors.warning
                : booking.status.toLowerCase() == 'claimed'
                    ? AppColors.success
                    : AppColors.error,
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActionButtons(context, provider, housekeeperId),
          ),
        ],
      ),
    );
  }

  Widget _buildTabletLayout(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    return SingleChildScrollView(
      padding: _getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.image != null && booking.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    booking.image!,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(width: 200.w, height: 200.h),
                  ),
                )
              else
                _buildPlaceholderImage(width: 200.w, height: 200.h),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      booking.serviceName,
                      style: TextStyle(
                        fontSize: _getFontSize(context, base: 22),
                        fontWeight: FontWeight.bold,
                        color: AppColors.getTextColor(context),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    _buildDetailRow(context, 'taskDetail.taskId'.tr(), booking.detailId.toString()),
                    _buildDetailRow(context, 'taskDetail.customer'.tr(), booking.customerName),
                    _buildDetailRow(context, 'taskDetail.phone'.tr(), booking.customerPhone),
                    _buildDetailRow(context, 'taskDetail.address'.tr(), booking.customerAddress),
                    if (booking.notes != null && booking.notes!.isNotEmpty)
                      _buildDetailRow(context, 'taskDetail.notes'.tr(), booking.notes!),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      context,
                      'taskDetail.date'.tr(),
                      DateFormat('dd/MM/yyyy').format(booking.scheduleDatetime),
                    ),
                    _buildDetailRow(
                      context,
                      'taskDetail.time'.tr(),
                      DateFormat('HH:mm').format(booking.scheduleDatetime),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(context, 'taskDetail.quantity'.tr(), booking.quantity.toString()),
                    _buildDetailRow(context, 'taskDetail.unitPrice'.tr(), '${booking.unitPrice.toStringAsFixed(2)} USD'),
                    _buildDetailRow(context, 'taskDetail.total'.tr(), '${booking.totalAmount.toStringAsFixed(2)} USD'),
                    _buildDetailRow(
                      context,
                      'taskDetail.status'.tr(),
                      booking.status,
                      color: booking.status.toLowerCase() == 'pending'
                          ? AppColors.warning
                          : booking.status.toLowerCase() == 'claimed'
                              ? AppColors.success
                              : AppColors.error,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActionButtons(context, provider, housekeeperId),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    return SingleChildScrollView(
      padding: _getPadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (booking.image != null && booking.image!.isNotEmpty)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.r),
                  child: Image.network(
                    booking.image!,
                    width: 250.w,
                    height: 250.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => _buildPlaceholderImage(width: 250.w, height: 250.h),
                  ),
                )
              else
                _buildPlaceholderImage(width: 250.w, height: 250.h),
              SizedBox(width: 16.w),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.serviceName,
                          style: TextStyle(
                            fontSize: _getFontSize(context, base: 24),
                            fontWeight: FontWeight.bold,
                            color: AppColors.getTextColor(context),
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _buildDetailRow(context, 'taskDetail.taskId'.tr(), booking.detailId.toString()),
                        _buildDetailRow(context, 'taskDetail.customer'.tr(), booking.customerName),
                        _buildDetailRow(context, 'taskDetail.phone'.tr(), booking.customerPhone),
                        _buildDetailRow(context, 'taskDetail.address'.tr(), booking.customerAddress),
                        if (booking.notes != null && booking.notes!.isNotEmpty)
                          _buildDetailRow(context, 'taskDetail.notes'.tr(), booking.notes!),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(
                          context,
                          'taskDetail.date'.tr(),
                          DateFormat('dd/MM/yyyy').format(booking.scheduleDatetime),
                        ),
                        _buildDetailRow(
                          context,
                          'taskDetail.time'.tr(),
                          DateFormat('HH:mm').format(booking.scheduleDatetime),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                  child: Padding(
                    padding: EdgeInsets.all(16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow(context, 'taskDetail.quantity'.tr(), booking.quantity.toString()),
                        _buildDetailRow(context, 'taskDetail.unitPrice'.tr(), '${booking.unitPrice.toStringAsFixed(2)} USD'),
                        _buildDetailRow(context, 'taskDetail.total'.tr(), '${booking.totalAmount.toStringAsFixed(2)} USD'),
                        _buildDetailRow(
                          context,
                          'taskDetail.status'.tr(),
                          booking.status,
                          color: booking.status.toLowerCase() == 'pending'
                              ? AppColors.warning
                              : booking.status.toLowerCase() == 'claimed'
                                  ? AppColors.success
                                  : AppColors.error,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildActionButtons(context, provider, housekeeperId),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderImage({double width = 150, double height = 150}) {
    return Container(
      width: width.w,
      height: height.h,
      color: AppColors.mediumGray.withOpacity(0.2),
      child: Icon(
        Icons.image_not_supported,
        color: AppColors.mediumGray,
        size: 40.sp,
      ),
    );
  }

  List<Widget> _buildActionButtons(BuildContext context, TaskClaimProvider provider, int housekeeperId) {
    final status = booking.status.toLowerCase();
    return [
      if (status == 'pending')
        CustomButton(
          text: 'taskClaim.claimButton'.tr(),
          backgroundColor: AppColors.primary,
          textColor: AppColors.white,
          onPressed: () => _showClaimDialog(context, provider, housekeeperId),
        ),
      if (status == 'claimed') ...[
        CustomButton(
          text: 'taskClaim.complete'.tr(),
          backgroundColor: AppColors.success,
          textColor: AppColors.white,
          onPressed: () {
            provider.completeTask(booking.detailId).then((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('taskClaim.completeSuccess'.tr(), style: const TextStyle(color: Colors.white)),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                  margin: EdgeInsets.all(16.w),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                ),
              );
              Navigator.pop(context); // Quay lại JobListScreen
            });
          },
        ),
        SizedBox(width: 12.w),
        CustomButton(
          text: 'taskClaim.cancel'.tr(),
          backgroundColor: AppColors.error,
          textColor: AppColors.white,
          onPressed: () => _showRejectDialog(context, provider, housekeeperId),
        ),
      ],
    ];
  }

  @override
  Widget build(BuildContext context) {
    final housekeeperId = 3; // Phù hợp với TaskClaims trong JSON
    final provider = Provider.of<TaskClaimProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'taskDetail.title'.tr(),
          style: TextStyle(
            fontSize: _getFontSize(context, base: 20),
            color: AppColors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(color: AppColors.black),
      ),
      body: Container(
        color: AppColors.white,
        child: provider.isLoading
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
                          onPressed: () => provider.fetchAvailableTasks(),
                        ),
                      ],
                    ),
                  )
                : Responsive(
                    mobile: _buildMobileLayout(context, provider, housekeeperId),
                    tablet: _buildTabletLayout(context, provider, housekeeperId),
                    desktop: _buildDesktopLayout(context, provider, housekeeperId),
                  ),
      ),
    );
  }
}
