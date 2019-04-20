import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'product_manager.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
//    debugPaintSizeEnabled = true;
//    debugPaintBaselinesEnabled = true;

    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange
        ),
        home: new Scaffold(
          appBar: AppBar(
            title: Text('EasyList'),
          ),
          body: ProductManager(startingProduct:'Food tester')
        )
    );
  }
}
