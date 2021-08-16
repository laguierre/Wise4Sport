import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wise4sport/data/wise_class.dart';

import '../../../constants.dart';
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
    double kFontSizePageLabelData = size.height * 0.02;
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
                  borderRadius:
                      BorderRadius.circular(kBorderRadiusMainContainer),
                )),
              ),
              Positioned(
                  top: size.height * 0.025,
                  height: size.height * 0.11,
                  child: SvgPicture.asset(
                    cpuSVG,
                  )),
              Padding(
                  padding: EdgeInsets.only(
                    left: size.height * 0.018,
                    right: size.height * 0.018,
                    top: size.height * 0.15,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                kBorderRadiusSlaveContainer),
                            color: Colors.white54,
                          ),
                          width: double.infinity,
                          height: size.height * 0.22,
                          padding: EdgeInsets.only(
                              top: size.height * 0.020,
                              bottom: size.height * 0.02,
                              left: size.width * 0.025),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Sensor',
                                  style: Theme.of(context).textTheme.headline6),
                              SizedBox(height: size.height * 0.005),
                              Text(
                                'MAC: ' + WiseCFGData.getMAC(),
                                style:
                                    TextStyle(fontSize: kFontSizePageLabelData),
                              ),
                              Text(
                                'Hw Version: ' + WiseCFGData.getHwVersion(),
                                style:
                                    TextStyle(fontSize: kFontSizePageLabelData),
                              ),
                              Text(
                                'Fw Version: ' + WiseCFGData.getFwVersion(),
                                style:
                                    TextStyle(fontSize: kFontSizePageLabelData),
                              ),
                              Text(
                                'Memory: ' + WiseCFGData.getMem(),
                                style:
                                    TextStyle(fontSize: kFontSizePageLabelData),
                              ),
                            ],
                          )),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Commands',
                              style: Theme.of(context).textTheme.headline6),
                          SizedBox(height: size.height * 0.01),
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
                    ],
                  )),
            ]));
  }
}
