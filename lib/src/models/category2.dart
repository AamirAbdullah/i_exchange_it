import 'package:iExchange_it/src/models/images.dart';

class CategorySearch {
  var id;
  var name;
  var type;
  var price;
  var country;
  List<Images>? images;
  CategorySearch({this.id, this.name,
  this.country,this.price,this.type,this.images});
}
