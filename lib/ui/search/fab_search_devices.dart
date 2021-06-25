import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class FABSearchDevices extends StatefulWidget {
  const FABSearchDevices({
    Key? key,
  }) : super(key: key);

  @override
  _FABSearchDevicesState createState() => _FABSearchDevicesState();
}

class _FABSearchDevicesState extends State<FABSearchDevices> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton(
            backgroundColor: Colors.red,
            highlightElevation: 50,
            child: Icon(Icons.stop, size: 35),
            onPressed: () {
              FlutterBlue.instance.stopScan();
            },
          );
        } else {
          return FloatingActionButton(
              backgroundColor: Colors.lightBlue,
              highlightElevation: 50,
              child: Icon(Icons.search),
              onPressed: () {
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
              });
        }
      },
    );
  }
}
