import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/seller_chats_page.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/s_home.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/s_profile.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/seller_orders_page.dart';

class PageHomeSeller extends StatefulWidget {
  const PageHomeSeller({super.key});

  @override
  State<PageHomeSeller> createState() => _PageHomeSellerState();
}

class _PageHomeSellerState extends State<PageHomeSeller> {
  int indexPage = 0;
  static List<Widget> pageSelect = [
    const HomePageSeller(),
    const SellerOrdersPage(),
    const SellerChatsPage(),
    const ProfilePageSeller()
  ];
  static List<String> pageTitle = [
    'Home',
    'Orders',
    'Chat',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      appBar: appBarSeller(),
      body: pageSelect[indexPage],
      bottomNavigationBar: navigationButtonSeller(),
    );
  }

  AppBar appBarSeller() {
    return AppBar(
      elevation: 10,
      title: Text(pageTitle[indexPage]),
      // actions: const [
      //   CircleAvatar(backgroundImage: AssetImage(PathImage.splashPhoto)),
      // ],
      backgroundColor: Colors.deepPurple[400],
    );
  }

  ConvexAppBar navigationButtonSeller() {
    return ConvexAppBar(
      backgroundColor: Colors.deepPurple[400],
      elevation: 10,
      initialActiveIndex: indexPage,
      items: [
        TabItem(
            icon: Icon(Icons.home,
                color: indexPage == 0 ? Colors.deepPurple[400] : Colors.white),
            title: 'Home'),
        TabItem(
            icon: Icon(Icons.list,
                color: indexPage == 1 ? Colors.deepPurple[400] : Colors.white),
            title: 'Orders'),
        TabItem(
            icon: Icon(Icons.message,
                color: indexPage == 2 ? Colors.deepPurple[400] : Colors.white),
            title: 'chat'),
        TabItem(
            icon: Icon(Icons.people,
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
