class BuyerModel {
  BuyerModel({
    this.email,
    this.username,
    this.cart,
    this.profilePicture,
    this.chats,
    this.buyerId,
    this.buyerUID,
  });

  String? email;
  String? buyerId;
  String? buyerUID;
  String? username;
  List<dynamic>? cart;
  List<dynamic>? chats;
  String? profilePicture;

  BuyerModel.fromMap(Map<String, dynamic> data)
      : assert(data.isNotEmpty),
        email = data['email'],
        buyerId = data['buyerId'],
        buyerUID = data['buyerUID'],
        username = data['username'],
        cart = data['cart'],
        chats = data['chats'],
        profilePicture = data['profilePicture'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['email'] = email;
    data['buyerId'] = buyerId;
    data['buyerUID'] = buyerUID;
    data['username'] = username;
    data['cart'] = cart;
    data['chats'] = chats;
    data['profilePicture'] = profilePicture;
    return data;
  }
}
