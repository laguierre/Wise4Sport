import 'package:flutter/material.dart';

// Colors that we use in our app
const kPrimaryColor = Color(0xFF0B8B61);
const kTextColor = Color(0xFFdbe0e8);
const kTextBtnColor = Colors.black;
const kBackgroundColor = Color(0xFFF9F8FD);
const double kDefaultPadding = 20.0;
const double kRadiusHomeContainer = 35.0;
const double kFontSizeHome = 35.0;
const double kFontBottomMenu = 25.0;
const double kFontDevicePageCurrent = 26.0;
const double kFontValues = 10.0;
const double kFontBottomDevices = 17;
const double kPaddingSearchPage = 15;
const kColorBottomMenu = Colors.black;
const kColorBottomConnect = Colors.grey; //Color(0xFF0B8B61);
const kTextColorAlert = Color(0xFF0B8B61);
const double kSizeOBJ = 6.5;
const int delaySplash = 5000;
const int delayTransition = 900;
const kColorMainContainer = Colors.white38;
// List<Color> wiseGradientBack = [Colors.blueGrey,
//   Colors.blueGrey,
//                         Colors.grey,
//                         Colors.deepOrange.withOpacity(0.5),
//                         Colors.red.withOpacity(0.5),];

List<Color> wiseGradientBack = [
  Color(0xFF108dc7).withOpacity(0.8),
  Color(0xFFef8e38).withOpacity(0.8),
];

///Devices Page constants///
const double kBorderRadiusMainContainer = 10;
const double kBorderRadiusSlaveContainer = 10;

//const String fileName3D = 'assets/3d/ESP.obj';
const String fileName3D = 'assets/3d/v3.obj';
const String playSVG = "assets/icons/play.svg";
const String cancelSVG = "assets/icons/cancel.svg";
const String satelliteSVG = 'assets/icons/satellite.svg';
const String cpuSVG = 'assets/icons/cpu.svg';
const String refreshSVG = 'assets/icons/refresh.svg';
const String searchSVG = 'assets/icons/search.svg';
const String stopSVG = 'assets/icons/stop.svg';
const String recSVG = 'assets/icons/rec.svg';
const String turnOffSVG = 'assets/icons/turn-off.svg';
const String flashSVG = 'assets/icons/chip.svg';
const String refreshMemSVG = 'assets/icons/refreshmem.svg';

/**
 * UUID UART Nordic
 */
final String SERVICE_UUID = "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"; //NUS Nordic
final String CHARACTERISTIC_UUID_RX =
    "6E400003-B5A3-F393-E0A9-E50E24DCCA9E"; //Desde el celular, Tx desde el uC
final String CHARACTERISTIC_UUID_TX =
    "6E400002-B5A3-F393-E0A9-E50E24DCCA9E"; //Desde el celular, Rx desde el uC

final String SERVICE_UUID_BATTERY =
    "0000180F-0000-1000-8000-00805F9B34FB"; //"0000180F-0000-1000-8000-00805F9B34FB";
final String CHARACTERISTIC_UUID_BATTERY =
    "00002A19-0000-1000-8000-00805F9B34FB";
