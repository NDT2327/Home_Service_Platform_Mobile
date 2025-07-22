import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/booking.dart';
import 'package:hsp_mobile/core/services/api_service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/booking/widgets/booking_card.dart';

class MainListBooking extends StatefulWidget {
  const MainListBooking({Key? key}) : super(key: key);

  @override
  _MainListBookingState createState() => _MainListBookingState();
}

class _MainListBookingState extends State<MainListBooking> {
  late Future<List<Booking>> _bookings;

  @override
  void initState() {
    super.initState();
    // Gọi API để lấy danh sách bookings
    _bookings = _fetchBookings();
  }

  Future<List<Booking>> _fetchBookings() async {
    final int? userId = await SharedPrefsUtils.getAccountId();
    if (userId == null) {
      return [];
    }
    return BookingService().getBookingsForUser(userId);
  }

  // Hàm để refresh danh sách bookings
  void _refreshBookings() {
    setState(() {
      _bookings = _fetchBookings();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Booking>>(
        future: _bookings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Booking'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final booking = snapshot.data![index];
                return BookingCard(
                  booking: booking,
                  onRefresh: _refreshBookings, // Callback to refresh bookings
                );
              },
            );
          }
        },
      ),
    );
  }
}