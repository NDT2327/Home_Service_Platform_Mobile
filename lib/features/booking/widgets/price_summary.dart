import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PriceSummary extends StatelessWidget {
  final double itemTotal;
  final double discount;
  final double deliveryFee;
  final double grandTotal;

  const PriceSummary({
    super.key,
    required this.itemTotal,
    required this.discount,
    required this.deliveryFee,
    required this.grandTotal,
  });

  String _formatVND(double amount) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(amount);
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false, bool isBlue = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isBlue ? Colors.blue : Colors.black87,
            ),
          ),
          Text(
            (label == 'Delivery Fee' && amount == 0)
                ? 'Free'
                : _formatVND(amount.abs()),
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: isBlue ? Colors.blue : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          _buildPriceRow('Item Total', itemTotal),
          _buildPriceRow('Discount', -discount),
          _buildPriceRow('Delivery Fee', deliveryFee, isBlue: true),
          const Divider(thickness: 1),
          _buildPriceRow('Grand Total', grandTotal, isTotal: true),
        ],
      ),
    );
  }
}