import 'package:clean_ecommerce/ui/product/listing/product_listing_screen.dart';
import 'package:flutter/material.dart';

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-commerce App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 241, 241, 241),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 19, 102, 197),
        ),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      home: const ProductListingScreen(),
    );
  }
}
