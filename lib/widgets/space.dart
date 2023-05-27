import 'package:flutter/material.dart';

class Spc extends StatelessWidget {
  double? height = 0;
  double? width = 0;

  Spc({this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
    );
  }
}
