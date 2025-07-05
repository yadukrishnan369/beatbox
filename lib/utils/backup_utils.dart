import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/pdf_invoice_generator.dart';
import 'package:beatbox/widgets/Loading_widgets/backup_data_loading_widget.dart';

class BackupUtils {
  static Future<void> generateAllSalesBackup(BuildContext context) async {
    try {
      // Showing loading widget in background
      showBackupLoadingDialog(context);

      // fetch sales data
      final salesBox = Hive.box<SalesModel>('salesBox');
      final allSales = salesBox.values.toList();

      if (allSales.isEmpty) {
        Navigator.pop(context); // close loading
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No sales found to backup !"),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // create folder in Download
      final Directory baseDir = Directory('/storage/emulated/0/Download');
      final exportFolder = Directory('${baseDir.path}/BeatBoxxExports');
      if (!await exportFolder.exists()) {
        await exportFolder.create(recursive: true);
      }

      // generate PDF for each sale
      int index = 1;
      for (final sale in allSales) {
        final filePath =
            '${exportFolder.path}/Invoice_${sale.invoiceNumber}_$index.pdf';
        await generateInvoicePdf(sale, savePath: filePath);
        index++;
      }
      // close the loading dialog
      Navigator.pop(context);

      // success dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder:
            (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: Colors.white,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 40,
                  ),
                  SizedBox(height: 12),
                  Text(
                    "Backup Completed !",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Files saved in Download !",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
      );

      // close success dialog
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });

      //close backup screen
      Future.delayed(Duration(seconds: 3), () {
        Navigator.of(context).pop();
      });
    } catch (e) {
      // backup failed message
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Backup failed! Please try again."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
