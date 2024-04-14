import 'package:flutter/material.dart';
import 'package:graduation_project/services/Firebase/item_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/component/empty_page.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/component/page_after_post.dart';
import 'package:provider/provider.dart';

class HomePageSeller extends StatefulWidget {
  const HomePageSeller({Key? key}) : super(key: key);

  @override
  State<HomePageSeller> createState() => _HomePageSellerState();
}

class _HomePageSellerState extends State<HomePageSeller> {
  @override
  Widget build(BuildContext context) {
    ItemFirestore items = Provider.of<ItemFirestore>(context);
    SellerFirestore seller = Provider.of<SellerFirestore>(context);

    return StreamBuilder<int>(
      stream: items.getItemCountForSellerStream(seller.seller?.sellerId ?? ''),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          int count = snapshot.data ?? 0;
          int index = count > 0 ? 1 : 0;
          return IndexedStack(
            index: index,
            children: const [EmptyPagePost(), PageAfterCreatePost()],
          );
        }
      },
    );
  }
}
