import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/dialog/ecommerce_dialog.dart';
import 'package:clean_ecommerce/ui/common/navigator/ecommerce_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/product/product_details.dart';
import 'package:clean_ecommerce/ui/pages/state/product/product_state_page_presenter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductStatePage extends StatefulWidget {
  final String productId;

  const ProductStatePage({super.key, required this.productId});

  @override
  State<ProductStatePage> createState() => _ProductStatePageState();
}

class _ProductStatePageState extends State<ProductStatePage> {
  late ShowProductDetailsUseCase _showDetailsUseCase;
  late AddProductToCartUseCase _addProductToCartUseCase;
  late ProductDetailsState _state;

  @override
  void initState() {
    super.initState();

    final dataSource = context.read<ProductDetailsRepository>();
    final cartDataSource = context.read<CartRepository>();
    final stockDataSource = context.read<StockRepository>();
    final dialog = EcommerceDialog(context);
    final presenter = ProductStatePagePresenter(
      onStateChanged: (newState) {
        if (!mounted) return;
        setState(() {
          _state = newState;
        });
      },
    );

    _showDetailsUseCase = ShowProductDetailsUseCase(
      repository: dataSource,
      presenter: presenter,
      dialog: dialog,
      cartRepository: cartDataSource,
      stockRepository: stockDataSource,
    );
    _addProductToCartUseCase = AddProductToCartUseCase(
      cartRepository: cartDataSource,
      dialog: dialog,
      navigator: EcommerceNavigator(
        context,
        cartGoBackCallback:
            () => _showDetailsUseCase.execute(
              productId: widget.productId,
              product: _state.product,
            ),
      ),
      presenter: presenter,
      stockRepository: stockDataSource,
    );

    _showDetailsUseCase.execute(productId: widget.productId);
  }

  @override
  Widget build(BuildContext context) {
    return ProductDetails(
      context: context,
      productId: widget.productId,
      state: _state,
      load: _showDetailsUseCase.execute,
      addProduct: _addProductToCartUseCase.execute,
    );
  }
}
