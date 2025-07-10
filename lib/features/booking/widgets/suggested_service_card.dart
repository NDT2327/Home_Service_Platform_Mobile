import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';

class SuggestedServiceCard extends StatelessWidget {
  final Service service;
  final VoidCallback onAdd;

  const SuggestedServiceCard({
    super.key,
    required this.service,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                image: DecorationImage(
                  image: NetworkImage(service.image ?? 'https://placehold.co/180x120/png'),
                  // image: NetworkImage('https://placehold.co/180x120/png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ...List.generate(5, (_) => Icon(Icons.star, color: Colors.amber, size: 14)),
                        SizedBox(width: 4),
                        Text('5.0', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      service.serviceName,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Text('\$${service.price.toStringAsFixed(0)}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: onAdd,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                        child: Text('Add', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}