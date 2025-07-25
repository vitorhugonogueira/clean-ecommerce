import 'package:clean_ecommerce/domain/entities/cart.dart';

abstract class NavigatorGateway {
  void goCart({Cart? cart});
  void goDetails(String id);
  void goHome();
}
