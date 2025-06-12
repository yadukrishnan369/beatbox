import 'package:flutter/material.dart';

class LimitedStockScreen extends StatelessWidget {
  const LimitedStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Limited stock")),
      body: Center(child: Text("welcome to Limited stock")),
    );
  }
}
