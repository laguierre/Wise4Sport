import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wise4sport/ui/bt_widgets/btoff_screen.dart';
import 'package:wise4sport/ui/search/search_dev.dart';

class BleInstance extends StatelessWidget {
  const BleInstance({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BluetoothState>(
        stream: FlutterBlue.instance.state,
        initialData: BluetoothState.unknown,
        builder: (c, snapshot) {
          final state = snapshot.data;
          if (state == BluetoothState.on) {
            return SearchDevices();
          }
          return BluetoothOffScreen(state: state);
        });
  }
}
