import '../../../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';

class ServicesDrawer extends StatelessWidget {
  const ServicesDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ListTile(leading: Icon(Icons.home), title: Text('Home')),
        ListTile(
            leading: Icon(Icons.shopping_cart_sharp), title: Text('cart shop')),
        ListTile(leading: Icon(Icons.dark_mode), title: Text(KeyLang.dark)),
        ListTile(leading: Icon(Icons.settings), title: Text('Setting'))
      ],
    );
  }
}
