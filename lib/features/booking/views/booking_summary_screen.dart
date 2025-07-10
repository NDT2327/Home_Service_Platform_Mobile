import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
// import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/booking/widgets/address_section.dart';
import 'package:hsp_mobile/features/booking/widgets/booking_success.dart';
import 'package:hsp_mobile/features/booking/widgets/change_address_sheet.dart';
import 'package:hsp_mobile/features/booking/widgets/coupon_section.dart';
import 'package:hsp_mobile/features/booking/widgets/main_service_card.dart';
import 'package:hsp_mobile/features/booking/widgets/price_summary.dart';
import 'package:hsp_mobile/features/booking/widgets/select_slot_button.dart';
import 'package:hsp_mobile/features/booking/widgets/suggested_services_section.dart';
// import 'package:hsp_mobile/core/widgets/index.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingSummaryScreen extends StatefulWidget {
  final int serviceId;
  const BookingSummaryScreen({super.key, required this.serviceId});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final _catalog = CatalogService();
  final _bookingService = BookingService();
  bool _isLoading = true;
  Service? _mainService;
  List<Service> _suggestedServices = [];
  // final String _address = "2118 Thornridge California";
  int _selectedAddressIdx = 0;
  List<AddressItem> _addresses = [
    AddressItem(label: 'Home', detail: '4517 Washington Ave. Manchester, Kentucky 39495'),
    AddressItem(label: 'Work', detail: '2118 Thornridge Cir. Syracuse, Connecticut 35624'),
  ];
  String _couponCode = "";
  final double _discount = 0.0;
  final double _deliveryFee = 0.0;
  int _quantity = 1;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  TimeOfDay? _selectedTime;
  

  @override
  void initState() {
    super.initState();
    _loadServiceData();
  }

  Future<void> _loadServiceData() async {
    try {
      await _fetchServiceData();
      await _fetchSuggestedServices();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading booking data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchServiceData() async {
    try {
      final service = await _catalog.getServiceById(widget.serviceId);
      setState(() {
        _mainService = service;
      });
    } catch (e) {
      print('Error fetching service: $e');
      // Tùy chọn: Xử lý lỗi thêm nếu cần
    }
  }

  Future<void> _fetchSuggestedServices() async {
    try {
      final services = await _catalog.getAllServices();
      setState(() {
        _suggestedServices = services;
      });
    } catch (e) {
      print('Error fetching suggested services: $e');
      // Tùy chọn: Xử lý lỗi thêm nếu cần
    }
  }

  double get _itemTotal {
    return _mainService != null ? _mainService!.price * _quantity : 0.0;
  }

  double get _grandTotal {
    return _itemTotal - _discount + _deliveryFee;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Booking Summary'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Booking Summary',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Service Section
              MainServiceCard(
                service: _mainService!,
                quantity: _quantity,
                onIncrement: () => setState(() => _quantity++),
                onDecrement: () => setState(() {
                  if (_quantity > 1) _quantity--;
                }),
              ),
              
              SizedBox(height: 20),
              
              // Frequently Added Together Section
              // _buildSuggestedServicesSection(),
              SuggestedServicesSection(
                services: _suggestedServices,
                onAdd: _addServiceToBooking,
              ),

              SizedBox(height: 20),
              
              // Coupon Section
              CouponSection(
                showCouponDialog: _showCouponDialog,
              ),
              
              SizedBox(height: 20),
              
              // Price Summary Section
              PriceSummary(
                itemTotal: _itemTotal,
                discount: _discount,
                deliveryFee: _deliveryFee,
                grandTotal: _grandTotal,
              ),
              
              SizedBox(height: 20),
              
              // Address Section
              AddressSection(
                address: _addresses[_selectedAddressIdx].detail,
                onChangePressed: _showChangeAddress,
              ),
              
              SizedBox(height: 20),
              
              // Select Slot Button
              SelectSlotButton(onPressed: _showSlotSelection)
            ],
          ),
        ),
      ),
    );
  }

  void _addServiceToBooking(Service service) {
    // Add logic to add service to booking
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${service.serviceName} added to booking'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCouponDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Apply Coupon'),
        content: TextField(
          onChanged: (value) => _couponCode = value,
          decoration: InputDecoration(
            hintText: 'Enter coupon code',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Apply coupon logic here
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
            ),
            child: Text('Apply'),
          ),
        ],
      ),
    );
  }

  //Select Booking Slot Screen
  Future<void> _showSlotSelection() async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      backgroundColor: Colors.transparent,
      builder: (context) {
        return GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                child: Container(color: Colors.transparent),
              ),

              // → Dùng StatefulBuilder tại đây
              StatefulBuilder(
                builder: (context, setModalState) {
                  return DraggableScrollableSheet(
                    initialChildSize: 0.6,
                    minChildSize: 0.4,
                    maxChildSize: 0.9,
                    builder: (context, scrollCtrl) {
                      return ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Container(
                          color: Colors.white,
                          child: SingleChildScrollView(
                            controller: scrollCtrl,
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // … grab bar, title …

                                // 1) Calendar inline
                                Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.now().add(Duration(days: 60)),
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    // → DÙNG setModalState để rebuild modal
                                    setModalState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                    });
                                  },
                                  calendarStyle: CalendarStyle(
                                    todayDecoration: BoxDecoration(
                                      color: Colors.blue.withOpacity(0.3),
                                      shape: BoxShape.circle,
                                    ),
                                    selectedDecoration: BoxDecoration(
                                      color: Colors.blue,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: false,
                                    titleCentered: true,
                                  ),
                                ),

                                SizedBox(height: 24),

                                // 2) Time picker
                                Text('Select Time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                ListTile(
                                  onTap: () async {
                                    final now = TimeOfDay.now();
                                    final picked = await showTimePicker(
                                      context: context,
                                      initialTime: _selectedTime ?? now,
                                    );
                                    if (picked != null) {
                                      // → DÙNG setModalState để rebuild modal
                                      setModalState(() {
                                        _selectedTime = picked;
                                      });
                                    }
                                  },
                                  leading: Icon(Icons.access_time, color: Colors.blue),
                                  title: Text(
                                    _selectedTime == null
                                      ? 'Choose time'
                                      : _selectedTime!.format(context),
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  trailing: Icon(Icons.keyboard_arrow_down),
                                ),

                                SizedBox(height: 32),

                                // 3) Proceed button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    onPressed: (_selectedDay != null && _selectedTime != null)
                                      ? () async {
                                          // Calculate schedule datetime
                                          final scheduleDatetime = DateTime(
                                            _selectedDay!.year,
                                            _selectedDay!.month,
                                            _selectedDay!.day,
                                            _selectedTime!.hour,
                                            _selectedTime!.minute,
                                          );

                                          // Define parameters for createBookingAsync
                                          const customerId = 1; // Replace with actual customer ID
                                          const bookingStatusId = 1; // Replace with actual status ID
                                          const paymentStatusId = 1; // Replace with actual payment status ID
                                          final deadline = scheduleDatetime.add(Duration(hours: 2)); // Example deadline

                                          try {
                                            final booking = await _bookingService.createBookingAsync(
                                              customerId: customerId,
                                              promotionCode: _couponCode.isNotEmpty ? _couponCode : null,
                                              bookingDate: scheduleDatetime,
                                              deadline: deadline,
                                              totalAmount: _grandTotal,
                                              notes: null, // Optional, can be set from UI if needed
                                              bookingStatusId: bookingStatusId,
                                              paymentStatusId: paymentStatusId,
                                              address: _addresses[_selectedAddressIdx].detail,
                                            );

                                            final bookingDetail = await _bookingService.createBookingDetailAsync(
                                              bookingId: booking.bookingId,
                                              serviceId: _mainService!.serviceId,
                                              scheduleDatetime: scheduleDatetime,
                                              quantity: _quantity,
                                              unitPrice: _grandTotal,
                                            );

                                            // On success, navigate to a confirmation or next screen
                                            Navigator.of(context).pop(); // Close the modal
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => BookingSuccessScreen(booking: booking),
                                              ),
                                            );
                                            // Optionally navigate to a confirmation screen
                                            // Navigator.pushNamed(context, '/booking-confirmation', arguments: {'bookingId': booking.bookingId});
                                          } catch (e) {
                                            Navigator.of(context).pop(); // Close the modal
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Failed to create booking: $e')),
                                            );
                                          }
                                        }
                                      : null,
                                    child: Text('Proceed to Checkout'),
                                    
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),

            ],
          ),
        );
      },
    );
  }

  // Hàm hiển thị address sheet
  Future<void> _showChangeAddress() async{
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ChangeAddressSheet(
        addresses: _addresses,
        selectedIndex: _selectedAddressIdx,
        onSelected: (newIdx) {
          setState(() {
            _selectedAddressIdx = newIdx;
          });
        },
        onAddNew: () {
          // chuyển sang màn thêm địa chỉ
          // Navigator.pushNamed(context, '/add-address');
        },
      ),
    );
  }
}