import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/payment_service.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/booking/views/booking_detail_screen.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingCard extends StatelessWidget {
  final Booking booking;
  final VoidCallback? onRefresh;

  const BookingCard({
    Key? key, 
    required this.booking,
    this.onRefresh,
    }) : super(key: key);

  // Map bookingStatusId to status text, icon and colors
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

  // Map paymentStatusId to status text, icon and colors
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
          'text': 'UNKNOWN',
          'color': Colors.grey,
          'icon': Icons.help_outline,
          'bgColor': Colors.grey.withOpacity(0.1),
        };
    }
  }

  // Format date to display
  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  String _formatVND(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  // Build a status chip widget
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

  // Build an information row with icon, label and value
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

  // Handle payment
  Future<void> _handlePayment(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      final userId = await SharedPrefsUtils.getAccountId();
      if (userId == null) {
        //Navigator.pop(context); // Close loading dialog
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not found')),
        );
        return;
      }

      final paymentService = PaymentService();
      final paymentUrl = await paymentService.createPayment(
        bookingId: booking.bookingId,
        userId: userId,
        amount: booking.totalAmount,
        paymentDate: DateTime.now(),
        notes: 'Payment for booking ${booking.bookingNumber}',
      );

      //Navigator.pop(context); // Close loading dialog

      context.pop();
      // Launch payment URL
      if (await canLaunchUrl(Uri.parse(paymentUrl))) {
        await launchUrl(
          Uri.parse(paymentUrl),
          mode: LaunchMode.externalApplication,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not launch payment URL')),
        );
      }
      if (onRefresh != null) onRefresh!();
    } catch (e) {
      context.pop();
      //Navigator.pop(context); // Close loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment failed: $e')),
      );
    }
  }

  // Build Pay Now button
  Widget _buildPayNowButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () => _handlePayment(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.payment, size: 20),
            const SizedBox(width: 8),
            const Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Handle completed booking
  Future<void> _handleCompletedBooking(BuildContext context) async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await BookingService().completeBooking(booking.bookingId);

      //Navigator.pop(context); // Close loading dialog
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking completed successfully')),
      );
      if (onRefresh != null) onRefresh!(); // Refresh bookings if callback provided
    } catch (e) {
      //Navigator.pop(context); // Close loading dialog
      context.pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to complete booking: $e')),
      );
    }
  }


  Widget _buildCompletedButton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                title: const Text('Confirm'),
                content: const Text('Are you sure you want to mark this booking as completed?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      //Navigator.of(dialogContext).pop();
                      context.pop();
                    },
                    child: const Text('Cancel', style: TextStyle(color: Colors.red)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      //Navigator.of(dialogContext).pop();
                      context.pop();
                      _handleCompletedBooking(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    child: const Text('Yes', style: TextStyle(color: Colors.white)),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, size: 20),
            SizedBox(width: 8),
            Text(
              'Confirm booking completed',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingStatusInfo = _getBookingStatusInfo(booking.bookingStatusId);
    final paymentStatusInfo = _getPaymentStatusInfo(booking.paymentStatusId);
    final showPayButton = booking.bookingStatusId == 1 && booking.paymentStatusId == 1;
    final showCompletedButton = booking.bookingStatusId == 2 && booking.paymentStatusId == 2;

    return GestureDetector(
      onTap: () {
        // Navigate to BookingDetail screen
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => BookingDetailScreen(booking: booking),
        //   ),
        // );
                context.push('/booking-detail', extra: booking);

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
                // Header with booking code and status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booking Code',
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

                // Divider line
                Container(
                  height: 1,
                  color: Colors.grey[200],
                ),

                const SizedBox(height: 16),

                // Booking details
                _buildInfoRow(
                  Icons.calendar_today,
                  'Booking Date',
                  _formatDate(booking.bookingDate),
                  iconColor: Colors.blue,
                ),

                _buildInfoRow(
                  Icons.alarm,
                  'Deadline',
                  _formatDate(booking.deadline),
                  iconColor: Colors.orange,
                ),

                _buildInfoRow(
                  Icons.attach_money,
                  'Total Amount',
                  _formatVND(booking.totalAmount),
                  iconColor: Colors.green,
                ),

                if (booking.address != null) ...[
                  const SizedBox(height: 4),
                  _buildInfoRow(
                    Icons.location_on,
                    'Address',
                    booking.address!,
                    iconColor: Colors.red,
                  ),
                ],

                const SizedBox(height: 16),

                // Footer with payment status
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

                // Pay Now button (only show when booking is pending and payment is unpaid)
                if (showPayButton) _buildPayNowButton(context),
                // Completed button (only show when booking is confirmed and payment is paid)
                if (showCompletedButton) _buildCompletedButton(context),
                // Tap instruction
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
                      'Tap to view details',
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