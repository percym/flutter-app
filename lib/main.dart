import 'package:first_app/pages/auth.dart';
import 'package:first_app/pages/home.dart';
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
        home:AuthPage(),
    );
  }
}
