import 'package:clean_ecommerce/data/mappers/product_mapper.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailsFirestore extends ProductDetailsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<Product>> getProductDetails(String productId) async {
    try {
      final snapshot =
          await _firestore
              .collection('products')
              .where('id', isEqualTo: productId)
              .limit(1)
              .get();

      return snapshot.docs.isNotEmpty
          ? Result.success(getProductFromMap(snapshot.docs.first.data()))
          : Result.failure('Product not found');
    } catch (e) {
      return Result.failure('Failed to fetch product details: $e');
    }
  }
}
