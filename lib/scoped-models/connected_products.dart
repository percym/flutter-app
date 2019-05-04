import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProducts extends Model {
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;
  bool _isLoading = false;

  Future<Null> addProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
          'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    return http
        .post('https://flutter-products-5186c.firebaseio.com/products.json',
            body: json.encode(productData))
        .then((http.Response resp) {
      final Map<String, dynamic> respData = json.decode(resp.body);
      print(respData);
      final newProduct = Product(
          id: respData['name'],
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      products.add(newProduct);
      notifyListeners();
      _isLoading = false;
      selProductIndex = null;
    });
  }
}

class ProductsModel extends ConnectedProducts {
  bool _showFavourites = false;

  List<Product> get allProducts {
    return List.from(products);
  }

  void fetchProducts() {
    _isLoading = true;
    http
        .get('https://flutter-products-5186c.firebaseio.com/products.json')
        .then((http.Response response) {
      final List<Product> fetchedProductList = [];
      print(json.decode(response.body));
      final Map<String, dynamic> productListData =
          json.decode(response.body);
      if(productListData == null){
        _isLoading = false;
        notifyListeners();
        return ;
      }
      productListData
          .forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price:productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
    });
  }

  List<Product> get displayedProducts {
    if (_showFavourites) {
      return List.from(
          products.where((Product product) => product.isFavourite).toList());
    }
    return List.from(products);
  }

  void updateProduct(
      String title, String description, double price, String image) {
    final newProduct = Product(
        title: title,
        description: description,
        price: price,
        image: image,
        userEmail: authenticatedUser.email,
        userId: authenticatedUser.id);
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
        image: products[selectedProductIndex].image,
        isFavourite: isNewFavouriteStatus,
        userEmail: products[selectedProductIndex].userEmail,
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

  void toggleDisplayMode() {
    _showFavourites = !_showFavourites;
    notifyListeners();
  }

  bool get displayFavouritesOnly {
    return _showFavourites;
  }

}

class UserModel extends ConnectedProducts {
  void login(String email, String password) {
    authenticatedUser = User(id: '23', email: email, password: password);
  }
}

class UtilityModel extends ConnectedProducts{
  bool get isLoadingProducts{
    return _isLoading;
  }
}

