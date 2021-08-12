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
    double kFontSizePageLabelData = size.height * 0.02;
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
                  borderRadius:
                      BorderRadius.circular(kBorderRadiusMainContainer),
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
                              borderRadius: BorderRadius.circular(
                                  kBorderRadiusSlaveContainer),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            padding: EdgeInsets.only(
                                top: size.height * 0.012,
                                bottom: size.height * 0.012,
                                left: size.width * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time Stamp ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: size.height * 0.01),
                                Text(
                                  'Time Stamp: ' + WiseGPSData.getTimeStamp(),
                                  style: TextStyle(
                                      fontSize: kFontSizePageLabelData),
                                ),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  kBorderRadiusSlaveContainer),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            height: size.height * 0.12,
                            padding: EdgeInsets.only(
                                top: size.height * 0.020,
                                //bottom: size.height * 0.025,
                                left: size.width * 0.025),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text('FIX: ' + WiseGPSData.getFix(),
                                    style: TextStyle(
                                        fontSize: kFontSizePageLabelData)),
                                Text('PDOP: ' + WiseGPSData.getPDOP(),
                                    style: TextStyle(
                                        fontSize: kFontSizePageLabelData)),
                                Text('Visible SAT: ' + WiseGPSData.getSAT(),
                                    style: TextStyle(
                                        fontSize: kFontSizePageLabelData)),
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  kBorderRadiusSlaveContainer),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            height: size.height * 0.1,
                            padding: EdgeInsets.only(
                                top: size.height * 0.012,
                                bottom: size.height * 0.012,
                                left: size.width * 0.025),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Position: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                SizedBox(height: size.height * 0.005),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            'LAT: ' + WiseGPSData.getLAT(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData))),
                                    Expanded(
                                        flex: 1,
                                        child: Text(
                                            'LONG: ' + WiseGPSData.getLONG(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData)))
                                  ],
                                )
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  kBorderRadiusSlaveContainer),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            height: size.height * 0.1,
                            padding: EdgeInsets.only(
                                top: size.height * 0.012,
                                bottom: size.height * 0.012,
                                left: size.width * 0.025),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Vertical Speed: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            'East Speed: ' +
                                                WiseGPSData.getSpeedEast(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData))),
                                    Expanded(
                                        child: Text(
                                            'North Speed: ' +
                                                WiseGPSData.getSpeedNorth(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData))),
                                  ],
                                )
                              ],
                            )),
                        Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  kBorderRadiusSlaveContainer),
                              color: Colors.white54,
                            ),
                            width: double.infinity,
                            height: size.height * 0.1,
                            padding: EdgeInsets.only(
                                top: size.height * 0.012,
                                bottom: size.height * 0.012,
                                left: size.width * 0.025),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Acceletarions: ',
                                    style:
                                        Theme.of(context).textTheme.headline6),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Expanded(
                                        child: Text(
                                            'aACC: ' + WiseGPSData.getaAcc(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData))),
                                    Expanded(
                                        child: Text(
                                            'sACC: ' + WiseGPSData.getsAcc(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData))),
                                    Expanded(
                                        child: Text(
                                            'vACC: ' + WiseGPSData.getvAcc(),
                                            style: TextStyle(
                                                fontSize:
                                                    kFontSizePageLabelData)))
                                  ],
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
