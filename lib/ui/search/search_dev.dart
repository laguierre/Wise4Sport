import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:wise4sport/ui/bt_widgets/widgets.dart';
import 'package:wise4sport/ui/devices/devices_page.dart';

import '../../constants.dart';
import 'fab_search_devices.dart';

class SearchDevices extends StatefulWidget {
  const SearchDevices({Key? key}) : super(key: key);

  @override
  _SearchDevicesState createState() => _SearchDevicesState();
}

class _SearchDevicesState extends State<SearchDevices> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FABSearchDevices(),
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
          colors: wiseGradientBack,
          begin: Alignment.topLeft,
          end: Alignment.bottomLeft,
        )),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: kPaddingSearchPage),
                child: Row(
                  children: [
                    Icon(
                      Icons.bluetooth_audio_outlined,
                      size: 35,
                      color: Colors.black,
                    ),
                    Text(" Search Sensor",
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Roboto',
                            fontSize: 35,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(kPaddingSearchPage),
                child: Container(
                  width: double.infinity,
                  height: size.height * 0.73,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, right: 10, left: 10),
                  decoration: BoxDecoration(
                    color: kColorMainContainer,
                    borderRadius: BorderRadius.circular(kBorderRadiusMainContainer),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: StreamBuilder<List<ScanResult>>(
                      stream: FlutterBlue.instance.scanResults,
                      initialData: [],
                      builder: (c, snapshot) => Column(
                        children: snapshot.data!
                            .map(
                              (r) => ScanResultTile(
                                result: r,
                                onTap: () => Navigator.of(context).push(
                                    PageRouteBuilder(
                                        transitionDuration:
                                            const Duration(milliseconds: 900),
                                        pageBuilder: (context, animation, _) {
                                          r.device.connect();
                                          return FadeTransition(
                                            opacity: animation,
                                            child:
                                                DevicesPage(device: r.device),
                                          );
                                        })),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
