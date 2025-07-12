import 'dart:io' as io;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:beatbox/utils/gst_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:universal_html/html.dart' as html;

Future<void> generateInvoicePdf(
  SalesModel bill, {
  String? savePath,
  bool shouldOpen = true,
}) async {
  final pdf = pw.Document();

  // app logo fetch
  final logoData = await rootBundle.load('assets/images/app_logo.jpg');
  final logoImage = pw.MemoryImage(logoData.buffer.asUint8List());
  final gstPercentage = GSTUtils.getGSTPercentage();

  // pdf design and contents
  pdf.addPage(
    pw.Page(
      build:
          (context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // header section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Row(
                    children: [
                      pw.Image(logoImage, width: 40, height: 40),
                      pw.SizedBox(width: 10),
                      pw.Text(
                        'BEATBOXX',
                        style: pw.TextStyle(
                          fontSize: 24,
                          fontWeight: pw.FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('Customer: ${bill.customerName}'),
                      pw.Text('Phone: ${bill.customerPhone}'),
                      pw.Text('Email: ${bill.customerEmail}'),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Text('INVOICE', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 8),
              pw.Text('Invoice No: ${bill.invoiceNumber}'),
              pw.Text(
                'Date: ${DateFormat('dd MMM yyyy').format(bill.billingDate)}',
              ),
              pw.Text('Order No: ${bill.orderNumber}'),
              pw.SizedBox(height: 16),

              // table section
              pw.Table(
                border: pw.TableBorder.all(width: 0.5),
                columnWidths: {
                  0: pw.FlexColumnWidth(4),
                  1: pw.FlexColumnWidth(2),
                  2: pw.FlexColumnWidth(3),
                  3: pw.FlexColumnWidth(3),
                },
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Item',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Qty',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Rate',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                      pw.Padding(
                        padding: pw.EdgeInsets.all(6),
                        child: pw.Text(
                          'Total',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...bill.cartItems.map(
                    (item) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(item.product.productName),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(item.quantity.toString()),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(
                            'INR - ${item.product.salePrice.toStringAsFixed(2)}',
                          ),
                        ),
                        pw.Padding(
                          padding: pw.EdgeInsets.all(6),
                          child: pw.Text(
                            'INR - ${(item.product.salePrice * item.quantity).toStringAsFixed(2)}',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              pw.SizedBox(height: 16),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Subtotal: INR - ${bill.subtotal.toStringAsFixed(2)}',
                      ),
                      pw.Text(
                        'GST (${gstPercentage.toStringAsFixed(0)}%): INR - ${bill.gst.toStringAsFixed(2)}',
                      ),
                      pw.Text(
                        'Discount: INR - ${bill.discount.toStringAsFixed(2)}',
                      ),
                      pw.SizedBox(height: 6),
                      pw.Text(
                        'GRAND TOTAL: INR - ${bill.grandTotal.toStringAsFixed(2)}',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text('Note: Thank you for choosing BeatBoxx!'),
            ],
          ),
    ),
  );

  final bytes = await pdf.save();

  if (kIsWeb) {
    // pdf download in web
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor =
        html.AnchorElement(href: url)
          ..style.display = 'none'
          ..download = "Invoice-${bill.invoiceNumber}.pdf";
    html.document.body!.children.add(anchor);
    anchor.click();
    html.document.body!.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  } else {
    // pdf download in mobile
    final dir = await getExternalStorageDirectory();
    final file = io.File(
      savePath ?? '${dir!.path}/Invoice-${bill.invoiceNumber}.pdf',
    );
    await file.writeAsBytes(bytes);

    // check shouldOpen for open file after generate pdf
    if (shouldOpen) {
      await OpenFile.open(file.path);
    }
  }
}
