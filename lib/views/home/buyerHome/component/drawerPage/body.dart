import 'services.dart';

import 'package:flutter/material.dart';

import 'header.dart';

class DrawerList extends StatelessWidget {
  const DrawerList({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10,
      backgroundColor: Colors.grey[350],
      child: const Column(
        children: [
          //**************************************Header********************************* */
          HeaderDrawer(),

          //*****************************************services*************************** */
          ServicesDrawer(),
        ],
      ),
    );
  }
}
