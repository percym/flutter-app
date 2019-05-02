import 'package:first_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];

  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
  }

  void addProduct(Product product) {
    _products.add(product);
    _selectedProductIndex = null;
  }

  void updateProduct(Product product) {
    _products[_selectedProductIndex] = product;
    _selectedProductIndex = null;
  }

  void deleteProduct() {
    _products.removeAt(_selectedProductIndex);
    _selectedProductIndex = null;
  }

  void selectProduct(int index) {
    _selectedProductIndex = index;
  }

  int get selectedProductIndex {
    return _selectedProductIndex;
  }

  void toggleProductIsFavoriteStatus() {
    final bool isCurrentlyFavourite =
        _products[selectedProductIndex].isFavourite;
    final bool isNewFavouriteStatus = !isCurrentlyFavourite;
    final Product updateProduct = Product(
        title: _products[selectedProductIndex].title,
        description: _products[selectedProductIndex].description,
        price: _products[selectedProductIndex].price,
        image: null,
        isFavourite: isNewFavouriteStatus);
    products[selectedProductIndex] = updateProduct;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }
}
