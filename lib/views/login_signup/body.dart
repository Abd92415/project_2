import 'package:firebase_auth/firebase_auth.dart';
import 'package:graduation_project/services/Firebase/buyer_firestore.dart';
import 'package:graduation_project/services/Firebase/seller_firestore.dart';
import 'package:graduation_project/services/Firebase/user_auth.dart';
import 'package:graduation_project/views/home/buyerHome/home_page.dart';
import 'package:graduation_project/views/home/sellerHome/pagehome.dart';
import 'package:graduation_project/views/login_signup/signup/component/verifiication/verify.dart';
import 'package:provider/provider.dart';

import '../../services/constant/path_images.dart';
import 'package:flutter/material.dart';

class PageEnter extends StatefulWidget {
  const PageEnter({super.key});

  @override
  State<PageEnter> createState() => _PageEnterState();
}

class _PageEnterState extends State<PageEnter> {
  @override
  Widget build(BuildContext context) {
    final UserAuth auth = Provider.of<UserAuth>(context);
    final BuyersFirestore buyer = Provider.of<BuyersFirestore>(context);
    final SellerFirestore seller = Provider.of<SellerFirestore>(context);

    Future<void> checkUserAndNavigate() async {
      if (auth.currentUser.emailVerified == true) {
        bool isBuyer = await buyer.isBuyer(auth.currentUser.email ?? '');
        if (isBuyer) {
          await buyer.loadBuyerData();
          if (mounted) {
            await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageHomeBuyer()),
                (route) => false);
          }
        }
        bool isSeller = await seller.isSeller(auth.currentUser.email ?? '');
        if (isSeller) {
          await seller.loadSellerData();
          if (mounted) {
            await Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const PageHomeSeller()),
                (route) => false);
          }
        }
      } else {
        if (auth.currentUser.email != null && auth.currentUser.email != '') {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Pageverified(email: auth.currentUser.email ?? '')),
              (route) => false);
        } else {
          await Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const PageHomeBuyer()),
              (route) => false);
        }
      }
    }

    return StreamBuilder<User?>(
      stream: UserAuth().userStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            checkUserAndNavigate();
          });
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(PathImage.splashPhoto),
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 100),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome to Our Community!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 28,
                            color: Colors.deepPurple[400],
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'We\'re here to support and engage with you on your journey',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                await auth.loginAnonymously();
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
                                'Get Started',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
