import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise4sport/data/wise_class.dart';
import 'package:wise4sport/constants.dart';

class GPSPageWise extends StatelessWidget {
  const GPSPageWise({
    Key? key,
    required this.size,
    required this.WiseGPSData,
  }) : super(key: key);

  final Size size;
  final WiseGPSDataClass WiseGPSData;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.transparent,
        child: Container(
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            fit: StackFit.loose,
            children: [
              Padding(
                padding: EdgeInsets.only(top: size.height * 0.125),
                child: Container(
                    decoration: BoxDecoration(
                  color: Colors.white38,
                  borderRadius: BorderRadius.circular(30),
                )),
              ),
              Positioned(
                  top: 0,
                  height: size.height * 0.11,
                  child: SvgPicture.asset(
                    satelliteSVG,
                  )),
              Container(
                child: Padding(
                    padding: EdgeInsets.only(
                        left: size.height * 0.018,
                        right: size.height * 0.018,
                        top: size.height * 0.13,
                    ),
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
                            padding: EdgeInsets.only(top: size.height * 0.015, bottom: size.height * 0.015, left: size.width * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time Stamp ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                    'Time Stamp: ' + WiseGPSData.getTimeStamp(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            height: 120,
                            padding: EdgeInsets.only(top: size.height * 0.025, left: size.width * 0.025),
                            child: Stack(
                              children: [
                                Text('FIX: ' + WiseGPSData.getFix(),
                                    style: TextStyle(fontSize: 15)),
                                Positioned(
                                  top: 30,
                                  child: Text(
                                    'Visible SAT: ' + WiseGPSData.getSAT(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                                Positioned(
                                  top: 60,
                                  child: Text(
                                    'PDOP: ' + WiseGPSData.getPDOP(),
                                    style: TextStyle(fontSize: 15),
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
                            height: 80,
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Stack(
                              children: [
                                Text('Position: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Positioned(
                                  top: 35,
                                  child: Text(
                                    'LAT: ' +
                                        WiseGPSData.getLAT() +
                                        '\t\t\t'
                                            'LONG: ' +
                                        WiseGPSData.getLONG(),
                                    style: TextStyle(fontSize: 15),
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
                            height: 80,
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Stack(
                              children: [
                                Text('Vertical Speed: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Positioned(
                                  top: 35,
                                  child: Text(
                                    'East Speed: ' +
                                        WiseGPSData.getSpeedEast() +
                                        '\t\t\t North Speed: ' +
                                        WiseGPSData.getSpeedNorth(),
                                    style: TextStyle(fontSize: 15),
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
                            height: 80,
                            padding: EdgeInsets.only(top: 10, left: 10),
                            child: Stack(
                              children: [
                                Text('Acceletarions: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Positioned(
                                  top: 35,
                                  child: Text(
                                    'aACC: ' +
                                        WiseGPSData.getaAcc() +
                                        '\t\t\tsACC: ' +
                                        WiseGPSData.getsAcc() +
                                        '\t\t\tvACC: ' +
                                        WiseGPSData.getvAcc(),
                                    style: TextStyle(fontSize: 15),
                                  ),
                                ),
                              ],
                            )),
                      ],
                    )),
              ),
            ],
          ),
        ));
  }
}
