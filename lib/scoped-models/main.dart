import 'package:first_app/scoped-models/connected_products.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:first_app/scoped-models/product.dart';
import 'package:first_app/scoped-models/user.dart';


class MainModel extends Model with ConnectedProducts, UserModel, ProductsModel {

}