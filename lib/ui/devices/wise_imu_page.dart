import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise4sport/data/wise_class.dart';

class IMUPageWise extends StatelessWidget {
  const IMUPageWise({
    Key? key,
    required this.size,
    required this.WiseIMUData,
  }) : super(key: key);

  final Size size;
  final WiseIMUDataClass WiseIMUData;

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
                          height: 120,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Quaternions',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 40,
                                child: Text(
                                  'P: ' +
                                      WiseIMUData
                                          .getP(),
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                              Positioned(
                                top: 70,
                                child: Text(
                                  'Q: ' +
                                      WiseIMUData
                                          .getQ(),
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
                          height: 160,
                          padding: EdgeInsets
                              .only(
                              top: 10,
                              left: 10),
                          child: Stack(
                            children: [
                              Text(
                                  'Inertial',
                                  style: Theme.of(
                                      context)
                                      .textTheme
                                      .headline6),
                              Positioned(
                                top: 40,
                                child: Text(
                                  'ACC (X, Y, Z): ' +
                                      WiseIMUData
                                          .getACC() +
                                      ' [m/s^2]',
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                              Positioned(
                                top: 75,
                                child: Text(
                                  'Gyro (X, Y, Z): ' +
                                      WiseIMUData
                                          .getV() +
                                      ' [m/s^2]',
                                  style: TextStyle(
                                      fontSize:
                                      15),
                                ),
                              ),
                              Positioned(
                                top: 110,
                                child: Text(
                                  'MAG (X, Y, Z): ' +
                                      WiseIMUData
                                          .getMAG() +
                                      '[m/s^2]',
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
            height: 85,
            child: SvgPicture.asset(
              'assets/icons/gyroscope.svg',
            )),
      ],
    );
  }
}


