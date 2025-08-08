import 'package:clean_ecommerce/data/data_models/stock_data_model.dart';
import 'package:clean_ecommerce/domain/entities/result.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StockFirestore implements StockRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Result<int>> getStockAvailable(String productId) async {
    try {
      final snapshot =
          await _firestore
              .collection('stock')
              .where('id', isEqualTo: productId)
              .limit(1)
              .get();

      return snapshot.docs.isNotEmpty
          ? Result.success(
            StockDataModel.fromJson(snapshot.docs.first.data()).stock,
          )
          : Result.failure('Stock not found');
    } catch (e) {
      return Result.failure('Failed to fetch stock information: $e');
    }
  }
}
