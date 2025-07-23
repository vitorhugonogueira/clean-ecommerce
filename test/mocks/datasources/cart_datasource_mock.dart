import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

class CartDataSourceMock extends CartRepository {
  final Result<bool> _savingResult;
  final Cart? _getCartResult;

  CartDataSourceMock._(this._savingResult, this._getCartResult);

  factory CartDataSourceMock.saveSuccess(bool status, Cart? getCartResult) =>
      CartDataSourceMock._(Result.success(status), getCartResult);

  factory CartDataSourceMock.saveFail(
    String errorMessage,
    Cart? getCartResult,
  ) => CartDataSourceMock._(Result.failure(errorMessage), getCartResult);

  @override
  Future<Cart?> getCart() async {
    return _getCartResult;
  }

  @override
  Future<Result<bool>> saveCart(Cart cart) async {
    return _savingResult;
  }
}
