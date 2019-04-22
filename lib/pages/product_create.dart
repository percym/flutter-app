import 'package:flutter/material.dart';

class ProductCreatePage extends StatefulWidget {
  final Function addProduct;

  ProductCreatePage(this.addProduct);

  @override
  State<StatefulWidget> createState() {
    return _ProductsCreatePage();
  }
}

class _ProductsCreatePage extends State<ProductCreatePage> {
  String titleValue;
  String descriptionValue;
  double priceValue;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.all(10.0),
        child: ListView(
          children: <Widget>[
            TextField(
                decoration: InputDecoration(labelText: 'Product Title'),
                onChanged: (String value) {
                  setState(() {
                    titleValue = value;
                  });
                }),
            TextField(
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Product Description'),
                onChanged: (String value) {
                  setState(() {
                    descriptionValue = value;
                  });
                }),
            TextField(
                decoration: InputDecoration(labelText: 'Product Price'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    priceValue = double.parse(value);
                  });
                }),
            RaisedButton(
              child: Text('Save'),
              onPressed: () {
                final Map<String , dynamic> product = {'title':titleValue,'description':descriptionValue,'price':priceValue};
                widget.addProduct(product);
              },
            )
          ],
        ));
  }
}
