class ItemModel {
  ItemModel(
      {this.sellerId,
      this.itemId,
      this.description,
      this.title,
      this.price,
      this.image});

  String? sellerId;
  String? itemId;
  String? title;
  String? price;
  String? description;
  String? image;

  ItemModel.fromMap(Map<String, dynamic> data)
      : assert(data.isNotEmpty),
        sellerId = data['sellerId'],
        itemId = data['itemId'],
        title = data['title'],
        price = data['price'],
        image = data['image'],
        description = data['description'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerId'] = sellerId;
    data['itemId'] = itemId;
    data['title'] = title;
    data['price'] = price;
    data['image'] = image;
    data['description'] = description;
    return data;
  }
}
