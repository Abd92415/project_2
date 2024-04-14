import 'package:flutter/material.dart';
import 'package:graduation_project/services/constant/path_images.dart';
import 'package:graduation_project/views/home/sellerHome/component/pageNav/component/sheet_data_product.dart';
import 'package:graduation_project/views/login_signup/component/button.dart';

class EmptyPagePost extends StatelessWidget {
  const EmptyPagePost({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(image: AssetImage(PathImage.postEmpty)),
            Text(
              'You don\'t have any post',
              style: TextStyle(
                color: Colors.deepPurple[400],
              ),
            ),
            Text(
              'create post by tapping the button below.',
              style: TextStyle(
                color: Colors.deepPurple[400],
              ),
            ),
            const SizedBox(height: 25),
            InkWell(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (BuildContext context) {
                      return const BottomSheetAdd();
                    });
              },
              child: const Button(textButton: 'Create Post'),
            )
          ],
        ),
      ),
    );
  }
}
