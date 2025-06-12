import 'package:flutter/material.dart';

class BrandAndCategoryScreen extends StatefulWidget {
  const BrandAndCategoryScreen({super.key});

  @override
  State<BrandAndCategoryScreen> createState() => _BrandAndCategoryScreenState();
}

class _BrandAndCategoryScreenState extends State<BrandAndCategoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("welcom to brand and category screen")),
    );
  }
}
