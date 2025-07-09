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
}
