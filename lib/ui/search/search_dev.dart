import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wise4sport/ui/bt_widgets/widgets.dart';

import 'fab_search_devices.dart';

class SearchDevices extends StatefulWidget {
  const SearchDevices({Key? key}) : super(key: key);

  @override
  _SearchDevicesState createState() => _SearchDevicesState();
}

class _SearchDevicesState extends State<SearchDevices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FABSearchDevices(),
      body: StreamBuilder<List<ScanResult>>(
        stream: FlutterBlue.instance.scanResults,
        initialData: [],
        builder: (c, snapshot) => Column(
          children: snapshot.data!
              .map(
                (r) => ScanResultTile(
              result: r,
              onTap: () => Navigator.of(context).push(PageRouteBuilder(
                  transitionDuration:
                  const Duration(milliseconds: 900),
                  pageBuilder: (context, animation, _) {
                    r.device.connect();
                    return FadeTransition(
                      opacity: animation,
                      //child: ,//DevicePage(device: r.device),
                    );
                  })

                /*MaterialPageRoute(builder: (context) {
                      r.device.connect();
                      return DevicePage(device: r.device);
                    })*/
              ),
            ),
          )
              .toList(),
        ),
      ),
    );
  }
}

