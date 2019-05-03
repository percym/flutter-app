import 'package:first_app/models/product.dart';
import 'package:first_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

class ConnectedProducts extends Model{
  List<Product> products = [];
  User authenticatedUser;
  int selProductIndex;

  void addProduct(String title , String description , double price , String image ) {
    final newProduct = Product(title: title, description: description , price: price , image:  image  , userEmail: authenticatedUser.email , userId: authenticatedUser.id );
    products.add(newProduct);
    selProductIndex = null;
  }
}