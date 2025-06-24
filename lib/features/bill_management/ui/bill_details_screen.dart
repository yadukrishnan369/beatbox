import 'package:beatbox/features/sales_management/model/sales_model.dart';
import 'package:flutter/material.dart';

class BillDetailsScreen extends StatefulWidget {
  const BillDetailsScreen({super.key});

  @override
  State<BillDetailsScreen> createState() => _BillDetailsScreenState();
}

class _BillDetailsScreenState extends State<BillDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    final bill = ModalRoute.of(context)!.settings.arguments as SalesModel;
    return Scaffold(
      body: Center(
        child: Text('welcome to bill details screen  ${bill.customerName}'),
      ),
    );
  }
}
