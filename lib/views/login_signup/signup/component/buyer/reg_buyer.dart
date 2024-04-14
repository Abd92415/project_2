import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/views/login_signup/signup/component/verifiication/verify.dart';
import 'package:provider/provider.dart';

import '../../../component/button.dart';
import '../../../component/text_username.dart';
import '../../../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../../services/themes/app_color.dart';
import '../../../component/text_pass.dart';
import '../../../login/login.dart';

class RegisterBuyer extends StatefulWidget {
  const RegisterBuyer({super.key});

  @override
  State<RegisterBuyer> createState() => _RegisterBuyerState();
}

class _RegisterBuyerState extends State<RegisterBuyer> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple[400],
          title: Text('Request a service',
              style: TextStyle(color: AppColors.bgwhite)),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: AppColors.bgwhite,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: Form(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        //*textFiald : fill the name user
                        TextFieldUseAll(
                            controller: nameController,
                            hint: KeyLang.userName,
                            iconuse: Icons.person,
                            type: TextInputType.name),
                        const SizedBox(height: 10),
                        //************************textField :email user */
                        TextFieldUseAll(
                          controller: emailController,
                          hint: KeyLang.email,
                          iconuse: Icons.email,
                          type: TextInputType.emailAddress,
                        ),

                        //**********************************************Textfailed password and confirm
                        const SizedBox(height: 10),
                        TextFieldPassword(KeyLang.password, passwordController),
                        const SizedBox(height: 10),

                        //************************************************************button login

                        const SizedBox(height: 40),
                        InkWell(
                            onTap: () async {
                              User? user = await auth.signUp(
                                  emailController.text,
                                  passwordController.text);
                              if (user != null) {
                                // ignore: avoid_print
                                print(
                                    'Buyer signed up successfully: ${user.uid}');
                                await buyer.addBuyer(
                                    username: nameController.text,
                                    email: emailController.text,
                                    uid: user.uid);
                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Pageverified(
                                          email: auth.currentUser.email ?? ''),
                                    ),
                                  );
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: auth.errorMessage.split(']')[1],
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                    timeInSecForIosWeb: 50,
                                    backgroundColor: Colors.red,
                                    textColor: Colors.white,
                                    fontSize: 16.0);
                                // ignore: avoid_print
                                print('Buyer sign up failed');
                              }
                            },
                            child: const Button(textButton: KeyLang.signup)),
                        SizedBox(
                          width: MediaQuery.of(context).size.width / 1.5,
                          child: const Divider(color: Colors.grey, height: 2),
                        ),
                        InkWell(
                          onTap: () {
                            var route = MaterialPageRoute(
                                builder: (context) => const LoginPage());
                            Navigator.push(context, route);
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.bottomCenter,
                            child: const Text(
                              'Already have account? Login',
                              style: TextStyle(
                                  color: Colors.deepPurple, fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
