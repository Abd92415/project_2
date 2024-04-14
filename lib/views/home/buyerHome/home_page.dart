import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/cart_buyer.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/buyer_chats_page.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/home_buyer.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/buyer_orders_page.dart';
import 'package:graduation_project/views/home/buyerHome/component/pageNav/profile_buyer.dart';
import 'package:flutter/material.dart';

class PageHomeBuyer extends StatefulWidget {
  const PageHomeBuyer({super.key});

  @override
  State<PageHomeBuyer> createState() => _PageHomeBuyerState();
}

class _PageHomeBuyerState extends State<PageHomeBuyer> {
  int indexPage = 0;
  late List<Widget> pageNav;
  static List<String> pageTitle = [
    '',
    'Orders',
    'Chats',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    pageNav = [
      const HomePageBuyer(),
      const BuyerOrdersPage(),
      const BuyerChatsPage(),
      const ProfilePageBuyer(),
    ];

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey[350],
        appBar: indexPage != 0 ? bulidAppBar(context) : null,
        body: pageNav[indexPage],
        floatingActionButton: indexPage == 0
            ? FloatingActionButton.extended(
                backgroundColor: Colors.deepPurple,
                label: const Text('Cart'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CartPageBuyer(),
                    ),
                  );
                },
                icon: const Icon(
                  Icons.shopping_cart,
                  size: 25,
                ),
              )
            : null,
        bottomNavigationBar: covexBottomNav(),
      ),
    );
  }

  AppBar bulidAppBar(context) {
    return AppBar(
      title: Text(pageTitle[indexPage]),
      centerTitle: true,
      backgroundColor: Colors.deepPurple[400],
    );
  }

  ConvexAppBar covexBottomNav() {
    return ConvexAppBar(
      backgroundColor: Colors.deepPurple[400],
      elevation: 10,
      initialActiveIndex: indexPage,
      items: [
        TabItem(
            icon: Icon(Icons.home,
                size: 25,
                color: indexPage == 0 ? Colors.deepPurple[400] : Colors.white),
            title: 'Home'),
        TabItem(
            icon: Icon(Icons.list,
                size: 25,
                color: indexPage == 1 ? Colors.deepPurple[400] : Colors.white),
            title: 'Orders'),
        TabItem(
            icon: Icon(Icons.message,
                size: 25,
                color: indexPage == 2 ? Colors.deepPurple[400] : Colors.white),
            title: 'Chats'),
        TabItem(
            icon: Icon(Icons.person,
                size: 25,
                color: indexPage == 3 ? Colors.deepPurple[400] : Colors.white),
            title: 'Profile')
      ],
      onTap: (int value) {
        setState(() {
          indexPage = value;
        });
      },
    );
  }
}
