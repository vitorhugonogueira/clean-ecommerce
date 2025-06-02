import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

abstract class CartRepository {
  Future<Cart?> getCart();
  Future<Result<bool>> saveCart(Cart cart);
}
