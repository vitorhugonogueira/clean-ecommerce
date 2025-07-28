import 'package:clean_ecommerce/domain/entities/item.dart';
import 'package:clean_ecommerce/domain/usecases/cart/decrease_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/increase_cart_item_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/cart/remove_item_to_cart_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/cart_details_state.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_image.dart';
import 'package:flutter/material.dart';

class CartItem extends StatelessWidget {
  final Item item;
  final CartDetailsState state;
  final IncreaseCartItemUsecase increaseItem;
  final DecreaseCartItemUsecase decreaseItem;
  final RemoveItemToCartUseCase removeItem;

  const CartItem({
    super.key,
    required this.item,
    required this.state,
    required this.increaseItem,
    required this.decreaseItem,
    required this.removeItem,
  });

  Future<void> _increaseQuantity(String productId) async {
    if (state.isValidatingAction || state.cart == null) {
      return;
    }
    await increaseItem.execute(productId: productId, cart: state.cart!);
  }

  Future<void> _decreaseQuantity(String productId) async {
    if (state.isValidatingAction || state.cart == null) {
      return;
    }
    await decreaseItem.execute(productId: productId, cart: state.cart!);
  }

  Future<void> _removeItem(String productId) async {
    if (state.isValidatingAction || state.cart == null) {
      return;
    }
    await removeItem.execute(productId: productId, cart: state.cart!);
  }

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 60,
              height: 60,
              child: ProductImage(product: product),
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            state.isValidatingAction
                                ? null
                                : () => _decreaseQuantity(product.id),
                        tooltip: 'Decrease quantity',
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          '${item.quantity}',
                          style: textTheme.bodyLarge,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        onPressed:
                            state.isValidatingAction
                                ? null
                                : () => _increaseQuantity(product.id),
                        tooltip: 'Increase quantity',
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(Icons.delete_outline, color: colorScheme.secondary),
              tooltip: 'Remove item',
              onPressed:
                  state.isValidatingAction
                      ? null
                      : () => _removeItem(product.id),
            ),
          ),
        ],
      ),
    );
  }
}
