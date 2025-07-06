import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';
// import 'package:hsp_mobile/core/routes/app_routes.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/features/booking/widgets/address_section.dart';
import 'package:hsp_mobile/features/booking/widgets/change_address_sheet.dart';
import 'package:hsp_mobile/features/booking/widgets/coupon_section.dart';
import 'package:hsp_mobile/features/booking/widgets/main_service_card.dart';
import 'package:hsp_mobile/features/booking/widgets/price_summary.dart';
import 'package:hsp_mobile/features/booking/widgets/select_slot_button.dart';
import 'package:hsp_mobile/features/booking/widgets/suggested_services_section.dart';
// import 'package:hsp_mobile/core/widgets/index.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingSummaryScreen extends StatefulWidget {
  final int serviceId;
  const BookingSummaryScreen({super.key, required this.serviceId});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
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
    //Thay đổi API để lấy dữ liệu dịch vụ chính
    final response = await http.get(
      Uri.parse('https://686950f92af1d945cea192b5.mockapi.io/services/${widget.serviceId}'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _mainService = Service.fromMap(data);
      });
    }
  }

  Future<void> _fetchSuggestedServices() async {
    final response = await http.get(
      Uri.parse('https://686950f92af1d945cea192b5.mockapi.io/services'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _suggestedServices = data.map((item) => Service.fromMap(item)).toList();
      });
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

  // Widget _buildMainServiceCard() {
  //   if (_mainService == null) return SizedBox();    
  //   return Card(
  //     elevation: 2,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //     child: Padding(
  //       padding: EdgeInsets.all(16),
  //       child: Row(
  //         children: [
  //           Container(
  //             width: 90,
  //             height:90,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(8),
  //               image: DecorationImage(
  //                 image: NetworkImage('https://placehold.co/90/png'),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),
  //           SizedBox(width: 16),
  //           Expanded(
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   _mainService!.serviceName,
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 SizedBox(height: 4),
  //                 Row(
  //                   children: [
  //                     Row(
  //                       children: List.generate(5, (index) => Icon(
  //                         Icons.star,
  //                         color: Colors.amber,
  //                         size: 16,
  //                       )),
  //                     ),
  //                     SizedBox(width: 4),
  //                     Text('(5.0)', style: TextStyle(color: Colors.grey)),
  //                   ],
  //                 ),
  //                 SizedBox(height: 8),
  //                 Text(
  //                   '\$${_mainService!.price.toStringAsFixed(0)}',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                     color: Colors.blue,
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //           Column(
  //             children: [
  //               IconButton(
  //                 onPressed: () {
  //                   if (_quantity > 1) {
  //                     setState(() {
  //                       _quantity--;
  //                     });
  //                   }
  //                 },
  //                 icon: Icon(Icons.remove_circle_outline, color: Colors.grey),
  //               ),
  //               Text('$_quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
  //               IconButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _quantity++;
  //                   });
  //                 },
  //                 icon: Icon(Icons.add_circle_outline, color: Colors.blue),
  //               ),
  //             ],
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  // Widget _buildSuggestedServicesSection() {
  //   if (_suggestedServices.isEmpty) return SizedBox(); 
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         'Frequently Added Together',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.black87,
  //         ),
  //       ),
  //       SizedBox(height: 16),
  //       Container(
  //         height: 280,
  //         child: ListView.separated(
  //           scrollDirection: Axis.horizontal,
  //           physics: BouncingScrollPhysics(),
  //           padding: EdgeInsets.only(left: 4, right: 4),
  //           itemCount: _suggestedServices.length,
  //           separatorBuilder: (context, index) => SizedBox(width: 12),
  //           itemBuilder: (context, index) {
  //             final service = _suggestedServices[index];
  //             return _buildSuggestedServiceCard(service);
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildSuggestedServiceCard(Service service) {
  //   return Container(
  //     width: 180,
  //     child: Card(
  //       elevation: 3,
  //       shape: RoundedRectangleBorder(
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           // Image container
  //           Container(
  //             height: 120,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
  //               image: DecorationImage(
  //                 image: NetworkImage('https://placehold.co/180x120/png'),
  //                 fit: BoxFit.cover,
  //               ),
  //             ),
  //           ),        
  //           // Content
  //           Expanded(
  //             child: Padding(
  //               padding: EdgeInsets.all(12),
  //               child: Column(
  //                 crossAxisAlignment: CrossAxisAlignment.start,
  //                 children: [
  //                   // Rating
  //                   Row(
  //                     children: [
  //                       ...List.generate(5, (index) => Icon(
  //                         Icons.star,
  //                         color: Colors.amber,
  //                         size: 14,
  //                       )),
  //                       SizedBox(width: 4),
  //                       Text('5.0', style: TextStyle(
  //                         fontSize: 12,
  //                         color: Colors.grey[600],
  //                       )),
  //                     ],
  //                   ),                 
  //                   SizedBox(height: 8),              
  //                   // Service name
  //                   Text(
  //                     service.serviceName,
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       fontWeight: FontWeight.w600,
  //                       color: Colors.black87,
  //                     ),
  //                     maxLines: 2,
  //                     overflow: TextOverflow.ellipsis,
  //                   ),              
  //                   SizedBox(height: 8),             
  //                   // Price
  //                   Text(
  //                     '\$${service.price.toStringAsFixed(0)}',
  //                     style: TextStyle(
  //                       fontSize: 16,
  //                       fontWeight: FontWeight.bold,
  //                       color: Colors.blue,
  //                     ),
  //                   ),                
  //                   Spacer(),              
  //                   // Add button
  //                   SizedBox(
  //                     width: double.infinity,
  //                     height: 36,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         // Add service to booking
  //                         _addServiceToBooking(service);
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: Colors.blue,
  //                         foregroundColor: Colors.white,
  //                         shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(8),
  //                         ),
  //                         elevation: 2,
  //                       ),
  //                       child: Text(
  //                         'Add',
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  void _addServiceToBooking(Service service) {
    // Add logic to add service to booking
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${service.serviceName} added to booking'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Widget _buildCouponSection() {
  //   return InkWell(
  //     onTap: () {
  //       _showCouponDialog();
  //     },
  //     child: Container(
  //       padding: EdgeInsets.all(16),
  //       decoration: BoxDecoration(
  //         border: Border.all(color: Colors.grey.shade300),
  //         borderRadius: BorderRadius.circular(12),
  //       ),
  //       child: Row(
  //         children: [
  //           Icon(Icons.local_offer, color: Colors.blue),
  //           SizedBox(width: 12),
  //           Text(
  //             'Apply Coupon',
  //             style: TextStyle(
  //               fontSize: 16,
  //               color: Colors.blue,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //           Spacer(),
  //           Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
  //         ],
  //       ),
  //     ),
  //   );
  // }

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

  // Widget _buildPriceSummary() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.grey[50],
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Column(
  //       children: [
  //         _buildPriceRow('Item Total', _itemTotal),
  //         _buildPriceRow('Discount', -_discount),
  //         _buildPriceRow('Delivery Fee', _deliveryFee, isBlue: true),
  //         Divider(thickness: 1),
  //         _buildPriceRow('Grand Total', _grandTotal, isTotal: true),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isBlue = false}) {
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 6),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Text(
  //           label,
  //           style: TextStyle(
  //             fontSize: isTotal ? 18 : 16,
  //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //             color: isBlue ? Colors.blue : Colors.black87,
  //           ),
  //         ),
  //         Text(
  //           (label == 'Delivery Fee' && amount == 0)
  //               ? 'Free'
  //               : '\$${amount.abs().toStringAsFixed(0)}',
  //           style: TextStyle(
  //             fontSize: isTotal ? 18 : 16,
  //             fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
  //             color: isBlue ? Colors.blue : (isTotal ? Colors.black87 : Colors.black87),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildAddressSection() {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       border: Border.all(color: Colors.grey.shade300),
  //       borderRadius: BorderRadius.circular(12),
  //     ),
  //     child: Row(
  //       children: [
  //         Icon(Icons.location_on, color: Colors.blue),
  //         SizedBox(width: 12),
  //         Expanded(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Text(
  //                 'Address',
  //                 style: TextStyle(
  //                   color: Colors.grey[600],
  //                   fontSize: 14,
  //                 ),
  //               ),
  //               SizedBox(height: 4),
  //               Text(
  //                 _address,
  //                 style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         TextButton(
  //           onPressed: () {
  //             // Change address logic
  //           },
  //           child: Text(
  //             'Change',
  //             style: TextStyle(
  //               color: Colors.blue,
  //               fontWeight: FontWeight.w500,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSelectSlotButton() {
  //   return Container(
  //     width: double.infinity,
  //     height: 54,
  //     child: ElevatedButton(
  //       onPressed: () {
  //         _createBooking();
  //       },
  //       style: ElevatedButton.styleFrom(
  //         backgroundColor: Colors.blue,
  //         foregroundColor: Colors.white,
  //         shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(12),
  //         ),
  //         elevation: 2,
  //       ),
  //       child: Text(
  //         'Select Slot',
  //         style: TextStyle(
  //           fontSize: 18,
  //           fontWeight: FontWeight.w600,
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // Future<void> _createBooking() async {
  //   try {
  //     final response = await http.post(
  //       Uri.parse('https://your-api.com/bookings'),
  //       headers: {'Content-Type': 'application/json'},
  //       body: json.encode({
  //         'serviceId': widget.serviceId,
  //         'quantity': _quantity,
  //         'totalAmount': _grandTotal,
  //         'promotionCode': _couponCode.isNotEmpty ? _couponCode : null,
  //         'address': _address,
  //       }),
  //     );
  //     if (response.statusCode == 201) {
  //       final data = json.decode(response.body);
  //       Navigator.pushNamed(
  //         context,
  //         '/slot-selection',
  //         arguments: {'bookingId': data['bookingId']},
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Failed to create booking')),
  //     );
  //   }
  // }

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
                                      ? () {
                                          Navigator.of(context).pop();
                                          // … tiếp tục xử lý checkout …
                                          if (_selectedDay != null && _selectedTime != null) {
                                            // Chuyển đổi ngày và giờ đã chọn thành DateTime
                                            final scheduleDatetime = DateTime(
                                              _selectedDay!.year,
                                              _selectedDay!.month,
                                              _selectedDay!.day,
                                              _selectedTime!.hour,
                                              _selectedTime!.minute,
                                            );
                                            debugPrint('Selected Date: $_selectedDay, Time: $_selectedTime, scheduleDatetime: $scheduleDatetime');
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