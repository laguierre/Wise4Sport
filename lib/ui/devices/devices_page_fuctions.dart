import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

class ButtonWiseCMD extends StatelessWidget {
  const ButtonWiseCMD({
    Key? key,
    required this.string,
    required this.onTap,
    this.image = '',
    this.width = 150,
    this.height = 50,
  }) : super(key: key);
  final String string;
  final String image;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade500)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: height * 0.7,
              width: height * 0.7,
              child: SvgPicture.asset(
                image,
                color: Colors.black
              ),
            ),
            SizedBox(width: width * 0.07),
            Text(string, style: TextStyle(color: kTextBtnColor, fontSize: height * 0.33))
          ],
        ),
        onPressed: onTap,
      ),
    );
  }
}


