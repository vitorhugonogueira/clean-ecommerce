import 'package:clean_ecommerce/data/mappers/product_mapper.dart';
import 'package:clean_ecommerce/domain/entities/product_pagination.dart';
import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListingFirestore extends ProductListingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<ProductPagination>> getProducts(int page, int pageSize) async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore
              .collection('products')
              .orderBy('name')
              .limit(pageSize)
              .get();

      final list =
          querySnapshot.docs.map((doc) {
            return getProductFromMap(doc.data() as Map<String, dynamic>);
          }).toList();

      return Result.success(
        ProductPagination(
          page: 1,
          pageSize: pageSize,
          products: list,
          totalOfPages: querySnapshot.size,
        ),
      );
    } catch (e) {
      return Result.failure('Failed to load products: ${e.toString()}.');
    }
  }
}
