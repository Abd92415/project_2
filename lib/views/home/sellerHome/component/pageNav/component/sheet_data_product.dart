import 'dart:io';

import 'package:flutter/material.dart';
import 'package:graduation_project/services/Firebase/item_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/views/login_signup/component/button.dart';
import 'package:graduation_project/views/login_signup/component/text_username.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class BottomSheetAdd extends StatefulWidget {
  const BottomSheetAdd({super.key});

  @override
  State<BottomSheetAdd> createState() => _BottomSheetAddState();
}

class _BottomSheetAddState extends State<BottomSheetAdd> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController imageController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);
    final ItemFirestore item = Provider.of<ItemFirestore>(context);
    return SingleChildScrollView(
      child: Container(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Add New Product',
                style: TextStyle(color: Colors.black, fontSize: 20),
              ),
            ),
            const SizedBox(height: 15),
            //*name product
            TextFieldUseAll(
              hint: 'Title',
              iconuse: Icons.post_add,
              type: TextInputType.text,
              controller: titleController,
            ),
            const SizedBox(height: 15),
            //*price product
            TextFieldUseAll(
              hint: 'Enter price product',
              iconuse: Icons.attach_money_outlined,
              controller: priceController,
              type: TextInputType.number,
            ),
            const SizedBox(height: 15),
            //*description for product
            TextFieldUseAll(
              hint: 'Enter a description here',
              iconuse: Icons.description,
              controller: descriptionController,
              type: TextInputType.text,
            ),
            const SizedBox(height: 15),
            //*url Image convert to image picker

            //********************************************************************image picker */
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Text('Add image for product'),
                //*button gallery
                ElevatedButton(
                  onPressed: () async {
                    selectImageFromGallery();
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple)),
                  child: const Text(
                    'Gallary',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                //*button camera
                ElevatedButton(
                  onPressed: () async {
                    selectImageFromCamera();
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.deepPurple)),
                  child: const Text(
                    'Camera',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),

            // TextFieldUseAll(
            //   hint: ' + add image your product ',
            //   iconuse: Icons.image,
            //   controller: imageController,
            //   type: TextInputType.text,
            // ),
            // const SizedBox(height: 15),

            //*****************************************************************************************

            //*row contains two button cancel and add post
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: const Button(textButton: 'Cancel'),
                ),
                InkWell(
                  onTap: () async {
                    await item.addItem(
                        description: descriptionController.text,
                        image: imageController.text,
                        // TO DO :can't pass widget
                        // image: _selectedImage != null
                        //     ? Image.file(_selectedImage!)
                        //     : Text(''),
                        price: priceController.text,
                        sellerId: seller.seller?.sellerId,
                        title: titleController.text);
                    // ignore: use_build_context_synchronously
                    Navigator.pop(context);
                  },
                  child: const Button(textButton: 'Add Post'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future selectImageFromGallery() async {
    XFile? RImagefromGallery =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (RImagefromGallery == null) return;
    setState(() {
      _selectedImage = File(RImagefromGallery!.path);
      // pathImage = RImagefromGallery.path;
    });
  }

  Future selectImageFromCamera() async {
    XFile? RImageFromCamera =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (RImageFromCamera == null) return;
    setState(() {
      _selectedImage = File(RImageFromCamera!.path);
    });
  }
}
