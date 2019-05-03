import 'package:first_app/models/product.dart';
import 'package:first_app/scoped-models/connected_products.dart';

class ProductsModel extends ConnectedProducts {

  bool _showFavourites= false;

  List<Product> get allProducts {
    return List.from(products);
  }


  List<Product> get displayedProducts {
    if(_showFavourites){
      return List.from(products.where((Product product)=>
        product.isFavourite).toList());
    }
    return List.from(products);
  }



  void updateProduct(String title , String description , double price , String image ) {
    final newProduct = Product(title: title, description: description , price: price , image:  image  , userEmail: authenticatedUser.email , userId: authenticatedUser.id );
    products.add(newProduct);
    selProductIndex = null;
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selProductIndex = null;
  }

  void selectProduct(int index) {
    selProductIndex = index;
    notifyListeners();
  }

  int get selectedProductIndex {
    return selProductIndex;
  }

  void toggleProductIsFavoriteStatus() {
    final bool isCurrentlyFavourite =
        products[selectedProductIndex].isFavourite;
    final bool isNewFavouriteStatus = !isCurrentlyFavourite;
    final Product updateProduct = Product(
        title: products[selectedProductIndex].title,
        description: products[selectedProductIndex].description,
        price: products[selectedProductIndex].price,
        image: products[selectedProductIndex].image ,
        isFavourite: isNewFavouriteStatus,
        userEmail:products[selectedProductIndex].userEmail,
        userId: products[selectedProductIndex].userId);
    products[selectedProductIndex] = updateProduct;
    selProductIndex = null;
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