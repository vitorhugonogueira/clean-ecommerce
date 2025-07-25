import 'package:clean_ecommerce/domain/models/product.dart';

abstract class ProductDetailsPresenter {
  void showProduct(Product product);
  void showStock(int stock);
  void setIsLoading(bool inProgress);
  void setIsValidatingAction(bool inProgress);
}
