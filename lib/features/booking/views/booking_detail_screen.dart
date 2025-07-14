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

  Map<String, dynamic> _getBookingStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'Pending',
          'color': Colors.orange,
          'icon': Icons.schedule,
        };
      case 2:
        return {
          'text': 'Confirmed',
          'color': Colors.green,
          'icon': Icons.check_circle,
        };
      case 3:
        return {
          'text': 'Cancelled',
          'color': Colors.red,
          'icon': Icons.cancel,
        };
      default:
        return {
          'text': 'Completed',
          'color': Colors.blue,
          'icon': Icons.done_all,
        };
    }
  }

  Map<String, dynamic> _getPaymentStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'Unpaid',
          'color': Colors.red,
          'icon': Icons.money_off,
        };
      case 2:
        return {
          'text': 'Paid',
          'color': Colors.green,
          'icon': Icons.payment,
        };
      case 3:
        return {
          'text': 'Refunded',
          'color': Colors.purple,
          'icon': Icons.refresh,
        };
      default:
        return {
          'text': 'Unknown',
          'color': Colors.grey,
          'icon': Icons.help_outline,
        };
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _formatVND(double amount) {
    
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  Widget _buildStatusChip(Map<String, dynamic> statusInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo['color'].withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusInfo['color'], width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusInfo['icon'],
            size: 16,
            color: statusInfo['color'],
          ),
          const SizedBox(width: 4),
          Text(
            statusInfo['text'],
            style: TextStyle(
              color: statusInfo['color'],
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(BookingDetail detail) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Service header
            Row(
              children: [
                if (detail.image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      detail.image!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.cleaning_services,
                            color: Colors.grey[600],
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: FutureBuilder<Service>(
                    future: ApiService().getServiceById(detail.serviceId),
                    builder: (context, snapshot) {
                      String titleText;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        titleText = 'Loading...';
                      } else if (snapshot.hasError) {
                        titleText = 'Unknown';
                      } else {
                        titleText = snapshot.data!.serviceName;
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            titleText,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _formatVND(detail.unitPrice),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Service details
            _buildInfoRow(
              Icons.calendar_today,
              'Service Date',
              _formatDate(detail.scheduleDatetime),
              iconColor: Colors.blue,
            ),
            _buildInfoRow(
              Icons.format_list_numbered,
              'Quantity',
              '${detail.quantity}',
              iconColor: Colors.orange,
            ),
            _buildInfoRow(
              Icons.attach_money,
              'Unit Price',
              _formatVND(detail.unitPrice),
              iconColor: Colors.green,
            ),
            FutureBuilder<BaseResponse<Account>>(
              future: _account,
              builder: (context, accSnap) {
                if (accSnap.connectionState != ConnectionState.done) {
                  return Row(
                    children: [
                      SizedBox(width: 20),
                      CircularProgressIndicator(strokeWidth: 2),
                      SizedBox(width: 8),
                      Text('Loading customer…'),
                    ],
                  );
                }
                if (accSnap.hasError || accSnap.data == null || accSnap.data!.data == null) {
                  return Column(
                    children: [
                      _buildInfoRow(
                        Icons.person,
                        'Customer',
                        'Unknown',
                        iconColor: Colors.purple,
                      ),
                      _buildInfoRow(
                        Icons.phone,
                        'Phone Number',
                        '—',
                        iconColor: Colors.teal,
                      ),
                    ],
                  );
                }
                final account = accSnap.data!.data!;
                return Column(
                  children: [
                    _buildInfoRow(
                      Icons.person,
                      'Customer',
                      account.fullName,
                      iconColor: Colors.purple,
                    ),
                    _buildInfoRow(
                      Icons.phone,
                      'Phone Number',
                      account.phone,
                      iconColor: Colors.teal,
                    ),
                  ],
                );
              },
            ),
            _buildInfoRow(
              Icons.location_on,
              'Address',
              widget.booking.address ?? 'No address provided',
              iconColor: Colors.red,
            ),
            if (detail.notes != null && detail.notes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                Icons.note,
                'Notes',
                widget.booking.notes!,
                iconColor: Colors.grey,
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingStatusInfo = _getBookingStatusInfo(widget.booking.bookingStatusId);
    final paymentStatusInfo = _getPaymentStatusInfo(widget.booking.paymentStatusId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Booking summary card
          Card(
            margin: const EdgeInsets.all(16),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.blue[50]!,
                    Colors.white,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booking ID',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.booking.bookingNumber,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        _buildStatusChip(bookingStatusInfo),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Booking info
                    _buildInfoRow(
                      Icons.calendar_today,
                      'Booking Date',
                      widget.booking.bookingDate != null
                          ? _formatDate(widget.booking.bookingDate!)
                          : 'N/A',
                      iconColor: Colors.blue,
                    ),
                    _buildInfoRow(
                      Icons.alarm,
                      'Deadline',
                      _formatDate(widget.booking.deadline),
                      iconColor: Colors.orange,
                    ),
                    _buildInfoRow(
                      Icons.attach_money,
                      'Total Amount',
                      _formatVND(widget.booking.totalAmount),
                      iconColor: Colors.green,
                    ),
                    if (widget.booking.address != null) ...[
                      _buildInfoRow(
                        Icons.location_on,
                        'Address',
                        widget.booking.address!,
                        iconColor: Colors.red,
                      ),
                    ],
                    const SizedBox(height: 16),
                    // Payment status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Payment Status',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        _buildStatusChip(paymentStatusInfo),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Services section
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Booked Services',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Services list
                  Expanded(
                    child: FutureBuilder<List<BookingDetail>>(
                      future: _bookingDetails,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red[300],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Error: ${snapshot.error}',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.inbox_outlined,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No services found',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else {
                          return ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              final detail = snapshot.data![index];
                              return _buildServiceCard(detail);
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}