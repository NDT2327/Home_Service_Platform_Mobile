import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hsp_mobile/core/utils/app_color.dart';
import 'package:hsp_mobile/core/widgets/index.dart';

class OtpDialog extends StatefulWidget {
  final Function(String) onConfirm;

  const OtpDialog({super.key, required this.onConfirm});

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  final TextEditingController _otpController = TextEditingController();

  void _onConfirm() {
    final otp = _otpController.text.trim();
    if (otp.length == 4) {
      widget.onConfirm(otp);
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('signUp.otpInvalid'.tr(), style: const TextStyle(color: Colors.white)),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(
        'signUp.otpTitle'.tr(),
        style: TextStyle(color: AppColors.textPrimary),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'signUp.otpSubtitle'.tr(),
            style: TextStyle(color: AppColors.gray),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            decoration: InputDecoration(
              labelText: 'signUp.otpPlaceholder'.tr(),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              counterText: '',
            ),
          ),
        ],
      ),
      actions: [
        LinkButton(
          text: 'signUp.cancel'.tr(),
          onPressed: () => Navigator.pop(context),
        ),
        CustomButton(
          text: 'signUp.confirm'.tr(),
          onPressed: _onConfirm,
        ),
      ],
    );
  }
}