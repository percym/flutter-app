import 'package:scoped_model/scoped_model.dart';
import 'package:first_app/scoped-models/product.dart';
import 'package:first_app/scoped-models/user.dart';


class MainModel extends Model with UserModel, ProductsModel {

}