import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/Models/order_model.dart';

class OrderFirestore extends ChangeNotifier {
  final CollectionReference _orderCollection =
      FirebaseFirestore.instance.collection('Orders');
  OrderModel? order;
  List<dynamic> orders = [];
  bool isLoading = false;
  String errorMessage = '';

  set setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  set setMessage(String value) {
    errorMessage = value;
    notifyListeners();
  }

  Future<void> addOrder(
      {sellerId,
      buyerId,
      orderstatus,
      items,
      projectName,
      buyerName,
      notes}) async {
    Map<String, dynamic> orderData = {
      'sellerId': sellerId,
      'buyerId': buyerId,
      'items': items,
      'orderStatus': orderstatus,
      'buyerName': buyerName,
      'projectName': projectName,
      'notes': notes,
    };
    DocumentReference docRef = await _orderCollection.add(orderData);
    String orderId = docRef.id;
    await _orderCollection.doc(orderId).update({'orderId': orderId});
  }

  Stream<List<OrderModel>> getOrdersForBuyerStream(String buyerId) {
    return _orderCollection
        .where('buyerId', isEqualTo: buyerId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data);
      }).toList();
    });
  }

  Stream<List<OrderModel>> getOrdersForSellerStream(String sellerId) {
    return _orderCollection
        .where('sellerId', isEqualTo: sellerId)
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return OrderModel.fromMap(data);
      }).toList();
    });
  }

  Future<void> updateOrderStatus(String orderId, String newOrderStatus) async {
    try {
      await _orderCollection.doc(orderId).update({
        'orderStatus': newOrderStatus,
      });
      print('Order status updated successfully.');
    } catch (error) {
      print('Error updating order status: $error');
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _orderCollection.doc(orderId).delete();
      print('Order deleted successfully.');
    } catch (error) {
      print('Error deleting order: $error');
    }
  }
}
