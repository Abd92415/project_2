import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/item_firestore.dart';
import 'package:graduation_project/services/Firebase/order_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:provider/provider.dart';

class CartPageBuyer extends StatefulWidget {
  const CartPageBuyer({super.key});

  @override
  State<CartPageBuyer> createState() => _CartPageBuyerState();
}

class _CartPageBuyerState extends State<CartPageBuyer> {
  final TextEditingController notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ItemFirestore items = Provider.of<ItemFirestore>(context);
    final OrderFirestore orders = Provider.of<OrderFirestore>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);

    double totalPrice = 0;
    for (var item in items.items) {
      double itemPrice = item['price'] is int
          ? (item['price'] as int).toDouble()
          : double.parse(item['price'].toString());

      double itemCount = item['count'] is int
          ? (item['count'] as int).toDouble()
          : double.parse(item['count'].toString());

      totalPrice += itemPrice * itemCount;
    }

    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Shopping Cart',
                  style: TextStyle(fontSize: 25, color: Colors.black),
                ),
                const SizedBox(height: 5),
                Text(
                  'Total(${items.items.length}) Items',
                  style: const TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 15),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 450,
                  child: ListView.builder(
                    itemCount: items.items.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Card(
                            elevation: 10,
                            child: ListTile(
                              leading: Image(
                                image: NetworkImage(
                                    items.items[index]['image'] ?? ''),
                              ),
                              title: Text(
                                items.items[index]['title'] ?? '',
                                style: const TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(
                                  'Price (${items.items[index]['price']}) JD'),
                              trailing: SizedBox(
                                height: 50,
                                width: 80,
                                child: CounterItem(
                                  index: index,
                                  items: items,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 5,
                            child: InkWell(
                              onTap: () {
                                final temp = items.items;
                                temp.removeAt(index);
                                items.updateItems(temp);
                              },
                              child: Container(
                                width: 25,
                                height: 25,
                                decoration: const BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.close),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Total price',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                    Text(
                      '($totalPrice) JD',
                      style: const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: notesController,
                  decoration: InputDecoration(
                    labelText: 'Any Notes ?',
                    labelStyle: const TextStyle(color: Colors.black),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: items.items.isEmpty
                      ? null
                      : () async {
                          final projectName =
                              await seller.getProjectNameBySellerId(
                                  items.items[0]['sellerId'] ?? '');
                          await orders.addOrder(
                            buyerId: buyer.buyer?.buyerId,
                            sellerId: items.items[0]['sellerId'],
                            items: items.items,
                            orderstatus: 'Pending',
                            buyerName: buyer.buyer?.username,
                            projectName: projectName,
                            notes: notesController.text,
                          );
                          items.items.removeWhere((element) => true);
                          items.updateItems(items.items);
                          Fluttertoast.showToast(
                            msg: 'Your order has been sent',
                            toastLength: Toast.LENGTH_LONG,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    fixedSize: const Size.fromWidth(
                        200), // You can adjust the width as needed
                  ),
                  child: const Text(
                    'Make order',
                    style: TextStyle(
                        fontSize: 18), // You can adjust the font size as needed
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CounterItem extends StatefulWidget {
  const CounterItem({super.key, required this.index, required this.items});
  final int index;
  final ItemFirestore items;

  @override
  State<CounterItem> createState() => _CounterItemState();
}

class _CounterItemState extends State<CounterItem> {
  @override
  Widget build(BuildContext context) {
    int counter = widget.items.items[widget.index]['count'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        InkWell(
          onTap: () {
            setState(() {
              if (counter > 1) {
                final temp = widget.items.items;
                temp[widget.index]['count']--;
                widget.items.updateItems(temp);
              }
            });
          },
          child: Container(
            alignment: Alignment.center,
            child: const Icon(Icons.remove),
          ),
        ),
        Container(
          color: Colors.black.withOpacity(0.2),
          width: 30,
          height: 30,
          alignment: Alignment.center,
          child: Text(
            '$counter',
            style: const TextStyle(fontSize: 18, color: Colors.black),
          ),
        ),
        InkWell(
          onTap: () {
            final temp = widget.items.items;
            temp[widget.index]['count']++;
            widget.items.updateItems(temp);
          },
          child: Container(
            alignment: Alignment.center,
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
