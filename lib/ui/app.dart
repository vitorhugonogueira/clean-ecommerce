import 'package:clean_ecommerce/ui/product/listing/product_listing_screen.dart';
import 'package:flutter/material.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 26, 145, 62),
        ),
        useMaterial3: true,
      ),
      home: const ProductListingScreen(),
    );
  }
}
