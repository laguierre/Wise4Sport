import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise4sport/data/wise_class.dart';

import '../../../constants.dart';

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
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
      child: Stack(
          alignment: AlignmentDirectional.topCenter,
          fit: StackFit.loose,
          children: [
            Padding(
              padding: EdgeInsets.only(top: size.height * 0.1),
              child: Container(
                  decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(kBorderRadiusMainContainer),
              )),
            ),
            Positioned(
                top: size.height * 0.025,
                height: size.height * 0.11,
                child: SvgPicture.asset(
                  'assets/icons/gyroscope.svg',
                )),
            Padding(
                padding: EdgeInsets.only(
                  left: size.height * 0.018,
                  right: size.height * 0.018,
                  top: size.height * 0.15,
                ),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius:
                          BorderRadius.circular(kBorderRadiusSlaveContainer),
                      color: Colors.white54,
                    ),
                    width: double.infinity,
                    height: size.height * 0.22,
                    padding: EdgeInsets.only(
                        top: size.height * 0.015,
                        bottom: size.height * 0.012,
                        left: size.width * 0.025),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Inertial',
                            style: Theme.of(context).textTheme.headline6),
                        SizedBox(height: size.height * 0.001),
                        Text(
                          'ACC (X, Y, Z): ' + WiseIMUData.getACC(),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'Gyro (X, Y, Z): ' + WiseIMUData.getV(),
                          style: TextStyle(fontSize: 15),
                        ),
                        Text(
                          'MAG (X, Y, Z): ' + WiseIMUData.getMAG(),
                          style: TextStyle(fontSize: 15),
                        ),
                      ],
                    ))),
          ]),
      /*Padding(
          padding: EdgeInsets.only(top: 160.0, left: 20, right: 20),
          child: Container(
              width: double.infinity,
              height: size.height * 0.7,
              decoration: BoxDecoration(
                color: Colors.white38,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Padding(
                  padding: EdgeInsets.only(left: 15, right: 15, top: 50),
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
                          height: 120,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Stack(
                            children: [
                              Text('Quaternions',
                                  style: Theme.of(context).textTheme.headline6),
                              Positioned(
                                top: 40,
                                child: Text(
                                  'P: ' + WiseIMUData.getP(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 70,
                                child: Text(
                                  'Q: ' + WiseIMUData.getQ(),
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
                          height: 160,
                          padding: EdgeInsets.only(top: 10, left: 10),
                          child: Stack(
                            children: [
                              Text('Inertial',
                                  style: Theme.of(context).textTheme.headline6),
                              Positioned(
                                top: 40,
                                child: Text(
                                  'ACC (X, Y, Z): ' + WiseIMUData.getACC(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 75,
                                child: Text(
                                  'Gyro (X, Y, Z): ' + WiseIMUData.getV(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                              Positioned(
                                top: 110,
                                child: Text(
                                  'MAG (X, Y, Z): ' + WiseIMUData.getMAG(),
                                  style: TextStyle(fontSize: 15),
                                ),
                              ),
                            ],
                          )),
                    ],
                  ))),
        ),

      ],*/
    );
  }
}
