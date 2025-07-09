import 'package:beatbox/core/app_colors.dart';
import 'package:beatbox/features/product_management/model/product_model.dart';
import 'package:beatbox/utils/limited_stock_utils.dart';
import 'package:beatbox/widgets/Loading_widgets/show_loading_dialog.dart';
import 'package:flutter/material.dart';

void showQuantityPopup({
  required BuildContext context,
  required ProductModel product,
}) {
  final TextEditingController qtyController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Add Quantity',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: qtyController,
            style: TextStyle(color: AppColors.textPrimary),
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: 'Enter quantity'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null;
              }

              if (!RegExp(r'^-?\d+$').hasMatch(value.trim())) {
                return 'Enter valid numbers only';
              }

              final intValue = int.tryParse(value.trim());
              if (intValue == null) {
                return 'Enter valid numbers only';
              }

              if (intValue < 0) {
                return 'Enter positive number only';
              }

              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.error),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              foregroundColor: AppColors.white,
            ),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final addedQty = int.tryParse(qtyController.text);
                if (addedQty != null && addedQty > 0) {
                  product.productQuantity += addedQty;
                  product.initialQuantity =
                      (product.initialQuantity ?? 0) + addedQty;
                  await product.save();
                  Navigator.pop(context);
                  await showLoadingDialog(
                    context,
                    message: "Updating...",
                    showSucess: true,
                  );
                  await LimitedStockUtils.filterLimitedStockProducts();
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
