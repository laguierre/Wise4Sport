import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_math/vector_math.dart' as VMath;
import 'package:wise4sport/data/utils/responsive.dart';
import 'package:wise4sport/data/wise_class.dart';
import 'package:wise4sport/ui/devices/pages/wise_cfg_page.dart';
import 'package:wise4sport/ui/devices/pages/wise_gps_page.dart';
import 'package:wise4sport/ui/devices/pages/wise_imu_page.dart';

import '../../constants.dart';

class DevicesPage extends StatefulWidget {
  final BluetoothDevice device;

  const DevicesPage({Key? key, required this.device}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  late BluetoothCharacteristic characteristicDeviceTx; //Servicio de Tx
  late Stream<List<int>> _stream; //Servicio de Rx
  late Stream<List<int>> _battLevel;
  late List<int> prueba;
  bool isReadyRx = false;
  bool isReadyBatt = false;
  bool isReadyTx = false;
  late String Pitch = "", Roll = "", Yaw = "", Fila = "";
  var WiseGPSData = new WiseGPSDataClass();
  var WiseIMUData = new WiseIMUDataClass();
  var WiseCFGData = new WiseCFGDataClass();
  int currentIndex = 0;
  int sCMDCfg = 0;
  bool isGPSon = false;
  bool isIMUon = false;

  _DevicesPageState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReadyRx = false;
    isReadyTx = false;
    isReadyBatt = false;
    connectToDevice();
  }

  connectToDevice() async {
    if (widget.device == null) {
      Navigator.of(context).pop(true); //_Pop();
      return;
    }
    new Timer(const Duration(seconds: 15), () {
      if (!isReadyRx) {
        disconnectFromDevice();
        Navigator.of(context).pop(true); //_Pop();
      }
    });
    await widget.device.connect();
    discoverServices();
  }

  disconnectFromDevice() {
    if (widget.device == null) {
      Navigator.of(context).pop(true); //_Pop();
      return;
    }
    widget.device.disconnect();
  }

