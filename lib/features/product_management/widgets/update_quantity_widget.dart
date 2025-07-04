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

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(
          'Add Quantity',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: qtyController,
          style: TextStyle(color: AppColors.textPrimary),
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(hintText: 'Enter quantity'),
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
            },
            child: const Text('Update'),
          ),
        ],
      );
    },
  );
}
