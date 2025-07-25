import 'package:flutter/material.dart';

class ProductListingReloadButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool inProgress;

  const ProductListingReloadButton({
    super.key,
    required this.onPressed,
    required this.inProgress,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: SizedBox(
        width: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (inProgress)
              const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            else
              const Icon(Icons.refresh),
            const SizedBox(width: 8),
            const Text('Reload'),
          ],
        ),
      ),
    );
  }
}
