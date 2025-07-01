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
    if (title != null && title!.isNotEmpty) {
      return Text(title!, style: TextStyle(fontWeight: FontWeight.bold));
    }
    return Row(
      children: [
        const Text('CLEAN ARCH', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Flexible(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 120) {
                return const Text(
                  'E-COMMERCE',
                  style: TextStyle(fontStyle: FontStyle.italic, fontSize: 20.0),
                  softWrap: false,
                  overflow: TextOverflow.fade,
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }
}
