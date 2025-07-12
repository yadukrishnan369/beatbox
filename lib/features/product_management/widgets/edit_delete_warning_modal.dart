import 'package:beatbox/core/app_colors.dart';
import 'package:flutter/material.dart';

class EditDeleteWarningDialog extends StatelessWidget {
  final String title;
  final String message;

  const EditDeleteWarningDialog({
    super.key,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(color: AppColors.primary)),
      content: Text(message, style: TextStyle(color: AppColors.textPrimary)),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
      ],
    );
  }
}
