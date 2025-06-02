import 'dart:developer';

import 'package:clean_ecommerce/domain/gateways/dialog_gateway.dart';
import 'package:flutter/material.dart';

class EcommerceDialog implements DialogGateway {
  final BuildContext context;

  EcommerceDialog(this.context);

  void _showEcommerceDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
  }) {
    if (!context.mounted) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(icon, color: color),
              SizedBox(width: 8),
              Text(title),
            ],
          ),
          content: Text(message, style: TextStyle(color: color)),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void showError(String message) {
    _showEcommerceDialog(
      title: 'Error',
      message: message,
      icon: Icons.error_outline,
      color: Colors.red.shade700,
    );
  }

  @override
  Future<bool> showConfirm(String message) {
    log('Confirm: $message');
    throw UnimplementedError();
  }

  @override
  void showSuccess(String message) {
    _showEcommerceDialog(
      title: 'Success',
      message: message,
      icon: Icons.check_circle_outline,
      color: Colors.green.shade700,
    );
  }

  @override
  void showWarning(String message) {
    _showEcommerceDialog(
      title: 'Warning',
      message: message,
      icon: Icons.warning_amber_outlined,
      color: Colors.orange.shade700,
    );
  }

  @override
  void notifySuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 3)),
    );
  }
}
