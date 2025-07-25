import 'package:clean_ecommerce/ui/common/widgets/ecommerce_app_bar.dart';
import 'package:flutter/material.dart';

class CleanScaffold extends Scaffold {
  CleanScaffold({
    super.key,
    String? title,
    List<Widget>? actions,
    Function()? goCart,
    required Widget super.body,
    required BuildContext context,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
  }) : super(
         appBar: CleanAppBar(
           title: title,
           actions: actions,
           context: context,
           goCart: goCart,
         ),
       );
}
