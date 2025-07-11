import 'package:clean_ecommerce/domain/repositories/product_listing_repository.dart';
import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:clean_ecommerce/domain/presenters/product_listing_presenter.dart';
import 'package:clean_ecommerce/domain/states/product_listing_state.dart';

class ShowProductsUseCase {
  final ProductListingRepository repository;
  final ProductListingPresenter presenter;
  final DialogGateway dialog;

  ShowProductsUseCase({
    required this.repository,
    required this.presenter,
    required this.dialog,
  });

  Future<void> execute({int page = 1, int pageSize = 15}) async {
    presenter.setInProgress(true);

    final result = await repository.getProducts(page, pageSize);

    if (result.isFailure) {
      dialog.showError(result.errorMessage!);
      presenter.setInProgress(false);
      return;
    }

    final listing = result.content!;
    presenter.show(
      ProductListingState(
        products: listing.products,
        page: listing.page,
        totalOfPages: listing.totalOfPages,
        pageSize: listing.pageSize,
      ),
    );

    presenter.setInProgress(false);
  }
}
