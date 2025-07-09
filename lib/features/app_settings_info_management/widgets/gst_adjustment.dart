import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class GSTAdjustmentDialog extends StatefulWidget {
  const GSTAdjustmentDialog({super.key});

  @override
  State<GSTAdjustmentDialog> createState() => _GSTAdjustmentDialogState();
}

class _GSTAdjustmentDialogState extends State<GSTAdjustmentDialog> {
  late double currentGST;
  late TextEditingController gstController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    currentGST = GSTUtils.getGSTPercentage();
    gstController = TextEditingController(text: currentGST.toStringAsFixed(1));
  }

  @override
  void dispose() {
    gstController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: kIsWeb ? 320 : null,
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Add GST %',
                style: TextStyle(
                  fontSize: kIsWeb ? 18 : 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Set GST rate for your products below.\n  Set the GST rate to use for all your products. Electronic GST\n(e-GST) is a digital tax applied to electronic goods and\nservices.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 25),

              // textformField with validation
              TextFormField(
                controller: gstController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: 'GST %',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  final gst = double.tryParse(value ?? '');
                  if (value == null || value.trim().isEmpty) {
                    return 'GST is required';
                  } else if (gst == null || gst < 0 || gst > 100) {
                    return 'Enter valid GST between 0 - 100';
                  } else if (value.trim().startsWith('-')) {
                    return 'GST cannot be negative';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final value = double.parse(gstController.text.trim());

                          await GSTUtils.setGSTRate(value);
                          await showLoadingDialog(
                            context,
                            message: "Updating...",
                            showSucess: true,
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
