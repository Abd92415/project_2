import 'package:flutter/material.dart';
import 'package:graduation_project/Models/item_model.dart';
import 'package:graduation_project/services/Firebase/item_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/views/login_signup/login/login.dart';
import 'package:provider/provider.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.item});
  final ItemModel item;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  int count = 1;

  void _openImageDialog(String image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Image.network(
            image,
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ItemFirestore items = Provider.of<ItemFirestore>(context);
    final UserAuth user = Provider.of<UserAuth>(context);

    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            children: [
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  image: DecorationImage(
                    image: NetworkImage(widget.item.image ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  _openImageDialog(widget.item.image ?? '');
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[500]!.withOpacity(0.6),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.open_in_full_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.item.title ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.deepPurple[400],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${widget.item.price} JD',
                  style: const TextStyle(
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  widget.item.description ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (count > 1) {
                                count -= 1;
                              }
                            });
                          },
                          icon: const Icon(Icons.remove),
                        ),
                        Text(
                          '$count',
                          style: const TextStyle(color: Colors.deepPurple),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              count += 1;
                            });
                          },
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                      ),
                      onPressed: () {
                        if (user.currentUser.email != null &&
                            user.currentUser.email != '') {
                          if (items.items.isNotEmpty) {
                            if (items.items[0]['sellerId'] ==
                                widget.item.sellerId) {
                              final temp = items.items;
                              bool found = false;
                              for (int i = 0; i < temp.length; i++) {
                                if (temp[i]['itemId'] == widget.item.itemId) {
                                  temp[i]['count'] += count;
                                  found = true;
                                  break;
                                }
                              }
                              if (!found) {
                                temp.add(
                                    {...widget.item.toMap(), 'count': count});
                              }
                              items.updateItems(temp);
                            } else {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'You can\'t add product to cart from two sellers in same time\nClear the cart first',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.deepPurple[400],
                                        ),
                                      ),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.deepPurple,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Ok"),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                          } else {
                            final temp = items.items;
                            bool found = false;
                            for (int i = 0; i < temp.length; i++) {
                              if (temp[i]['itemId'] == widget.item.itemId) {
                                temp[i]['count'] += count;
                                found = true;
                                break;
                              }
                            }
                            if (!found) {
                              temp.add(
                                  {...widget.item.toMap(), 'count': count});
                            }
                            items.updateItems(temp);
                          }
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'You should be logged in to add item to cart',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.deepPurple[400],
                                    ),
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.deepPurple,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    },
                                    child: const Text("Login"),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Add to Cart',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
