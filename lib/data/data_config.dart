import 'package:clean_ecommerce/data/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

const defaultURL = 'http://localhost:3000';

class DataConfig {
  static const String apiUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: defaultURL,
  );

  static const String productImagesUrl = String.fromEnvironment(
    'PRODUCT_IMAGES_URL',
    defaultValue: defaultURL,
  );

  static void initializeFirebase() {
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
}
