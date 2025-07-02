const defaultURL = 'http://localhost:3000';

class DataConfig {
  static String get apiUrl {
    return String.fromEnvironment('API_URL', defaultValue: defaultURL);
  }

  static String get productImagesUrl {
    return String.fromEnvironment(
      'PRODUCT_IMAGES_URL',
      defaultValue: defaultURL,
    );
  }
}
