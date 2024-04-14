import '../../../../../services/themes/app_color.dart';
import 'package:flutter/material.dart';

class Categories extends StatefulWidget {
  const Categories({super.key});

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  static List<String> categories = [
    'All',
    'Food',
    'Clothes',
    'Parfune',
    'Sweet'
  ];
  // final List<Widget> _page = const [PageAll(), PageFood(), PageClothes()];
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.prColorblue,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: SizedBox(
              height: 25,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) => builderCategory(index),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget builderCategory(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              categories[index],
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: selectedIndex == index
                      ? AppColors.kTextColor
                      : AppColors.kTextlightColor),
            ),
            Container(
              margin: const EdgeInsets.only(top: 5),
              height: 2,
              width: 30,
              color: selectedIndex == index ? Colors.black : Colors.transparent,
            )
          ],
        ),
      ),
    );
  }
}
