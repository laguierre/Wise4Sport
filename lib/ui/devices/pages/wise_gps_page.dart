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
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(
              top: 160.0,
              left: 20,
              right: 20),
          child: Container(
              width: double.infinity,
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius:
                BorderRadius.circular(
                    30),
              ),
              child: Padding(
                  padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                      top: 50),
                  child: Column(
                    mainAxisAlignment:
                    MainAxisAlignment
                        .spaceEvenly,
                    crossAxisAlignment:
                    CrossAxisAlignment
                        .start,
                    children: [
                      Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                            color: Colors
                                .white54,
                          ),
                          width: double
                              .infinity,
                          height: 80,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Time Stamp ',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 35,
                                child: Text(
                                  'Time Stamp: ' +
                                      WiseGPSData
                                          .getTimeStamp(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                            color: Colors
                                .white54,
                          ),
                          width: double
                              .infinity,
                          height: 120,
                          padding: EdgeInsets
                              .only(
                              top: 23,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'FIX: ' +
                                      WiseGPSData
                                          .getFix(),
                                  style: TextStyle(
                                      fontSize:
                                      15)),
                              Positioned(
                                top: 30,
                                child: Text(
                                  'Visible SAT: ' +
                                      WiseGPSData
                                          .getSAT(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                              Positioned(
                                top: 60,
                                child: Text(
                                  'PDOP: ' +
                                      WiseGPSData
                                          .getPDOP(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                            color: Colors
                                .white54,
                          ),
                          width: double
                              .infinity,
                          height: 80,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Position: ',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 35,
                                child: Text(
                                  'LAT: ' +
                                      WiseGPSData
                                          .getLAT() +
                                      '\t\t\t'
                                          'LONG: ' +
                                      WiseGPSData
                                          .getLONG(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                            color: Colors
                                .white54,
                          ),
                          width: double
                              .infinity,
                          height: 80,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Vertical Speed: ',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 35,
                                child: Text(
                                  'East Speed: ' +
                                      WiseGPSData
                                          .getSpeedEast() +
                                      '\t\t\t North Speed: ' +
                                      WiseGPSData
                                          .getSpeedNorth(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                            ],
                          )),
                      Container(
                          decoration:
                          BoxDecoration(
                            borderRadius:
                            BorderRadius
                                .circular(
                                20),
                            color: Colors
                                .white54,
                          ),
                          width: double
                              .infinity,
                          height: 80,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Acceletarions: ',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 35,
                                child: Text(
                                  'aACC: ' +
                                      WiseGPSData
                                          .getaAcc() +
                                      '\t\t\tsACC: ' +
                                      WiseGPSData
                                          .getsAcc() +
                                      '\t\t\tvACC: ' +
                                      WiseGPSData
                                          .getvAcc(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
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
            height: 90,
            child: SvgPicture.asset(
              satelliteSVG,
            )),
      ],
    );
  }
}