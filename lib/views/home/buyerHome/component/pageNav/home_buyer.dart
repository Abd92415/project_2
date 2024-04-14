import 'package:flutter/material.dart';
import 'package:graduation_project/Models/seller_model.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/buyer_chat_page.dart';
import 'item_card.dart';
import 'package:graduation_project/services/Firebase/item_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/Models/item_model.dart';
import 'package:provider/provider.dart';

class HomePageBuyer extends StatefulWidget {
  const HomePageBuyer({super.key});

  @override
  State<HomePageBuyer> createState() => _HomePageBuyerState();
}

class _HomePageBuyerState extends State<HomePageBuyer> {
  final TextEditingController searchController = TextEditingController();
  String selectedCategory = 'All';
  List<SellerModel> sellers = [];

  List<SellerModel> filterSellers(
      String searchText, List<SellerModel> sellers) {
    return sellers
        .where((seller) => seller.projectName!
            .toLowerCase()
            .contains(searchText.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final List<String> categories = [
      'All',
      'Food',
      'Sweets',
      'Clothes',
      'Perfumes',
      'Hand Made',
    ];

    return Scaffold(
      appBar: bulidAppBar(context),
      body: Column(
        children: [
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: Colors.deepPurple,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                  },
                  child: Text(categories[index]),
                );
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SellerModel>>(
              future: selectedCategory == 'All'
                  ? seller.getAllSellers()
                  : seller.getSellersByCategory(selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text('No sellers available.'),
                  );
                } else {
                  sellers = snapshot.data!;
                  sellers = filterSellers(searchController.text, sellers);
                  return sellers.isEmpty
                      ? const Center(
                          child: Text(
                            'There is no sellers',
                            style: TextStyle(color: Colors.deepPurple),
                          ),
                        )
                      : ListView.builder(
                          itemCount: sellers.length,
                          itemBuilder: (context, index) {
                            SellerModel sellerModel = sellers[index];
                            return Card(
                              elevation: 3,
                              margin: const EdgeInsets.all(10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          SellerItemsPage(seller: sellerModel),
                                    ),
                                  );
                                },
                                child: ListTile(
                                  contentPadding: const EdgeInsets.all(16),
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    backgroundImage: sellerModel
                                                .profilePicture !=
                                            ''
                                        ? NetworkImage(
                                            sellerModel.profilePicture ?? '')
                                        : const AssetImage(
                                                'assets/images/defaultAvatar.png')
                                            as ImageProvider,
                                  ),
                                  title: Text(
                                    sellerModel.projectName ?? '',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 8),
                                      Text(
                                        'Username: ${sellerModel.username}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Category: ${sellerModel.category}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  trailing: Container(
                                    decoration: const BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50))),
                                    child: IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, BuyerChatPage.routeName,
                                            arguments: {
                                              'personUID':
                                                  sellerModel.sellerUID,
                                              'sellerID': sellerModel.sellerId,
                                              'username': sellerModel.username,
                                              'chats': sellerModel.chats,
                                            });
                                      },
                                      icon: const Icon(
                                        Icons.send,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  AppBar bulidAppBar(context) {
    return AppBar(
      title: searchText(context),
      centerTitle: true,
      backgroundColor: Colors.deepPurple[400],
    );
  }

  Container searchText(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[350],
        borderRadius: const BorderRadius.all(
          Radius.circular(15),
        ),
      ),
      width: MediaQuery.of(context).size.width / 2,
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          setState(() {
            sellers = [];
          });
        },
        decoration: InputDecoration(
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.deepPurple[400],
          ),
          icon: Icon(
            Icons.search,
            color: Colors.deepPurple[400],
          ),
          border: InputBorder.none,
        ),
        style: const TextStyle(color: Colors.black),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}

class SellerItemsPage extends StatefulWidget {
  final SellerModel seller;

  const SellerItemsPage({required this.seller, super.key});

  @override
  State<SellerItemsPage> createState() => _SellerItemsPageState();
}

class _SellerItemsPageState extends State<SellerItemsPage> {
  @override
  Widget build(BuildContext context) {
    final ItemFirestore items = Provider.of<ItemFirestore>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[400],
        title: Text(
          '${widget.seller.projectName}',
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: StreamBuilder<List<ItemModel>>(
        stream: items.getItemsForSellerStream(widget.seller.sellerId ?? ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No items available.',
                style: TextStyle(color: Colors.deepPurple),
              ),
            );
          } else {
            List<ItemModel> items = snapshot.data!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                ItemModel item = items[index];
                return ItemCard(item: item);
              },
            );
          }
        },
      ),
    );
  }
}
