import 'package:clean_ecommerce/domain/models/cart.dart';

abstract class NavigatorGateway {
  void goCart({Cart? cart, Function callback});
  void goDetails(String id);
  void goHome();
}
