import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GSTAdjustmentDialog extends StatefulWidget {
  const GSTAdjustmentDialog({super.key});

  @override
  State<GSTAdjustmentDialog> createState() => _GSTAdjustmentDialogState();
}

class _GSTAdjustmentDialogState extends State<GSTAdjustmentDialog> {
  late double currentGST;
  late TextEditingController gstController;

  @override
  void initState() {
    super.initState();

    // fetch current GST value from Hive
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
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Add GST %',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Divider(height: 10),
              SizedBox(height: 16.h),
              Text(
                'Set the GST rate to use for all your products. Electronic GST\n(e-GST) is a digital tax applied to electronic goods and\nservices.',
                style: TextStyle(fontSize: 15.sp, color: AppColors.primary),
              ),
              SizedBox(height: 24.h),

              // Text Field
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Current GST',
                      style: TextStyle(color: AppColors.textPrimary),
                    ),
                    Container(
                      width: 150.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: TextField(
                        controller: gstController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          suffixText: '%',
                          suffixStyle: TextStyle(
                            fontSize: 16.sp,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            setState(() {
                              currentGST = double.tryParse(value) ?? 0.0;
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 32.h),

              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        FocusScope.of(context).unfocus();
                        final text = gstController.text.trim();
                        final enteredValue = double.tryParse(text);

                        if (enteredValue == null ||
                            enteredValue < 0 ||
                            enteredValue > 100) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Please enter a valid GST % (0 - 100)",
                              ),
                              backgroundColor: AppColors.error,
                            ),
                          );
                          return;
                        }
                        //save GST into database
                        await GSTUtils.setGSTRate(enteredValue);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.r),
                        ),
                      ),
                      child: Text(
                        'Update',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: AppColors.white,
                        ),
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
