class OrderModel {
  OrderModel(
      {this.buyerId,
      this.sellerId,
      this.orderId,
      this.items,
      this.orderStatus,
      this.buyerName,
      this.projectName,
      this.notes});

  String? sellerId;
  String? buyerId;
  String? orderId;
  String? buyerName;
  String? projectName;
  String? orderStatus;
  String? notes;
  List<dynamic>? items;

  OrderModel.fromMap(Map<String, dynamic> data)
      : assert(data.isNotEmpty),
        sellerId = data['sellerId'],
        buyerId = data['buyerId'],
        orderId = data['orderId'],
        orderStatus = data['orderStatus'],
        buyerName = data['buyerName'],
        projectName = data['projectName'],
        notes = data['notes'],
        items = data['items'];

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['sellerId'] = sellerId;
    data['buyerId'] = buyerId;
    data['orderId'] = orderId;
    data['orderStatus'] = orderStatus;
    data['buyerName'] = buyerName;
    data['projectName'] = projectName;
    data['notes'] = notes;
    data['items'] = items;
    return data;
  }
}
