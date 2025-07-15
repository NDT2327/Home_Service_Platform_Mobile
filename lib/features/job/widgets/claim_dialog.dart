import 'package:flutter/material.dart';

class ClaimDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ClaimDialog({super.key, required this.onConfirm, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Xác nhận nhận công việc'),
      content: const Text('Bạn có chắc chắn muốn nhận công việc này?'),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Hủy'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Xác nhận'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}