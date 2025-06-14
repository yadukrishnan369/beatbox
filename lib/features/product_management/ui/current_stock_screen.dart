import 'package:flutter/material.dart';

class CurrentStockScreen extends StatelessWidget {
  const CurrentStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Current stock")),
      body: Center(child: Text("welcome to Current stock")),
    );
  }
}
