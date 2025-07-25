import 'package:clean_ecommerce/ui/common/widgets/card/simple_card.dart';
import 'package:clean_ecommerce/ui/product/widgets/product_image.dart';
import 'package:flutter/material.dart';
import 'package:clean_ecommerce/domain/entities/product.dart'; // Adjust import path if needed

class ProductCard extends StatelessWidget {
  final Product product;
  final void Function(String id) onTap;

  const ProductCard({super.key, required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: () => onTap(product.id),
      child: SimpleCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: colorScheme.secondary,
                width: double.infinity,
                child: ProductImage(product: product),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 25,
                      width: double.infinity,
                      child: Text(
                        product.name,
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8.0),

                    Text(
                      product.priceLabel,
                      style: textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
