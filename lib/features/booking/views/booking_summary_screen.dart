import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/models/account.dart';
import 'package:hsp_mobile/core/services/booking_service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/core/services/account_service.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/utils/shared_prefs_utils.dart';
import 'package:hsp_mobile/features/booking/widgets/add_address.dart';
import 'package:hsp_mobile/features/booking/widgets/address_section.dart';
import 'package:hsp_mobile/features/booking/widgets/booking_success.dart';
import 'package:hsp_mobile/features/booking/widgets/change_address_sheet.dart';
import 'package:hsp_mobile/features/booking/widgets/coupon_section.dart';
import 'package:hsp_mobile/features/booking/widgets/main_service_card.dart';
import 'package:hsp_mobile/features/booking/widgets/price_summary.dart';
import 'package:hsp_mobile/features/booking/widgets/select_slot_button.dart';
import 'package:hsp_mobile/features/booking/widgets/suggested_services_section.dart';
// import 'package:hsp_mobile/features/booking/screens/add_address_screen.dart';
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
  final _accountService = AccountService();
  
  bool _isLoading = true;
  Service? _mainService;
  List<Service> _suggestedServices = [];
  Account? _userAccount;
  
  int _selectedAddressIdx = 0;
  List<AddressItem> _addresses = [];
  
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
      await _fetchUserAccount();
      _setupAddresses();
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
    }
  }

  Future<void> _fetchUserAccount() async {
    try {
      final userId = await SharedPrefsUtils.getAccountId();
      if (userId != null) {
        final response = await _accountService.getAccountById(userId);
        if (response.statusCode == 200 && response.data != null) {
          setState(() {
            _userAccount = response.data;
          });
        }
      }
    } catch (e) {
      print('Error fetching user account: $e');
    }
  }

  void _setupAddresses() {
    _addresses = [
      // Địa chỉ Home từ user account
      if (_userAccount != null && _userAccount!.address.isNotEmpty)
        AddressItem(label: 'Home', detail: _userAccount!.address),
      
      // Địa chỉ work mặc định (có thể thay thế bằng logic khác)
      AddressItem(label: 'Work', detail: '2118 Thornridge Cir. Syracuse, Connecticut 35624'),
    ];
    
    // Nếu không có địa chỉ nào, thêm địa chỉ mặc định
    if (_addresses.isEmpty) {
      _addresses.add(
        AddressItem(label: 'Default', detail: 'Please add your address'),
      );
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
                address: _addresses.isNotEmpty ? _addresses[_selectedAddressIdx].detail : 'No address available',
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
                                // Calendar section
                                Text('Select Date', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                SizedBox(height: 8),
                                TableCalendar(
                                  firstDay: DateTime.now(),
                                  lastDay: DateTime.now().add(Duration(days: 60)),
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  onDaySelected: (selectedDay, focusedDay) {
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

                                // Time picker
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

                                // Proceed button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: StatefulBuilder(
                                    builder: (BuildContext context, StateSetter setButtonState) {
                                      bool _isBookingLoading = false;

                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: (_selectedDay != null && _selectedTime != null && !_isBookingLoading)
                                            ? () async {
                                                setButtonState(() {
                                                  _isBookingLoading = true;
                                                });

                                                final scheduleDatetime = DateTime(
                                                  _selectedDay!.year,
                                                  _selectedDay!.month,
                                                  _selectedDay!.day,
                                                  _selectedTime!.hour,
                                                  _selectedTime!.minute,
                                                );

                                                final userId = await SharedPrefsUtils.getAccountId();
                                                const bookingStatusId = 1;
                                                const paymentStatusId = 1;
                                                final deadline = scheduleDatetime.add(Duration(hours: 4));

                                                try {
                                                  final booking = await _bookingService.createBookingAsync(
                                                    customerId: userId!,
                                                    promotionCode: _couponCode.isNotEmpty ? _couponCode : null,
                                                    bookingDate: scheduleDatetime,
                                                    deadline: deadline,
                                                    totalAmount: _grandTotal,
                                                    notes: null,
                                                    bookingStatusId: bookingStatusId,
                                                    paymentStatusId: paymentStatusId,
                                                    address: _addresses[_selectedAddressIdx].detail,
                                                  );

                                                  await _bookingService.createBookingDetailAsync(
                                                    bookingId: booking.bookingId,
                                                    serviceId: _mainService!.serviceId,
                                                    scheduleDatetime: scheduleDatetime,
                                                    quantity: _quantity,
                                                    unitPrice: _grandTotal,
                                                  );

                                                  Navigator.of(context).pop();
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) => BookingSuccessScreen(booking: booking),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  Navigator.of(context).pop();
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(content: Text('Failed to create booking: $e')),
                                                  );
                                                } finally {
                                                  setButtonState(() {
                                                    _isBookingLoading = false;
                                                  });
                                                }
                                              }
                                            : null,
                                        child: _isBookingLoading
                                            ? CircularProgressIndicator(
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              )
                                            : Text('Proceed to Checkout'),
                                      );
                                    },
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

  Future<void> _showChangeAddress() async {
    if (_addresses.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add an address first')),
      );
      return;
    }

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
          Navigator.of(context).pop(); // Close bottom sheet first
          _navigateToAddAddress();
        },
      ),
    );
  }

  Future<void> _navigateToAddAddress() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressScreen(
          onAddressAdded: (newAddress) {
            setState(() {
              _addresses.add(newAddress);
              // Set as selected if it's marked as default
              if (newAddress.isDefault) {
                _selectedAddressIdx = _addresses.length - 1;
              }
            });
          },
        ),
      ),
    );
  }
}