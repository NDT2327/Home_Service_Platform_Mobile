import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/models/booking_detail.dart';
import 'package:hsp_mobile/core/models/dtos/response/base_response.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/services/api_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:intl/intl.dart';

class BookingDetailScreen extends StatefulWidget {
  final Booking booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  _BookingDetailScreenState createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Future<List<BookingDetail>> _bookingDetails;
  late Future<BaseResponse<Account>> _account;

  @override
  void initState() {
    super.initState();
    _bookingDetails = BookingService().getBookingDetailsByBookingId(widget.booking.bookingId);
    _account = AccountService().getAccountById(widget.booking.customerId);
  }

  // Responsive utility methods
  bool get isMobile => MediaQuery.of(context).size.width <= 600;
  bool get isTablet => MediaQuery.of(context).size.width > 600 && MediaQuery.of(context).size.width <= 1024;
  bool get isDesktop => MediaQuery.of(context).size.width > 1024;

  double get maxWidth {
    if (isMobile) return double.infinity;
    if (isTablet) return 600;
    return 800;
  }

  EdgeInsets get screenPadding {
    if (isMobile) return const EdgeInsets.all(16);
    if (isTablet) return const EdgeInsets.all(24);
    return const EdgeInsets.all(32);
  }

  double get cardSpacing => isMobile ? 16 : 24;
  double get sectionSpacing => isMobile ? 24 : 32;

