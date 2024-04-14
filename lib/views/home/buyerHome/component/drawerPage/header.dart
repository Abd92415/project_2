import '../../../../../services/constant/path_images.dart';
import '../../../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';

class HeaderDrawer extends StatelessWidget {
  const HeaderDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        //******************************Image USer from server */
        Container(
          margin: const EdgeInsets.only(top: 60),
          width: 150,
          height: 150,
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(PathImage.userImage), fit: BoxFit.fill),
              shape: BoxShape.circle),
        )

        //******************************name User from server */
        ,
        const SizedBox(height: 10),
        const Text(KeyLang.userName),

        const Divider()
      ],
    );
  }
}
