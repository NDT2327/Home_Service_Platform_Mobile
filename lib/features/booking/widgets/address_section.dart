import 'package:flutter/material.dart';

class AddressSection extends StatelessWidget {
  final String address;
  final VoidCallback onChangePressed;

  const AddressSection({
    super.key,
    required this.address,
    required this.onChangePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on, color: Colors.blue),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Address',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14)),
                const SizedBox(height: 4),
                Text(address,
                    style:
                        const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          TextButton(
            onPressed: onChangePressed,
            child: const Text('Change',
                style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}
