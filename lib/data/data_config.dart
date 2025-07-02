import 'package:flutter_dotenv/flutter_dotenv.dart';

const defaultURL = 'http://localhost:3000';

class DataConfig {
  static String get apiUrl {
    const String enviromentApiUrl = String.fromEnvironment('API_URL');
    if (enviromentApiUrl.isNotEmpty) {
      return enviromentApiUrl;
    }

    return dotenv.env['API_URL'] ?? defaultURL;
  }

  static String get productImagesUrl {
    const String enviromentProductImagesUrl = String.fromEnvironment(
      'PRODUCT_IMAGES_URL',
    );
    if (enviromentProductImagesUrl.isNotEmpty) {
      return enviromentProductImagesUrl;
    }

    return dotenv.env['PRODUCT_IMAGES_URL'] ?? defaultURL;
  }
}
