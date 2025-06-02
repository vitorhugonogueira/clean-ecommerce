class StockDataModel {
  final String id;
  final int stock;

  StockDataModel({required this.id, required this.stock});

  factory StockDataModel.fromJson(Map<String, dynamic> json) {
    return StockDataModel(
      id: json['id'] as String,
      stock: json['stock'] as int,
    );
  }
}
