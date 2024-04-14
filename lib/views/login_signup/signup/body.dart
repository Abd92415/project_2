import 'package:flutter/material.dart';
import '../../../services/language/generated/key_lang.dart';
import 'component/buyer/reg_buyer.dart';
import 'component/seller/reg_seller.dart';

class SelectBuyerOrSeller extends StatelessWidget {
  const SelectBuyerOrSeller({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.deepPurple[400],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Let start',
                style: TextStyle(
                  letterSpacing: 3,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  fontSize: 35,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 30),
              Container(
                width: size.width * 0.9,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    buildSignUpButton(
                      onPressed: () {
                        navigateToRegistration(context, const RegisterBuyer());
                      },
                      text: KeyLang.buyer,
                      color: Colors.deepPurple[400] ?? Colors.black,
                      textColor: Colors.white,
                      icon: Icons.shopping_cart,
                    ),
                    const SizedBox(height: 15),
                    buildSignUpButton(
                      onPressed: () {
                        navigateToRegistration(context, const RegisterSeller());
                      },
                      text: KeyLang.seller,
                      color: Colors.deepPurple[400] ?? Colors.black,
                      textColor: Colors.white,
                      icon: Icons.store,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSignUpButton({
    required VoidCallback onPressed,
    required String text,
    required Color color,
    required Color textColor,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white),
            Text(
              text,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            const SizedBox(width: 10),
          ],
        ),
      ),
    );
  }

  void navigateToRegistration(BuildContext context, Widget page) {
    var route = MaterialPageRoute(
      builder: (context) => page,
    );
    Navigator.push(context, route);
  }
}
