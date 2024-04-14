import 'dart:async';
import '../login_signup/body.dart';
import '../../services/constant/path_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class PageSplachScreen extends StatefulWidget {
  const PageSplachScreen({super.key});

  @override
  State<PageSplachScreen> createState() => _PageSplachScreenState();
}

class _PageSplachScreenState extends State<PageSplachScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      var route = MaterialPageRoute(
        builder: (context) => const PageEnter(),
      );
      Navigator.pushReplacement(context, route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: const Image(
          image: AssetImage(PathImage.splashPhoto),
        ).animate().fade(duration: const Duration(seconds: 2)).flip(),
      ),
    );
  }
}
