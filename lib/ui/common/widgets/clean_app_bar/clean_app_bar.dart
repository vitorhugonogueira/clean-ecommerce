import 'package:clean_ecommerce/ui/common/navigator/app_navigator.dart';
import 'package:flutter/material.dart';

class CleanAppBar extends AppBar {
  CleanAppBar({
    super.key,
    String? title,
    required AppNavigator navigator,
    List<Widget>? actions,
  }) : super(
         title: CleanArchAppTitle(title: title),
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

class CleanArchAppTitle extends StatelessWidget {
  const CleanArchAppTitle({super.key, this.title});

  final String? title;

  @override
  Widget build(BuildContext context) {
    if (title != null) {
      return Text(title!, style: TextStyle(fontWeight: FontWeight.bold));
    }
    return const Row(
      children: [
        Text('CLEAN ARCH', style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(width: 6),
        Text(
          'E-COMMERCE',
          style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
        ),
      ],
    );
  }
}
