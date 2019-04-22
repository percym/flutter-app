import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProductsCreatePage();
  }
}

class _ProductsCreatePage extends State<ProductCreatePage> {
  String titleValue ='';
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TextField(onChanged: (String value) {
          setState(() {
            titleValue = value;
          });
        }),
        Text(titleValue)
      ],
    );
  }
}
