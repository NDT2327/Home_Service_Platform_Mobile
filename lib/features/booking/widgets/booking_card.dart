import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/features/booking/views/booking_detail_screen.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;

  const BookingCard({Key? key, required this.booking}) : super(key: key);

  // Ánh xạ bookingStatusId thành chuỗi và màu sắc
  Map<String, dynamic> _getBookingStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'PENDING',
          'color': Colors.orange,
          'icon': Icons.schedule,
          'bgColor': Colors.orange.withOpacity(0.1),
        };
      case 2:
        return {
          'text': 'CONFIRMED',
          'color': Colors.green,
          'icon': Icons.check_circle,
          'bgColor': Colors.green.withOpacity(0.1),
        };
      case 3:
        return {
          'text': 'CANCELLED',
          'color': Colors.red,
          'icon': Icons.cancel,
          'bgColor': Colors.red.withOpacity(0.1),
        };
      default:
        return {
          'text': 'COMPLETED',
          'color': Colors.blue,
          'icon': Icons.done_all,
          'bgColor': Colors.blue.withOpacity(0.1),
        };
    }
  }

  // Ánh xạ paymentStatusId thành chuỗi và màu sắc
  Map<String, dynamic> _getPaymentStatusInfo(int statusId) {
    switch (statusId) {
      case 1:
        return {
          'text': 'UNPAID',
          'color': Colors.red,
          'icon': Icons.money_off,
          'bgColor': Colors.red.withOpacity(0.1),
        };
      case 2:
        return {
          'text': 'PAID',
          'color': Colors.green,
          'icon': Icons.payment,
          'bgColor': Colors.green.withOpacity(0.1),
        };
      case 3:
        return {
          'text': 'REFUNDED',
          'color': Colors.purple,
          'icon': Icons.refresh,
          'bgColor': Colors.purple.withOpacity(0.1),
        };
      default:
        return {
          'text': 'Không xác định',
          'color': Colors.grey,
          'icon': Icons.help_outline,
          'bgColor': Colors.grey.withOpacity(0.1),
        };
    }
  }

  // Định dạng ngày tháng
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  // Widget tạo status chip
  Widget _buildStatusChip(Map<String, dynamic> statusInfo) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: statusInfo['bgColor'],
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

  // Widget tạo info row
  Widget _buildInfoRow(IconData icon, String label, String value, {Color? iconColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
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

  @override
  Widget build(BuildContext context) {
    final bookingStatusInfo = _getBookingStatusInfo(booking.bookingStatusId);
    final paymentStatusInfo = _getPaymentStatusInfo(booking.paymentStatusId);

    return GestureDetector(
      onTap: () {
        // Navigate to BookingDetail screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetailScreen(booking: booking),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
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
                Colors.white,
                Colors.grey[50]!,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header với mã đặt lịch và status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mã đặt lịch',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking.bookingNumber,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildStatusChip(bookingStatusInfo),
                  ],
                ),
                
                const SizedBox(height: 20),
                
                // Divider
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),
                
                const SizedBox(height: 16),
                
                // Thông tin chi tiết
                _buildInfoRow(
                  Icons.calendar_today,
                  'Ngày đặt',
                  _formatDate(booking.bookingDate),
                  iconColor: Colors.blue,
                ),
                
                _buildInfoRow(
                  Icons.alarm,
                  'Hạn chót',
                  _formatDate(booking.deadline),
                  iconColor: Colors.orange,
                ),
                
                _buildInfoRow(
                  Icons.attach_money,
                  'Tổng tiền',
                  '\$${booking.totalAmount.toStringAsFixed(2)}',
                  iconColor: Colors.green,
                ),
                
                if (booking.address != null) ...[
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    Icons.location_on,
                    'Địa chỉ',
                    booking.address!,
                    iconColor: Colors.red,
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Footer với payment status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Trạng thái thanh toán',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    _buildStatusChip(paymentStatusInfo),
                  ],
                ),
                
                // Tap indicator
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.touch_app,
                      size: 16,
                      color: Colors.grey[500],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Nhấn để xem chi tiết',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}