  discoverServices() async {
    if (widget.device == null) {
      Navigator.of(context).pop(true); //_Pop();
      return;
    }
    isReadyBatt = false;
    List<BluetoothService> services = await widget.device.discoverServices();
    print(services);
    services.forEach((service) {
      if (service.uuid.toString().toUpperCase() == SERVICE_UUID) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_RX) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            _stream = characteristic.value;
            setState(() {
              isReadyRx = true;
            });
          }
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_TX) {
            characteristicDeviceTx = characteristic;
            setState(() {
              isReadyTx = true;
            });
          }
        });
      }
      if (service.uuid.toString().toUpperCase() == SERVICE_UUID_BATTERY) {
        service.characteristics.forEach((characteristic) {
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_BATTERY) {
            characteristic.setNotifyValue(!characteristic.isNotifying);
            _battLevel = characteristic.value;
            setState(() {
              isReadyBatt = true;
            });
          }
        });
      }
    });
    if (!isReadyRx) {
      Navigator.of(context).pop(true); //_Pop();
    }

    ///Start GPS Data by default///
    if (isReadyTx) writeData(SendWiseCMD.GPSCmdOn);
  }

  _dataParser(List<int> dataFromDevice) {
    //print('Dato Rx: ' + dataFromDevice.toString());
    var data = utf8.decode(dataFromDevice);
    if (data.isNotEmpty) {
      print(data.toString());
      if (currentIndex == PageWise.pageGPS) {
        _parserGPSData(data);
        if (!isGPSon) writeData(SendWiseCMD.GPSCmdOff);
        /*if (data.contains('P:')) {
        writeData('@8'); //Stop data IMU//
      }*/
      }
      /*if (currentIndex == PageWise.pageIMU) {
      if (data.contains('FIX:')) {
        writeData('@3');
      }
      _parserIMUData(data);
    }
    if (currentIndex == PageWise.pageCFG) {
      _parserCFGData(data);
    }*/
    }
  }

  void _parserCFGData(String data) {
    if (data.contains('P:')) writeData(SendWiseCMD.IMUCmdOff);

    if (data.contains('MEMST')) {
      var parser = data.split(',');
      if (parser.length == 3) {
        WiseCFGData.setMem(parser[2]);
        sCMDCfg = 1;
      }
    }
    if (data.contains('Firmware')) {
      WiseCFGData.setFwVersion(data.replaceAll('Firmware', ''));
    }
    if (data.contains('-')) {
      print('FIRMWARE');
      String buffer = data.replaceAll('@I', '');
      WiseCFGData.setMAC(buffer.toUpperCase());
      sCMDCfg = 2;
    }
  }

  void _parserIMUData(String data) {
    var parser = data.split(' ');
    if (parser.length == kIMUDataPackeSize) {
      WiseIMUData.setP(parser[1].replaceAll("P:", ""));
      WiseIMUData.setQ(parser[2].replaceAll("Q:", ""));
      WiseIMUData.setV(parser[3].replaceAll("V:", ""));
      WiseIMUData.setACC(parser[4].replaceAll("A:", ""));
      WiseIMUData.setMAG(parser[5].replaceAll("M:", ""));
    }
  }

  void _parserGPSData(String data) {
    var parser = data.split(';');
    if (parser.length == kGPSDataPackeSize) {
      var GPSData = parser[0].split(',');
      if (GPSData.length == 3) {
        WiseGPSData.TimeStamp = GPSData[0];
        WiseGPSData.Flag = GPSData[1].replaceAll("flag:", "");
        WiseGPSData.Fix = GPSData[2].replaceAll("FIX:", "");
      }
      GPSData = parser[1].split(',');
      if (GPSData.length == 2) {
        WiseGPSData.LAT = GPSData[0].replaceAll("POS: ", "");
        WiseGPSData.LONG = GPSData[1];
      }
      GPSData = parser[2].split(',');
      if (GPSData.length == 2) {
        WiseGPSData.VelE = GPSData[0].replaceAll("VEL: ", "");
        WiseGPSData.VelN = GPSData[1];
      }
      GPSData = parser[3].split(',');
      if (GPSData.length == 3) {
        WiseGPSData.aACC = GPSData[0].replaceAll("ACC:", "");
        WiseGPSData.vACC = GPSData[1];
        WiseGPSData.sACC = GPSData[2];
      }
      WiseGPSData.PDOP = parser[4].replaceAll('PDOP: ', "");
      WiseGPSData.SAT = parser[5].replaceAll('SAT: ', "");
    }
  }

  writeData(String Data) async {
    if (characteristicDeviceTx == null) {
      return;
    } else {
      List<int> bytes = utf8.encode(Data);
      characteristicDeviceTx.write(bytes);
      //print('Tx BLE:' + bytes.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;
    var responsive = Responsive(context);
    double sizeBoxSVG = responsive.weightPercent(15);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          extendBodyBehindAppBar: true,
          extendBody: true,
          appBar: AppBar(
              iconTheme: IconThemeData(
                color: Colors.black, //change your color here
              ),
              backgroundColor: Colors.transparent,
              elevation: 0,
              title: Row(
                children: [
                  Icon(
                    Icons.bluetooth_audio_outlined,
                    color: Colors.black,
                    size: 30,
                  ),
                  SizedBox(width: 5),
                  Text(widget.device.name,
                      style: TextStyle(color: Colors.black, fontSize: 28)),
                ],
              )),
          /*bottomNavigationBar:
              buildContainerBottomNavBar(_pageController, currentIndex),*/
          body: SafeArea(
            top: false,
            bottom: false,
            child: Container(
                child: !isReadyRx
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Waiting..."),
                            const SizedBox(height: 15),
                            CircularProgressIndicator(
                                backgroundColor: kPrimaryColor),
                          ],
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: double.infinity,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                          colors: [
                            Colors.blueGrey,
                            Colors.grey,
                            Colors.deepOrange.withOpacity(0.5),
                            Colors.red.withOpacity(0.5),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomLeft,
                        )),
                        child: StreamBuilder<List<int>>(
                            stream: _stream,
                            builder: (BuildContext context,
                                AsyncSnapshot<List<int>> snapshot) {
                              if (snapshot.hasError)
                                return Text('Error: ${snapshot.error}');
                              if (snapshot.connectionState ==
                                  ConnectionState.active) {
                                //var currentValue = _dataParser(snapshot.data);
                                _dataParser(snapshot.data!);
                                return Stack(children: [
                                  Positioned(
                                      right: responsive.weightPercent(5),
                                      top: -responsive.heightPercent(18),
                                      //right: -3 * responsive.diagonalPercent(7),
                                      child: SizedBox(
                                          width: sizeBoxSVG,
                                          child: isGPSon
                                              ? SvgPicture.asset(cancelSVG)
                                              : SvgPicture.asset(playSVG))),
                                  PageView(
                                    onPageChanged: (page) {
                                      currentIndex = page;
                                      sCMDCfg = 0;
                                      switch (currentIndex) {
                                        case 0:
                                          setState(() {
                                            isGPSon = !isGPSon;
                                            isIMUon = false;
                                          });
                                          _gpsOn();
                                          break;
                                        case 1:
                                          setState(() {
                                            isIMUon = !isIMUon;
                                            if (isGPSon) {
                                              _gpsOn();
                                              isGPSon = false;
                                            }
                                          });

                                          //_imuOn();
                                          break;
                                        case 2:
                                          //_CFGOn();
                                          break;
                                        default:
                                          break;
                                      }
                                    },
                                    scrollDirection: Axis.horizontal,
                                    controller: _pageController,
                                    children: [
                                      GPSPageWise(
                                          size: size, WiseGPSData: WiseGPSData),
                                      IMUPageWise(
                                          size: size, WiseIMUData: WiseIMUData),
                                      CFGPageWise(
                                          size: size, WiseCFGData: WiseCFGData),
                                    ],
                                  )
                                ]);
                              } else {
                                return Text('Check the stream');
                              }
                            }))),
          )),
    );
  }

  Container buildContainerBottomNavBar(
      PageController _pageController, int currentIndex) {
    return Container(
      color: Colors.transparent,
      child: BottomNavigationBar(
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.transparent,
        elevation: 25,
        onTap: (value) {
          currentIndex = value;
          _pageController.animateToPage(
            value,
            duration: Duration(milliseconds: 300),
            curve: Curves.decelerate,
          );

          setState(() {
            switch (currentIndex) {
              case PageWise.pageGPS:
                setState(() {
                  isGPSon = !isGPSon;
                  isIMUon = false;
                });
                _gpsOn();
                break;
              case PageWise.pageIMU:
                setState(() {
                  isIMUon = !isIMUon;
                  if (isGPSon) {
                    _gpsOn();
                    isGPSon = false;
                  }
                });

                //_imuOn();
                break;
              case PageWise.pageCFG:
                //_CFGOn();
                break;
            }
          });
        },
        items: [
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/satellite.svg', width: 40),
              label: 'GPS'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/gyroscope.svg', width: 40),
              label: 'IMU'),
          BottomNavigationBarItem(
              icon: SvgPicture.asset('assets/icons/cpu.svg', width: 40),
              label: 'Sensor'),
        ],
      ),
    );
  }

  void _CFGOn() {
    writeData('@V\n\r');
    Future.delayed(const Duration(milliseconds: 100), () {});
    writeData('@I\n\r');
    Future.delayed(const Duration(milliseconds: 100), () {});
    writeData('@M\n\r');
  }

  void _imuOn() {
    writeData(SendWiseCMD.IMUCmdOn + '\n\r');
  }

  void _gpsOn() {
    if (isGPSon) {
      writeData(SendWiseCMD.GPSCmdOn + '\n\r');
    } else {
      writeData(SendWiseCMD.GPSCmdOff + '\n\r');
    }
  }

  ///Back to the search page///
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15))),
            title: Text("Are you sure?"),
            content: Text('Do you want to disconnect device and go back'),
            actions: [
              TextButton(
                  onPressed: () {
                    disconnectFromDevice();
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes')),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text('No'))
            ],
          ),
        )) ??
        false;
  }
}
