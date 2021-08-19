import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../constants.dart';

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
    var size = MediaQuery.of(context).size;
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (c, snapshot) {
        if (snapshot.data!) {
          return FloatingActionButton(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.transparent,
            splashColor: Colors.transparent,
            highlightElevation: 0,
            hoverElevation: 0,
            focusElevation: 0,
            elevation: 0,
            disabledElevation: 0,
            child: SvgPicture.asset(stopSVG, height: size.height * 0.08),//Icon(Icons.stop, size: 35),
            onPressed: () {
              FlutterBlue.instance.stopScan();
            },
          );
        } else {
          return FloatingActionButton(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.transparent,
              splashColor: Colors.transparent,
              highlightElevation: 0,
              hoverElevation: 0,
              focusElevation: 0,
              disabledElevation: 0,
              elevation: 0,
              child: SvgPicture.asset(searchSVG, height: size.height * 0.06),//Icon(Icons.search),
              onPressed: () {
                FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));
              });
        }
      },
    );
  }
}
