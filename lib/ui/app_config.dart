import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/firestore/details_firestore.dart';
import 'package:clean_ecommerce/data/data_sources/firestore/listing_firestore.dart';
import 'package:clean_ecommerce/data/data_sources/firestore/stock_firestore.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_listing_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

enum AppDataSource { api, firebase }

class AppConfig extends StatelessWidget {
  final Widget child;
  late final List<SingleChildWidget> _dataProviders;

  AppConfig({
    super.key,
    required this.child,
    required AppDataSource dataSource,
  }) {
    if (dataSource == AppDataSource.api) {
      _dataProviders = [
        Provider.value(
          value: ProductListingDataSource() as ProductListingRepository,
        ),
        Provider.value(
          value: ProductDetailsDataSource() as ProductDetailsRepository,
        ),
        Provider.value(value: CartDataSource() as CartRepository),
        Provider.value(value: StockDataSource() as StockRepository),
      ];
    } else {
      _dataProviders = [
        Provider.value(value: ListingFirestore() as ProductListingRepository),
        Provider.value(value: DetailsFirestore() as ProductDetailsRepository),
        Provider.value(value: CartDataSource() as CartRepository),
        Provider.value(value: StockFirestore() as StockRepository),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(providers: _dataProviders, child: child);
  }
}
