import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/models/service.dart';
import 'suggested_service_card.dart';

class SuggestedServicesSection extends StatelessWidget {
  final List<Service> services;
  final Function(Service) onAdd;

  const SuggestedServicesSection({super.key, required this.services, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Frequently Added Together', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 16),
        SizedBox(
          height: 280,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: services.length,
            separatorBuilder: (_, __) => SizedBox(width: 12),
            itemBuilder: (_, idx) => SuggestedServiceCard(
              service: services[idx],
              onAdd: () => onAdd(services[idx]),
            ),
          ),
        ),
      ],
    );
  }
}
