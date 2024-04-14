import 'package:flutter/material.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/services/constant/path_images.dart';
import 'package:graduation_project/views/login_signup/component/button.dart';
import 'package:graduation_project/views/login_signup/login/login.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class ProfilePageBuyer extends StatefulWidget {
  const ProfilePageBuyer({super.key});

  @override
  State<ProfilePageBuyer> createState() => _ProfilePageBuyerState();
}

class _ProfilePageBuyerState extends State<ProfilePageBuyer> {
  @override
  Widget build(BuildContext context) {
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final UserAuth user = Provider.of<UserAuth>(context);
    TextEditingController usernameController = TextEditingController();
    usernameController.text =
        user.currentUser.email != null && user.currentUser.email != ''
            ? buyer.buyer?.username ?? ''
            : '';

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    clipBehavior: Clip.antiAlias,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(100)),
                    child: Image(
                      fit: BoxFit.fill,
                      image: user.currentUser.email != null &&
                              user.currentUser.email != ''
                          ? buyer.buyer?.profilePicture != ''
                              ? NetworkImage(buyer.buyer?.profilePicture ?? '')
                                  as ImageProvider
                              : const AssetImage(PathImage.userImage)
                          : const AssetImage(PathImage.userImage),
                    ),
                  ),
                  user.currentUser.email != null && user.currentUser.email != ''
                      ? Positioned(
                          bottom: 0,
                          right: 0,
                          child: SizedBox(
                            height: 46,
                            width: 46,
                            child: ElevatedButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Change Profile Picture',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 4),
                                      content: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                buyer.pickGalleryImage();
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(Icons.image),
                                              label: const Text(
                                                  'Sellect From Gallery'),
                                            ),
                                            const SizedBox(height: 12),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.deepPurple,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                              ),
                                              onPressed: () {
                                                buyer.pickCameraImage();
                                                Navigator.pop(context);
                                              },
                                              icon: const Icon(
                                                  Icons.photo_camera),
                                              label:
                                                  const Text('Take a Picture'),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                shape: const CircleBorder(),
                                padding: EdgeInsets.zero,
                              ),
                              child: const Icon(
                                Icons.photo_camera_rounded,
                                size: 20,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                user.currentUser.email != null && user.currentUser.email != ''
                    ? buyer.buyer?.username ?? ''
                    : 'Username',
                style: const TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Text(
                user.currentUser.email != null && user.currentUser.email != ''
                    ? buyer.buyer?.email ?? ''
                    : 'Email',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              const SizedBox(height: 15),
              user.currentUser.email != null && user.currentUser.email != ''
                  ? InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextField(
                                      style:
                                          const TextStyle(color: Colors.black),
                                      controller: usernameController,
                                      decoration: InputDecoration(
                                        labelText: 'Username',
                                        labelStyle: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: const BorderSide(
                                              color: Colors.deepPurple),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.deepPurple,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      onPressed: () async {
                                        await buyer.updateBuyerData(
                                          username: usernameController.text,
                                        );
                                        if (mounted) {
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: const Button(textButton: 'Edit Profile'),
                    )
                  : Container(),
              ProfileMenuWidget(
                  title: user.currentUser.email != null &&
                          user.currentUser.email != ''
                      ? 'Log Out'
                      : 'Login',
                  icon: Icons.logout,
                  endIcon: false)
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget(
      {super.key,
      required this.title,
      required this.icon,
      this.endIcon = true});
  final String title;
  final IconData icon;
  // final Function onPress;
  final bool endIcon;

  @override
  Widget build(BuildContext context) {
    UserAuth auth = Provider.of<UserAuth>(context);

    return ListTile(
        onTap: () async {
          if (title == 'Log Out') {
            await auth.signOut();
            if (context.mounted) {
              Phoenix.rebirth(context);
            }
          } else if (title == 'Login') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          }
        },
        leading: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.grey[350],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon)),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.deepPurple,
          ),
        ),
        trailing: endIcon
            ? Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.grey[300]),
                child:
                    const Icon(Icons.arrow_right, color: Colors.grey, size: 18),
              )
            : null);
  }
}
