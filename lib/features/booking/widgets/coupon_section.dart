
import 'package:flutter/material.dart';

class CouponSection extends StatelessWidget {
  final VoidCallback showCouponDialog;
  const CouponSection({super.key, required this.showCouponDialog});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCouponDialog();
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(Icons.local_offer, color: Colors.blue),
            SizedBox(width: 12),
            Text(
              'Apply Coupon',
              style: TextStyle(
                fontSize: 16,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
            Spacer(),
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}