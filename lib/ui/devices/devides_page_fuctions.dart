import 'package:flutter/material.dart';

class ButtonWiseCMD extends StatelessWidget {
  const ButtonWiseCMD({
    Key? key,
    required this.string,
  }) : super(key: key);
  final String string;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.grey.shade500)),
        child: Text(string, style: TextStyle(color: Colors.white)),
        onPressed: () {},
      ),
    );
  }
}