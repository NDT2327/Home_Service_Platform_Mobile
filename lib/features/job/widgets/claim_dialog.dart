import 'package:flutter/material.dart';

class ClaimDialog extends StatelessWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ClaimDialog({super.key, required this.onConfirm, this.onCancel});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm Task Claim'),
      content: const Text('Are you sure you want to claim this task?'),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          child: const Text('Confirm'),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
