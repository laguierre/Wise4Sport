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
    return MaterialButton(
      splashColor: Colors.transparent,
      highlightElevation: 50,
      hoverElevation: 50,
      focusElevation: 50,
      elevation: 50,
      disabledElevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      //shape: CircleBorder(),
      //splashColor: Colors.deepOrange.withOpacity(0.5),
      //highlightColor: Colors.red.withOpacity(0.5),
      onPressed: onTap,
      child: Container(
          padding: EdgeInsets.only(
              //right: width * 0.05,
              //left: width * 0.05,
              top: height * 0.1,
              bottom: height * 0.1),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.transparent,//Colors.white38,
            borderRadius: BorderRadius.all(Radius.circular(height * 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [

              SizedBox(
                width: width * 0.3,
                child: SvgPicture.asset(
                  image,
                  height: height * 0.9,
                  color: Colors.black,
                ),
              ),
              Text(label, style: Theme.of(context).textTheme.headline6),
            ],
          )),
    );
  }
}
