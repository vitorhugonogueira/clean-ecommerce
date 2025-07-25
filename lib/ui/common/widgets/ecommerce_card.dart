import 'package:flutter/material.dart';

class EcommerceCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final Color backgroundColor;
  final BorderRadiusGeometry? borderRadius;

  const EcommerceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(0.0),
    this.backgroundColor = Colors.white,
    this.borderRadius = const BorderRadius.all(Radius.circular(0.0)),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}
