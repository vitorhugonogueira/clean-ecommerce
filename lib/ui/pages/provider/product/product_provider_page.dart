import 'package:clean_ecommerce/data/data_sources/cart_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/product_details_data_source.dart';
import 'package:clean_ecommerce/data/data_sources/stock_data_source.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:clean_ecommerce/ui/pages/provider/product/product_provider_page_presenter.dart';

class ProductProviderPage extends StatelessWidget {
  final String productId;

  const ProductProviderPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final presenter = ProductProviderPagePresenter();
    final cartDataSource = CartDataSource();
    final stockDataSource = StockDataSource();
    final dialog = EcommerceDialog(context);
    final usecase = ShowProductDetailsUseCase(
      repository: ProductDetailsDataSource(),
      presenter: presenter,
      dialog: dialog,
      cartRepository: cartDataSource,
      stockRepository: stockDataSource,
    );
    usecase.execute(productId: productId);

    return ChangeNotifierProvider<ProductProviderPagePresenter>(
      create: (_) => presenter,
      child: Consumer<ProductProviderPagePresenter>(
        builder: (context, presenter, _) {
          return ProductDetails(
            context: context,
            productId: productId,
            state: presenter.state,
            showDetailsUseCase: usecase,
            addProductToCartUseCase: AddProductToCartUseCase(
              cartRepository: cartDataSource,
              dialog: dialog,
              navigator: EcommerceNavigator(context),
              presenter: presenter,
              stockRepository: stockDataSource,
            ),
          );
        },
      ),
    );
  }
}
