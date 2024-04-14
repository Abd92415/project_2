import '../../../services/constant/path_images.dart';
import '../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';

class PageFood extends StatelessWidget {
  const PageFood({super.key});

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Column(
        children: [
          Image(image: AssetImage(PathImage.userImage)),
          Text(
            KeyLang.seller,
            style: TextStyle(color: Colors.black),
          )
        ],
      ),
    );
  }
}
