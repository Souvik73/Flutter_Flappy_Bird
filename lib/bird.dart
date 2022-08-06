import 'package:flutter/material.dart';

class MyBird extends StatelessWidget {
  const MyBird({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      height: 50,
      width: 50,
      'images/flappy.png'
    );
  }
}