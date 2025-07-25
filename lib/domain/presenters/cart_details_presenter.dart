import 'package:clean_ecommerce/domain/entities/cart.dart';

abstract class CartDetailsPresenter {
  void showCart(Cart cart);
  void setIsLoading(bool inProgress);
  void setIsValidatingAction(bool inProgress);
}
