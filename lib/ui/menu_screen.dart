import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

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
            SizedBox(
              width: 220,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/state-app');
                },
                child: Text('setState', style: TextStyle(fontSize: 18)),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: 220,
              height: 40,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed('/provider-app');
                },
                child: Text('Provider', style: TextStyle(fontSize: 18)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
