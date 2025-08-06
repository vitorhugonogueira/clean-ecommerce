import 'dart:js_interop_unsafe';
import 'package:clean_ecommerce/ui/app_flavor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:js_interop' as js;

class MenuPage extends StatefulWidget {
  final schemes = [
    {
      'label': 'setState',
      'route': '/state-app',
      'scheme': AppFlavor.colorScheme(Flavor.state),
    },
    {
      'label': 'Provider',
      'route': '/provider-app',
      'scheme': AppFlavor.colorScheme(Flavor.provider),
    },
    {
      'label': 'Bloc',
      'route': '/bloc-app',
      'scheme': AppFlavor.colorScheme(Flavor.bloc),
    },
    {
      'label': 'Provider (MVVM)',
      'route': '/mvvm-app',
      'scheme': AppFlavor.colorScheme(Flavor.mvvm),
    },
  ];
  MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      // ignore: invalid_runtime_check_with_js_interop_types
      js.globalContext.callMethod('hideFlutterSplashScreen' as js.JSAny);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clean Arch E-Commerce'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      'Choose the state management approach:',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.visible,
                      softWrap: true,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            ...widget.schemes.map((item) {
              final scheme = item['scheme'] as ColorScheme;
              final label = item['label'] as String;
              final route = item['route'] as String;
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: SizedBox(
                  width: 220,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scheme.primary,
                      foregroundColor: scheme.onPrimary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed(route);
                    },
                    child: Text(label, style: TextStyle(fontSize: 18)),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
