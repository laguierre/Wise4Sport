import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

import '../../constants.dart';

class BluetoothOffScreen extends StatelessWidget {
  const BluetoothOffScreen({Key? key, required this.state}) : super(key: key);

  final BluetoothState? state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.bluetooth_disabled,
              size: 200.0,
              color: kPrimaryColor,
            ),
            const SizedBox(height: 10),
            Text('Bluetooth Adapter is ${state.toString().substring(15)}.'),
          ],
        ),
      ),
    );
  }
}