import 'package:clean_ecommerce/data/data_config.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  const ProductImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    if (product.imageUrl.isEmpty) {
      return const Center(
        child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
      );
    }

    return Image.network(
      DataConfig.productImagesUrl + product.imageUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(
          child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
        );
      },
    );
  }
}
