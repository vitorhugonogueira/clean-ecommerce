import 'package:mockito/annotations.dart';
import 'common/dialog_mock.dart';
import 'common/navigator_mock.dart';
import 'presenters/product_listing_presenter.dart';
import 'presenters/product_details_presenter.dart';
import 'presenters/cart_details_presenter.dart';

@GenerateMocks([
  DialogMockito,
  NavigatorMockito,
  ProductListingPresenterMockito,
  ProductDetailsPresenterMockito,
  CartDetailsPresenterMockito,
])
void main() {}