  Map<String, dynamic> _getBookingStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'Pending',
          'color': Colors.amber,
          'icon': Icons.schedule_rounded,
          'bgColor': Colors.amber.withOpacity(0.1),
        };
      case 2:
        return {
          'text': 'Confirmed',
          'color': Colors.green,
          'icon': Icons.check_circle_rounded,
          'bgColor': Colors.green.withOpacity(0.1),
        };
      case 3:
        return {
          'text': 'Cancelled',
          'color': Colors.red,
          'icon': Icons.cancel_rounded,
          'bgColor': Colors.red.withOpacity(0.1),
        };
      default:
        return {
          'text': 'Completed',
          'color': Colors.blue,
          'icon': Icons.done_all_rounded,
          'bgColor': Colors.blue.withOpacity(0.1),
        };
    }
  }

  Map<String, dynamic> _getPaymentStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'Unpaid',
          'color': Colors.red,
          'icon': Icons.money_off_rounded,
          'bgColor': Colors.red.withOpacity(0.1),
        };
      case 2:
        return {
          'text': 'Paid',
          'color': Colors.green,
          'icon': Icons.payment_rounded,
          'bgColor': Colors.green.withOpacity(0.1),
        };
      case 3:
        return {
          'text': 'Refunded',
          'color': Colors.purple,
          'icon': Icons.refresh_rounded,
          'bgColor': Colors.purple.withOpacity(0.1),
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline_rounded,
          'bgColor': Colors.grey.withOpacity(0.1),
        };
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy • HH:mm').format(date);
  }

  String _formatVND(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  Widget _buildStatusChip(Map<String, dynamic> statusInfo, {bool isLarge = false}) {
    final horizontalPadding = isLarge ? (isMobile ? 16.0 : 20.0) : (isMobile ? 12.0 : 16.0);
    final verticalPadding = isLarge ? (isMobile ? 10.0 : 12.0) : (isMobile ? 8.0 : 10.0);
    final iconSize = isLarge ? (isMobile ? 20.0 : 22.0) : (isMobile ? 16.0 : 18.0);
    final fontSize = isLarge ? (isMobile ? 14.0 : 16.0) : (isMobile ? 12.0 : 14.0);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: statusInfo['bgColor'],
        borderRadius: BorderRadius.circular(isLarge ? 25 : 20),
        border: Border.all(color: statusInfo['color'], width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo['icon'],
            size: iconSize,
            color: statusInfo['color'],
          ),
          const SizedBox(width: 6),
          Text(
            statusInfo['text'],
            style: TextStyle(
              color: statusInfo['color'],
              fontWeight: FontWeight.w600,
              fontSize: fontSize,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Color? iconColor,
    Widget? trailing,
  }) {
    final iconSize = isMobile ? 20.0 : 24.0;
    final titleFontSize = isMobile ? 12.0 : 14.0;
    final subtitleFontSize = isMobile ? 14.0 : 16.0;

    return Container(
      margin: EdgeInsets.only(bottom: cardSpacing),
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isMobile ? 8 : 10),
            decoration: BoxDecoration(
              color: (iconColor ?? Colors.blue).withOpacity(0.1),
              borderRadius: BorderRadius.circular(isMobile ? 8 : 10),
            ),
            child: Icon(
              icon,
              color: iconColor ?? Colors.blue,
              size: iconSize,
            ),
          ),
          SizedBox(width: isMobile ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: subtitleFontSize,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }

  Widget _buildServiceCard(BookingDetail detail) {
    final imageSize = isMobile ? 80.0 : 100.0;
    final serviceTitleFontSize = isMobile ? 18.0 : 20.0;
    final priceFontSize = isMobile ? 16.0 : 18.0;

    return Container(
      margin: EdgeInsets.only(bottom: cardSpacing),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(isMobile ? 16 : 20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Service header with image and name
          Container(
            padding: EdgeInsets.all(isMobile ? 16 : 20),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                  child: detail.image != null && detail.image!.isNotEmpty
                      ? Image.network(
                          detail.image!,
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildServiceImagePlaceholder(imageSize);
                          },
                        )
                      : _buildServiceImagePlaceholder(imageSize),
                ),
                SizedBox(width: isMobile ? 16 : 20),
                Expanded(
                  child: FutureBuilder<Service>(
                    future: ApiService().getServiceById(detail.serviceId),
                    builder: (context, snapshot) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.hasData 
                                ? snapshot.data!.serviceName 
                                : 'Loading...',
                            style: TextStyle(
                              fontSize: serviceTitleFontSize,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: isMobile ? 8 : 12),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: isMobile ? 12 : 16, 
                              vertical: isMobile ? 6 : 8
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _formatVND(detail.unitPrice),
                              style: TextStyle(
                                fontSize: priceFontSize,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          
          // Service details
          Container(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16 : 20),
            child: Column(
              children: [
                _buildInfoTile(
                  icon: Icons.calendar_today_rounded,
                  title: 'Service Date',
                  subtitle: _formatDate(detail.scheduleDatetime),
                  iconColor: Colors.blue,
                ),
                _buildInfoTile(
                  icon: Icons.inventory_rounded,
                  title: 'Quantity',
                  subtitle: '${detail.quantity} items',
                  iconColor: Colors.orange,
                ),
                
                // Customer info
                FutureBuilder<BaseResponse<Account>>(
                  future: _account,
                  builder: (context, accSnap) {
                    if (accSnap.connectionState != ConnectionState.done) {
                      return Container(
                        padding: EdgeInsets.all(isMobile ? 16 : 20),
                        child: Row(
                          children: [
                            SizedBox(
                              width: isMobile ? 20 : 24,
                              height: isMobile ? 20 : 24,
                              child: const CircularProgressIndicator(strokeWidth: 2),
                            ),
                            SizedBox(width: isMobile ? 12 : 16),
                            const Text('Loading customer info...'),
                          ],
                        ),
                      );
                    }
                    
                    if (accSnap.hasError || accSnap.data?.data == null) {
                      return _buildInfoTile(
                        icon: Icons.person_rounded,
                        title: 'Customer',
                        subtitle: 'Information unavailable',
                        iconColor: Colors.purple,
                      );
                    }
                    
                    final account = accSnap.data!.data!;
                    return Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.person_rounded,
                          title: 'Customer',
                          subtitle: account.fullName,
                          iconColor: Colors.purple,
                        ),
                        _buildInfoTile(
                          icon: Icons.phone_rounded,
                          title: 'Phone Number',
                          subtitle: account.phone,
                          iconColor: Colors.teal,
                        ),
                      ],
                    );
                  },
                ),
                
                _buildInfoTile(
                  icon: Icons.location_on_rounded,
                  title: 'Service Address',
                  subtitle: widget.booking.address ?? 'No address provided',
                  iconColor: Colors.red,
                ),
                
                if (detail.notes != null && detail.notes!.isNotEmpty)
                  _buildInfoTile(
                    icon: Icons.note_rounded,
                    title: 'Special Notes',
                    subtitle: detail.notes!,
                    iconColor: Colors.grey,
                  ),
              ],
            ),
          ),
          
          SizedBox(height: cardSpacing),
        ],
      ),
    );
  }

  Widget _buildServiceImagePlaceholder(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
      ),
      child: Icon(
        Icons.cleaning_services_rounded,
        color: Colors.blue,
        size: size * 0.5,
      ),
    );
  }

  Widget _buildBookingSummaryCard() {
    final bookingStatusInfo = _getBookingStatusInfo(widget.booking.bookingStatusId);
    final paymentStatusInfo = _getPaymentStatusInfo(widget.booking.paymentStatusId);
    final titleFontSize = isMobile ? 20.0 : 24.0;

    return Container(
      margin: screenPadding,
      constraints: BoxConstraints(maxWidth: maxWidth),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 20 : 24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue[50]!,
            Colors.white,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 24 : 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Booking ID',
                        style: TextStyle(
                          fontSize: isMobile ? 12 : 14,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: isMobile ? 6 : 8),
                      Text(
                        widget.booking.bookingNumber,
                        style: TextStyle(
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: isMobile ? 12 : 16),
                      _buildStatusChip(bookingStatusInfo, isLarge: true),
                    ],
                  ),
                ),
              ],
            ),
            
            SizedBox(height: sectionSpacing),
            
            // Booking details - responsive grid for desktop
            if (isDesktop) ...[
              Row(
                children: [
                  Expanded(
                    child: _buildInfoTile(
                      icon: Icons.calendar_today_rounded,
                      title: 'Booking Date',
                      subtitle: widget.booking.bookingDate != null
                          ? _formatDate(widget.booking.bookingDate!)
                          : 'Not specified',
                      iconColor: Colors.blue,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoTile(
                      icon: Icons.alarm_rounded,
                      title: 'Service Deadline',
                      subtitle: _formatDate(widget.booking.deadline),
                      iconColor: Colors.orange,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: _buildInfoTile(
                      icon: Icons.attach_money_rounded,
                      title: 'Total Amount',
                      subtitle: _formatVND(widget.booking.totalAmount),
                      iconColor: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildInfoTile(
                      icon: Icons.payment_rounded,
                      title: 'Payment Status',
                      subtitle: '',
                      iconColor: paymentStatusInfo['color'],
                      trailing: _buildStatusChip(paymentStatusInfo),
                    ),
                  ),
                ],
              ),
            ] else ...[
              // Mobile/Tablet layout - single column
              _buildInfoTile(
                icon: Icons.calendar_today_rounded,
                title: 'Booking Date',
                subtitle: widget.booking.bookingDate != null
                    ? _formatDate(widget.booking.bookingDate!)
                    : 'Not specified',
                iconColor: Colors.blue,
              ),
              
              _buildInfoTile(
                icon: Icons.alarm_rounded,
                title: 'Service Deadline',
                subtitle: _formatDate(widget.booking.deadline),
                iconColor: Colors.orange,
              ),
              
              _buildInfoTile(
                icon: Icons.attach_money_rounded,
                title: 'Total Amount',
                subtitle: _formatVND(widget.booking.totalAmount),
                iconColor: Colors.green,
              ),
              
              _buildInfoTile(
                icon: Icons.payment_rounded,
                title: 'Payment Status',
                subtitle: '',
                iconColor: paymentStatusInfo['color'],
                trailing: _buildStatusChip(paymentStatusInfo),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildServicesSection(List<BookingDetail> details) {
    final sectionTitleFontSize = isMobile ? 20.0 : 24.0;

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.cleaning_services_rounded,
                color: Colors.blue,
                size: isMobile ? 24 : 28,
              ),
              SizedBox(width: isMobile ? 8 : 12),
              Text(
                'Booked Services',
                style: TextStyle(
                  fontSize: sectionTitleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: isMobile ? 20 : 24),
          
          // Services grid for desktop, single column for mobile/tablet
          if (isDesktop && details.length > 1) ...[
            // Desktop grid layout
            for (int i = 0; i < details.length; i += 2) ...[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildServiceCard(details[i])),
                  const SizedBox(width: 24),
                  if (i + 1 < details.length)
                    Expanded(child: _buildServiceCard(details[i + 1]))
                  else
                    const Expanded(child: SizedBox()),
                ],
              ),
            ],
          ] else ...[
            // Single column layout
            ...details.map((detail) => _buildServiceCard(detail)).toList(),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Booking Details',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            fontSize: isMobile ? 18 : 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Booking summary card
              _buildBookingSummaryCard(),
              
              // Services section
              Padding(
                padding: screenPadding,
                child: FutureBuilder<List<BookingDetail>>(
                  future: _bookingDetails,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        constraints: BoxConstraints(maxWidth: maxWidth),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(40),
                            child: Column(
                              children: [
                                CircularProgressIndicator(),
                                SizedBox(height: 16),
                                Text(
                                  'Loading services...',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: isMobile ? 14 : 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          padding: EdgeInsets.all(isMobile ? 24 : 32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.error_outline_rounded,
                                size: isMobile ? 64 : 80,
                                color: Colors.red[300],
                              ),
                              SizedBox(height: isMobile ? 16 : 20),
                              Text(
                                'Something went wrong',
                                style: TextStyle(
                                  color: Colors.red[600],
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isMobile ? 8 : 12),
                              Text(
                                'Please try again later',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isMobile ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Container(
                          constraints: BoxConstraints(maxWidth: maxWidth),
                          padding: EdgeInsets.all(isMobile ? 24 : 32),
                          child: Column(
                            children: [
                              Icon(
                                Icons.inbox_outlined,
                                size: isMobile ? 64 : 80,
                                color: Colors.grey[400],
                              ),
                              SizedBox(height: isMobile ? 16 : 20),
                              Text(
                                'No services found',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: isMobile ? 16 : 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(height: isMobile ? 8 : 12),
                              Text(
                                'This booking has no associated services',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: isMobile ? 14 : 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      return _buildServicesSection(snapshot.data!);
                    }
                  },
                ),
              ),
              
              SizedBox(height: sectionSpacing),
            ],
          ),
        ),
      ),
    );
  }
}