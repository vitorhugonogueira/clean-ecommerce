import 'package:clean_ecommerce/data/data_config.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final Product product;
  const ProductImage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final imageSource = DataConfig.productImagesUrl + product.imageUrl;
    return product.imageUrl.isNotEmpty
        ? Image.network(
          imageSource,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Center(
              child: CircularProgressIndicator(
                value:
                    loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return const Center(
              child: Icon(Icons.broken_image, size: 40, color: Colors.grey),
            );
          },
        )
        : const Center(
          child: Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
        );
  }
}
