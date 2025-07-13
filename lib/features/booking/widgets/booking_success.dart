import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/features/booking/views/booking_detail_screen.dart';
import 'package:hsp_mobile/core/services/payment_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingSuccessScreen extends StatefulWidget {
  final Booking booking;
  final int userId;
  

  const BookingSuccessScreen({super.key, required this.booking, required this.userId});

  @override
  State<BookingSuccessScreen> createState() => _BookingSuccessScreenState();
}

class _BookingSuccessScreenState extends State<BookingSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () => _fadeController.forward());
    Future.delayed(const Duration(milliseconds: 500), () => _slideController.forward());
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _handlePayment() async {
    try {
      final paymentService = PaymentService();
      
      // Log để check data trước khi gọi API
      print('Creating payment with:');
      print('BookingId: ${widget.booking.bookingId}');
      print('UserId: ${widget.userId}');
      print('Amount: ${widget.booking.totalAmount}');
      
      final paymentUrl = await paymentService.createPayment(
        bookingId: widget.booking.bookingId,
        userId: widget.userId,
        amount: widget.booking.totalAmount,
        paymentDate: DateTime.now(),
        notes: 'Thanh toán booking #${widget.booking.bookingNumber}',
      );
      
      // Log URL nhận được
      print('Received payment URL: $paymentUrl');
      
      // Validate URL format
      if (paymentUrl.isEmpty) {
        throw 'Payment URL is empty';
      }
      
      // Check if URL is valid
      final uri = Uri.tryParse(paymentUrl);
      if (uri == null) {
        throw 'Invalid URL format: $paymentUrl';
      }
      
      print('Parsed URI: $uri');
      print('URI scheme: ${uri.scheme}');
      print('URI host: ${uri.host}');
      
      // Check if URL can be launched
      final canLaunch = await canLaunchUrl(uri);
      print('Can launch URL: $canLaunch');
      
      if (canLaunch) {
        // Try different launch modes
        try {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          print('Launched with externalApplication mode');
        } catch (e) {
          print('Failed with externalApplication, trying inAppWebView: $e');
          try {
            await launchUrl(uri, mode: LaunchMode.inAppWebView);
            print('Launched with inAppWebView mode');
          } catch (e2) {
            print('Failed with inAppWebView, trying platformDefault: $e2');
            await launchUrl(uri, mode: LaunchMode.platformDefault);
            print('Launched with platformDefault mode');
          }
        }
      } else {
        throw 'Cannot launch URL: $paymentUrl';
      }
      
    } catch (e) {
      print('Payment error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment failed: $e'),
          duration: Duration(seconds: 5),
        ),
      );
    }
  }
    
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF667eea), Color(0xFF764ba2)],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 10)),
                          ],
                        ),
                        child: const Icon(Icons.check_circle, size: 80, color: Color(0xFF4CAF50)),
                      ),
                    ),
                    const SizedBox(height: 40),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: const Text(
                        'Booking Confirmed!',
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Text(
                        'Congratulations! Your booking has been successfully confirmed.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.9), height: 1.5),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: Offset(0, 10))]),
                          child: Column(children: [
                            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                              Icon(Icons.confirmation_number, color: Colors.grey[600], size: 20),
                              const SizedBox(width: 8),
                              Text('Booking', style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500)),
                            ]),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: const Color(0xFF667eea).withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                              child: Text(widget.booking.bookingNumber, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF667eea))),
                            ),
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(color: const Color(0xFF4CAF50).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Row(mainAxisSize: MainAxisSize.min, children: [
                                const Icon(Icons.schedule, color: Color(0xFF4CAF50), size: 16),
                                const SizedBox(width: 6),
                                Text('Your service will be delivered as scheduled', style: TextStyle(fontSize: 12, color: Colors.grey[700], fontWeight: FontWeight.w500)),
                              ]),
                            ),
                          ]),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    SlideTransition(
                      position: _slideAnimation,
                      child: FadeTransition(
                        opacity: _fadeAnimation,
                        child: Column(children: [
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF667eea), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              child: const Text('Back to Home', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => BookingDetailScreen(booking: widget.booking)),
                                );
                              },
                              style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              child: const Text('View Booking Details', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Pay Now Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: _handlePayment,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orangeAccent, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              child: const Text('Pay Now', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                            ),
                          ),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
