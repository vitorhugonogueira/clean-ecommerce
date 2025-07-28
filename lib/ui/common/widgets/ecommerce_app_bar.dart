import 'package:flutter/material.dart';

class CleanAppBar extends AppBar {
  CleanAppBar({
    super.key,
    String? title,
    Function()? goCart,
    List<Widget>? actions,
    required BuildContext context,
  }) : super(
         title: CleanArchAppTitle(title: title),
         actions:
             actions ??
             [
               IconButton(
                 onPressed:
                     goCart ?? () => Navigator.of(context).pushNamed('/cart'),
                 icon: const Icon(Icons.shopping_bag_sharp),
               ),
               IconButton(
                 onPressed:
                     () => Navigator.of(
                       context,
                       rootNavigator: true,
                     ).pushNamed('/'),
                 icon: const Icon(Icons.menu),
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
    final textStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );

    if (title != null && title!.isNotEmpty) {
      return Text(title!, style: textStyle);
    }

    return Row(
      children: [
        Text('CLEAN ARCH', style: textStyle),
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
