abstract class DialogGateway {
  void showError(String message);
  void showSuccess(String message);
  void showWarning(String message);

  Future<bool> showConfirm(String message);

  void notifySuccess(String message);
}
