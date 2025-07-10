// lib/widgets/main_service_card.dart
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';


class MainServiceCard extends StatelessWidget {
  final Service service;
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const MainServiceCard({
    super.key,
    required this.service,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            _buildImage(),
            SizedBox(width: 16),
            _buildDetails(),
            _buildQuantityControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() => Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          image: DecorationImage(
            image: NetworkImage(service.image ?? 'https://placehold.co/90/png'),
            // image: NetworkImage('https://placehold.co/90/png'),

            fit: BoxFit.cover,
          ),
        ),
      );

  Widget _buildDetails() => Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(service.serviceName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 4),
            Row(children: List.generate(5, (_) => Icon(Icons.star, color: Colors.amber, size: 16))),
            SizedBox(height: 8),
            Text('\$${service.price.toStringAsFixed(0)}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
      );

  Widget _buildQuantityControls() => Column(
        children: [
          IconButton(onPressed: onDecrement, icon: Icon(Icons.remove_circle_outline, color: Colors.grey)),
          Text('$quantity', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          IconButton(onPressed: onIncrement, icon: Icon(Icons.add_circle_outline, color: Colors.blue)),
        ],
      );
}