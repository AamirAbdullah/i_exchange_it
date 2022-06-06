class Item {

  var id;
  String? title;
  String? description;
  String? image;
  bool? isFeatured = true;
  var price;
  var rating;
  var totalReviews;
  var type;//0=free, 1=for sale, 2=exchange
  var location;
  var address;
  var condition;//0=new, 1=used
  bool? isFavorite = true;

  Item({this.id, this.title, this.description, this.price, this.address,
    this.isFeatured, this.image, this.isFavorite,
    this.rating, this.totalReviews, this.type, this.location, this.condition});

}