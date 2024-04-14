import 'package:flutter/material.dart';

class RadiusSelectSellerOrBuyer extends StatelessWidget {
  const RadiusSelectSellerOrBuyer({super.key, required this.user});
  final String user;

  @override
  Widget build(BuildContext context) {
    return Container(
      // width: MediaQuery.of(context).size.width / 2,
      // height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
          gradient: const LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
          borderRadius: BorderRadius.circular(100)),
      alignment: Alignment.center,
      child: Text(user,
          style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900)),
    );
  }
}
