import 'package:first_app/models/product.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:first_app/scoped-models/product.dart';

import './product_card.dart';

class Products extends StatelessWidget {

  Widget _buildProductList(List<Product> products ) {
    Widget productCards;
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    } else {
      productCards = Container();
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    print('[Products Widget] build()');
    return ScopedModelDescendant<ProductsModel>(builder: (BuildContext  context, Widget child, ProductsModel model  ){
      return _buildProductList(model.displayedProducts);
    },);
  }
}
