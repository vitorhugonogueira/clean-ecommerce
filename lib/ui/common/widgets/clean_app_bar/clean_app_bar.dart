import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:flutter/material.dart';

class CleanAppBar extends AppBar {
  CleanAppBar({
    super.key,
    required String title,
    required AppNavigator navigator,
    List<Widget>? actions,
  }) : super(
         title: Text(title),
         actions:
             actions ??
             [
               IconButton(
                 onPressed: () => navigator.goCart(),
                 icon: const Icon(Icons.shopping_bag_sharp),
               ),
               const SizedBox(width: 30),
             ],
       );
}
