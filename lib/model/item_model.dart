
class ItemModel {

  final String id;
  final String name;
  final String price;
  final String detail;
  final String imageUrl;
  final String category;

  ItemModel( { required this.category,required this.id, required this.name, required this.price, required this.detail, required this.imageUrl});

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "price": price,
      "detail": detail,
      "category": category,
      "imageUrl":imageUrl
    };
  }

}