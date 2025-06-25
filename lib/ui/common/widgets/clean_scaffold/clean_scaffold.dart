import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:clean_ecommerce/ui/common/widgets/clean_app_bar/clean_app_bar.dart';
import 'package:flutter/material.dart';

class CleanScaffold extends Scaffold {
  CleanScaffold({
    super.key,
    required String title,
    List<Widget>? actions,
    required Widget super.body,
    required AppNavigator navigator,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
  }) : super(
         appBar: CleanAppBar(
           title: title,
           actions: actions,
           navigator: navigator,
         ),
       );
}
