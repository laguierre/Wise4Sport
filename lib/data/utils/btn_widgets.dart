import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BtnSVG extends StatelessWidget {
  const BtnSVG(
      {Key? key,
      required this.onTap,
      required this.image,
      required this.label,
      required this.width,
      required this.height})
      : super(key: key);
  final VoidCallback onTap;
  final String image;
  final String label;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return
      InkWell(
        splashColor: Colors.red,
      highlightColor: Colors.blue,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(right: width * 0.1, left: width * 0.1),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Row(
            children: [
              Text(label, style: Theme.of(context).textTheme.headline6),
              SizedBox(width: width * 0.05),
              SvgPicture.asset(image, height: height*0.9, color: Colors.black,),
            ],
          )),
    );
  }
}