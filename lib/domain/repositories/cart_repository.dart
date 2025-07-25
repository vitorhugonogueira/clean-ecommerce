import 'package:clean_ecommerce/domain/entities/cart.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';

abstract class CartRepository {
  Future<Cart?> getCart();
  Future<Result<bool>> saveCart(Cart cart);
}
