import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'package:hsp_mobile/core/services/catalog_service.dart';
import 'package:hsp_mobile/features/booking/views/booking_summary_screen.dart';
import 'package:hsp_mobile/features/catalog/view/service_detail_screen.dart';
import 'package:intl/intl.dart';

class ServiceScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  const ServiceScreen({
    Key? key,
    required this.categoryId,
    required this.categoryName,
  }) : super(key: key);

  @override
  State<ServiceScreen> createState() => _ServiceScreenState();
}

  String _formatVND(double amount) {
    
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

class _ServiceScreenState extends State<ServiceScreen> {
  late Future<List<Service>> _futureServices;
  final _service = CatalogService();

  @override
  void initState() {
    super.initState();
    _futureServices = _service.getServicesByCategoryId(widget.categoryId);
  }

  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.simpleCurrency(decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: FutureBuilder<List<Service>>(
        future: _futureServices,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snap.hasError) {
            return Center(child: Text('Lỗi: ${snap.error}'));
          }
          final services = snap.data!;
          return ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            itemCount: services.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final svc = services[index];

              // Giả sử bạn có sẵn provider info, ví dụ svc.providerName, svc.providerAvatar
              // Nếu chưa, bạn có thể fetch thêm hoặc tạm dùng placeholder
              final providerName = 'Unknown';
              final providerAvatar = 'https://placehold.co/90/png';

              // Giả sử bạn muốn hiển thị số sao và count reviews:
              final rating =  5.0; // ví dụ trung bình sao
              final reviewCount = 0;

              // Ví dụ giá gốc và giá sale:
              final originalPrice = svc.price * 1.2;
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailScreen(
                        serviceId: svc.serviceId,
                        serviceName: svc.serviceName,
                        serviceImage: svc.image ?? '',
                        price: svc.price,
                        originalPrice: originalPrice,
                        rating: rating,
                        reviewCount: reviewCount,  // dù bỏ review, vẫn dùng nếu bạn còn cần hiển thị count
                        providerName: providerName,
                        providerAvatar: providerAvatar,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Ảnh service
                      ClipRRect(
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                        child: Image.network(
                          svc.image != null
                              ? '${svc.image}'
                              : 'https://placehold.co/180/png',
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            height: 180,
                            color: Colors.grey[200],
                            child: const Icon(Icons.broken_image, size: 60),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Rating + số reviews
                            Row(
                              children: [
                                Icon(Icons.star, size: 16, color: Colors.blue),
                                const SizedBox(width: 4),
                                Text(
                                  rating.toStringAsFixed(1),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text('($reviewCount Reviews)',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                              ],
                            ),
                            const SizedBox(height: 8),

                            // Tên service
                            Text(
                              svc.serviceName,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),

                            // Giá: hiển thị giá sale và giá gốc gạch ngang
                            Row(
                              children: [
                                Text(
                                  _formatVND(svc.price),
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatVND(originalPrice),
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Provider + nút Add
                            Row(
                              children: [
                                // Avatar provider
                                CircleAvatar(
                                  radius: 16,
                                  backgroundImage: providerAvatar.isNotEmpty
                                      ? NetworkImage(providerAvatar)
                                      : null,
                                  child: providerAvatar.isEmpty
                                      ? const Icon(Icons.person)
                                      : null,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    providerName,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BookingSummaryScreen(serviceId: svc.serviceId),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  ),
                                  child: const Text('Add'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
            
              );
              
            },
          );
        },
      ),
    );
  }
}
