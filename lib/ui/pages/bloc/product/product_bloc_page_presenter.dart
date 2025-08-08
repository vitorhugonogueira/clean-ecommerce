import 'package:bloc/bloc.dart';
import 'package:clean_ecommerce/domain/entities/product.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/gateways/navigator_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_details_presenter.dart';
import 'package:clean_ecommerce/domain/repositories/cart_repository.dart';
import 'package:clean_ecommerce/domain/repositories/product_details_repository.dart';
import 'package:clean_ecommerce/domain/repositories/stock_repository.dart';
import 'package:clean_ecommerce/domain/usecases/product/add_product_to_cart_usecase.dart';
import 'package:clean_ecommerce/domain/usecases/product/show_product_details_usecase.dart';
import 'package:clean_ecommerce/ui/common/states/product_details_state.dart';

class ProductBlocPagePresenter extends Cubit<ProductDetailsState>
    implements ProductDetailsPresenter {
  final DialogGateway dialog;
  final NavigatorGateway navigator;
  final ProductDetailsRepository repository;
  final CartRepository cartRepository;
  final StockRepository stockRepository;
  late final ShowProductDetailsUseCase usecase;
  late final AddProductToCartUseCase addProductUsecase;

  ProductBlocPagePresenter(
    String productId, {
    required this.dialog,
    required this.navigator,
    required this.repository,
    required this.cartRepository,
    required this.stockRepository,
  }) : super(ProductDetailsState()) {
    usecase = ShowProductDetailsUseCase(
      repository: repository,
      presenter: this,
      dialog: dialog,
      cartRepository: cartRepository,
      stockRepository: stockRepository,
    )..execute(productId: productId);

    addProductUsecase = AddProductToCartUseCase(
      cartRepository: cartRepository,
      dialog: dialog,
      navigator: navigator,
      presenter: this,
      stockRepository: stockRepository,
    );
  }

  @override
  void setIsLoading(bool value) {
    emit(state.copyWith(isLoading: value));
  }

  @override
  void setIsValidatingAction(bool inProgress) {
    emit(state.copyWith(isValidatingAction: inProgress));
  }

  @override
  void showProduct(Product product) {
    emit(state.copyWith(product: product));
  }

  @override
  void showStock(int stock) {
    emit(state.copyWith(stock: stock));
  }
}
