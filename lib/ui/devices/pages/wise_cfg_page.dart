import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise4sport/data/wise_class.dart';

import '../devices_page_fuctions.dart';

class CFGPageWise extends StatelessWidget {
  const CFGPageWise({
    Key? key,
    required this.size,
    required this.WiseCFGData,
  }) : super(key: key);

  final Size size;
  final WiseCFGDataClass WiseCFGData;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 160.0, left: 20, right: 20),
          child: Container(
              width: double.infinity,
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white54,
                          ),
                          width: double.infinity,
                          height: 240,
                          padding: EdgeInsets.only(top: 10, left: 15),
                          child: Stack(
                            fit: StackFit.loose,
                            children: [
                              Text('Commands',
                                  style: Theme.of(context).textTheme.headline6),
                              Positioned.fill(
                                top: 40,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    ButtonWiseCMD(
                                      string: 'REC Mode',
                                      onTap: () {},
                                    ),
                                    ButtonWiseCMD(
                                      string: 'Erase MEM',
                                      onTap: () {},
                                    ),
                                    ButtonWiseCMD(
                                      string: 'Refresh',
                                      onTap: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white54,
                          ),
                          width: double.infinity,
                          height: 190,
                          padding: EdgeInsets.only(top: 10, left: 15),
                          child: Stack(
                            children: [
                              Text('Sensor',
                                  style: Theme.of(context).textTheme.headline6),
                              Positioned(
                                top: 40,
                                child: Text(
                                  'MAC: ' + WiseCFGData.getMAC(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 75,
                                child: Text(
                                  'Hw Version: ' + WiseCFGData.getHwVersion(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 110,
                                child: Text(
                                  'Fw Version: ' + WiseCFGData.getFwVersion(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 145,
                                child: Text(
                                  'Memory: ' + WiseCFGData.getMem(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ))),
        ),
        Positioned(
            top: 110,
            width: size.width,
            height: 85,
            child: SvgPicture.asset(
              'assets/icons/cpu.svg',
            )),
      ],
    );
  }
}
