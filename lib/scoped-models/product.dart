import 'package:first_app/models/product.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductsModel extends Model {
  List<Product> _products = [];
  bool _showFavourites= false;

  int _selectedProductIndex;

  List<Product> get products {
    return List.from(_products);
  }


  List<Product> get displayedProducts {
    if(_showFavourites){
      return List.from(_products.where((Product product)=>
        product.isFavourite).toList());
    }
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
    notifyListeners();
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
        image: _products[selectedProductIndex].image ,
        isFavourite: isNewFavouriteStatus);
    products[selectedProductIndex] = updateProduct;
    _selectedProductIndex = null;
    notifyListeners();
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  void toggleDisplayMode(){
    _showFavourites = !_showFavourites;
    notifyListeners();
  }

  bool get displayFavouritesOnly{
    return _showFavourites;
  }
}