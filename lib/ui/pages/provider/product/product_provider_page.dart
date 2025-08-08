import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
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
    final cartDataSource = context.read<CartRepository>();
    final stockDataSource = context.read<StockRepository>();
    final dialog = EcommerceDialog(context);
    final usecase = ShowProductDetailsUseCase(
      repository: context.read(),
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
            load: usecase.execute,
            addProduct:
                AddProductToCartUseCase(
                  cartRepository: cartDataSource,
                  dialog: dialog,
                  navigator: EcommerceNavigator(
                    context,
                    cartGoBackCallback:
                        () => {
                          usecase.execute(
                            productId: productId,
                            product: presenter.state.product,
                          ),
                        },
                  ),
                  presenter: presenter,
                  stockRepository: stockDataSource,
                ).execute,
          );
        },
      ),
    );
  }
}
