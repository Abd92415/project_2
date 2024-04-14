import 'dart:collection';

import 'package:graduation_project/Models/data_post.dart';
import 'package:graduation_project/services/constant/path_images.dart';

class ControllerDataPost {
  static final List<DataPost> _dataPost = [
    DataPost(
        title: 'Product title DB',
        price: 100,
        description: 'description ',
        imageProduct: PathImage.clothes1),
    DataPost(
        title: 'Product title DB2',
        price: 10,
        description: 'description2 ',
        imageProduct: PathImage.clothes2)
  ];
  //**this is list : take copy from list(dataPost)
  static UnmodifiableListView<DataPost> get _dataList =>
      UnmodifiableListView(_dataPost);
  //* this is variable return number of product from server
  static int get dataLength => _dataList.length;

  static DataPost getNews(int index) => _dataList.elementAt(index);
}
