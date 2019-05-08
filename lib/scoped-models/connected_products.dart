import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class ConnectedProducts extends Model {
  List<Product> products = [];
  User authenticatedUser;
  String selProductIndex;
  bool _isLoading = false;

  Future<bool> addProduct(
      String title, String description, double price, String image) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'price': price,
      'image':
      'https://www.gstatic.com/mobilesdk/160503_mobilesdk/logo/2x/firebase_28dp.png',
      'userEmail': authenticatedUser.email,
      'userId': authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-products-5186c.firebaseio.com/products.json',
          body: json.encode(productData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> respData = json.decode(response.body);
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
      return true;
    }catch(error){
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class ProductsModel extends ConnectedProducts {
  bool _showFavourites = false;
  List<Product> get allProducts {
    return List.from(products);
  }

  Future<bool> fetchProducts() {
    _isLoading = true;
    return http
        .get('https://flutter-products-5186c.firebaseio.com/products.json')
        .then((http.Response response) {
      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final List<Product> fetchedProductList = [];
      print(json.decode(response.body));
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            price: productData['price'],
            image: productData['image'],
            userEmail: productData['userEmail'],
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      products = fetchedProductList;
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  List<Product> get displayedProducts {
    if (_showFavourites) {
      return List.from(
          products.where((Product product) => product.isFavourite).toList());
    }
    return List.from(products);
  }

  Future<bool> updateProduct(
      String title, String description, double price, String image) {
    _isLoading = true;
    notifyListeners();
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
        .put(
            'https://flutter-products-5186c.firebaseio.com/products/${selectedProduct.id}.json',
            body: json.encode(productData))
        .then((http.Response response) {
      _isLoading = false;
      final newProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          price: price,
          image: image,
          userEmail: authenticatedUser.email,
          userId: authenticatedUser.id);
      products.add(newProduct);
      selProductIndex = null;
      notifyListeners();
      return true;
    });
  }

  Future<bool> deleteProduct() {
    _isLoading = true;
    return http
        .delete(
            'https://flutter-products-5186c.firebaseio.com/products/${selectedProduct.id}.json')
        .then((http.Response response) {
      _isLoading = false;
      final int selectedProductIndex = products.indexWhere((Product product) {
        return product.id == selectedProduct.id;
      });
      products.removeAt(selectedProductIndex);
      selProductIndex = null;
      notifyListeners();
      return true;
    });
  }

  void selectProduct(String index) {
    selProductIndex = index;
    notifyListeners();
  }

  String get selectedProductIndex {
    return selProductIndex;
  }

  void toggleProductIsFavoriteStatus() {
    final bool isCurrentlyFavourite = selectedProduct.isFavourite;
    final bool isNewFavouriteStatus = !isCurrentlyFavourite;
    final Product updateProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        isFavourite: isNewFavouriteStatus,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    final int selectedProductIndex = products.indexWhere((Product product) {
      return product.id == selectedProduct.id;
    });
    products[selectedProductIndex] = updateProduct;
    selProductIndex = null;
    notifyListeners();
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products.firstWhere((Product product) {
      return product.id == selectedProductIndex;
    });
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

  Future<Map<String,dynamic>> signUp(String email ,String password) async{
    final Map<String , dynamic> authData = {
      'email':email,
      'password':password
    };
    final http.Response response = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBjRbkwezLBR-nK2LZsFySMbBWwZIYLUwM' , body: json.encode(authData),headers: {'ContentType': 'application/json'});
    print(json.decode(response.body));
    final Map<String, dynamic> responseDecoded = json.decode(response.body);
    bool hasError =true;
    var message = 'An error occured';
    if(responseDecoded.containsKey('idToken')){
      hasError =false;
      message = 'Authentication Succeeded';
    }else if (responseDecoded['error']['message']== 'EMAIL_EXISTS'){
      message = 'Email already exists';
    }
    return { 'success':!hasError , 'message':message} ;

  }
}

class UtilityModel extends ConnectedProducts {
  bool get isLoadingProducts {
    return _isLoading;
  }
}
