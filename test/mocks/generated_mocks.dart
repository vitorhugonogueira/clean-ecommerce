import 'package:mockito/annotations.dart';
import 'common/dialog_mock.dart';
import 'presenters/product_listing_presenter.dart';
import 'presenters/product_details_presenter.dart';

@GenerateMocks([
  DialogMockito,
  ProductListingPresenterMockito,
  ProductDetailsPresenterMockito,
])
void main() {}
