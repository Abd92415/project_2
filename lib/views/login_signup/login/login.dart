import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/views/home/sellerHome/pagehome.dart';
import 'package:graduation_project/views/login_signup/component/text_pass.dart';
import 'package:graduation_project/views/login_signup/component/text_username.dart';
import 'package:graduation_project/views/login_signup/login/forgot_password.dart';
import 'package:graduation_project/views/login_signup/signup/body.dart';
import 'package:graduation_project/views/login_signup/signup/component/verifiication/verify.dart';
import 'package:provider/provider.dart';

import '../../home/buyerHome/home_page.dart';
import '../../../services/language/generated/key_lang.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.deepPurple[400],
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.only(top: 80),
                        child: const Text(
                          'Welcome Back!',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(80),
                        topRight: Radius.circular(80),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 40),
                          TextFieldUseAll(
                            hint: KeyLang.email,
                            iconuse: Icons.person,
                            type: TextInputType.emailAddress,
                            controller: emailController,
                          ),
                          const SizedBox(height: 20),
                          TextFieldPassword(
                            KeyLang.password,
                            passwordController,
                          ),
                          const SizedBox(height: 30),
                          ElevatedButton(
                            onPressed: () async {
                              User? user = await auth.login(
                                emailController.text,
                                passwordController.text,
                              );
                              if (user != null) {
                                if (user.emailVerified) {
                                  final isBuyer =
                                      await buyer.isBuyer(user.email ?? '');
                                  if (isBuyer) {
                                    buyer.loadBuyerData();
                                    if (mounted) {
                                      await Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PageHomeBuyer(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  }
                                  final isSeller =
                                      await seller.isSeller(user.email ?? '');
                                  if (isSeller) {
                                    seller.loadSellerData();
                                    if (mounted) {
                                      await Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PageHomeSeller(),
                                        ),
                                        (Route<dynamic> route) => false,
                                      );
                                    }
                                  }
                                } else {
                                  auth.sendVerificationEmail();
                                  if (mounted) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Pageverified(
                                            email: user.email ?? ''),
                                      ),
                                    );
                                  }
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
                                print('Seller login failed');
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurple,
                              padding: const EdgeInsets.symmetric(
                                vertical: 15,
                                horizontal: 30,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              KeyLang.login,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          //* forgot password
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ForgotPassword(
                                    email: emailController.text,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Forgot Your Password? Reset',
                              style: TextStyle(
                                color: Colors.deepPurple[400],
                                fontSize: 15,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const SelectBuyerOrSeller(),
                                ),
                              );
                            },
                            child: Text(
                              "Don't Have an Account? Sign Up",
                              style: TextStyle(
                                  color: Colors.deepPurple[400], fontSize: 15),
                            ),
                          ),
                        ],
                      ),
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
