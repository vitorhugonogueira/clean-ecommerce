import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:clean_ecommerce/data/mappers/cart_mapper.dart';
import 'package:clean_ecommerce/domain/models/cart.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/result/result.dart';

class CartDataSource implements CartRepository {
  static const String _cartStorageKey = 'cart_data';

  @override
  Future<Cart?> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartString = prefs.getString(_cartStorageKey);

      if (cartString != null && cartString.isNotEmpty) {
        final Map<String, dynamic> cartMap = jsonDecode(cartString);
        final cart = getCartFromMap(cartMap);

        return cart;
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<Result<bool>> saveCart(Cart cart) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final Map<String, dynamic> cartMap = getMapFromCart(cart);

      await prefs.setString(_cartStorageKey, jsonEncode(cartMap));
      return Result.success(true);
    } catch (e) {
      return Result.failure('Failed to save cart to storage.');
    }
  }
}
