import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vector_math/vector_math.dart' as VMath;
import 'package:wise4sport/data/wise_class.dart';

import '../../constants.dart';
import 'devides_page_fuctions.dart';

const int kGPSDataPackeSize = 6;
const int kIMUDataPackeSize = 6;

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
  int currentIndex = 0;
  int previousIndex = 0;

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

    ///Strar GPS Data by default///
    if (isReadyTx) writeData(SendWiseCMD.GPSCmdOn);
  }

  _dataParser(List<int> dataFromDevice) {
    var data = utf8.decode(dataFromDevice);

    if (currentIndex == PageWise.pageGPS) {
      var parser = data.split(';');

      if (parser.length == kGPSDataPackeSize) {
        var GPSData = parser[0].split(',');
        if (GPSData.length == 3) {
          WiseGPSData.TimeStamp = GPSData[0];
          WiseGPSData.Flag = GPSData[0];
          WiseGPSData.Fix = GPSData[2];
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
    if (currentIndex == PageWise.pageIMU){
      var parser = data.split(' ');
      if(parser.length == kIMUDataPackeSize){
        WiseIMUData.setP(parser[1].replaceAll("P:", ""));
        WiseIMUData.setQ(parser[2].replaceAll("Q:", ""));
        WiseIMUData.setV(parser[3].replaceAll("V:", ""));
        WiseIMUData.setACC(parser[4].replaceAll("A:", ""));
        WiseIMUData.setMAG(parser[5].replaceAll("M:", ""));
        print(parser[5]);
      }
    }
  }

  writeData(String Data) async {
    if (characteristicDeviceTx == null) {
      return;
    } else {
      List<int> bytes = utf8.encode(Data);
      characteristicDeviceTx.write(bytes);
      print(bytes.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;
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
          bottomNavigationBar:
              buildContainerBottonNavBar(_pageController, currentIndex),
          body: SafeArea(
              top: false,
              bottom: false,
              child: Center(
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
                                    return PageView(
                                      onPageChanged: (page) {
                                        currentIndex = page;
                                        switch (currentIndex) {
                                          case 0:
                                            writeData(SendWiseCMD.GPSCmdOn);
                                            break;
                                          case 1:
                                            break;
                                          case 2:
                                            break;
                                          default:
                                            break;
                                        }

                                        setState(() {});
                                      },
                                      scrollDirection: Axis.horizontal,
                                      controller: _pageController,
                                      children: [
                                        Stack(
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
                                                  'assets/icons/satellite.svg',
                                                )),
                                          ],
                                        ),
                                        Stack(
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
                                                                      'P: ' + WiseIMUData.getP(),
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 70,
                                                                    child: Text(
                                                                      'Q: ' + WiseIMUData.getQ(),
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
                                                                      'ACC (X, Y, Z): ' + WiseIMUData.getACC()+ ' [m/s^2]',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 75,
                                                                    child: Text(
                                                                      'Gyro (X, Y, Z): ' + WiseIMUData.getV() + ' [m/s^2]',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 110,
                                                                    child: Text(
                                                                      'MAG (X, Y, Z): ' + WiseIMUData.getMAG() + '[m/s^2]',
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
                                        ),
                                        Stack(
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
                                                          top: 10),
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
                                                              height: 240,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      left: 15),
                                                              child: Stack(
                                                                fit: StackFit
                                                                    .loose,
                                                                children: [
                                                                  Text(
                                                                      'Commands',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6),
                                                                  Positioned
                                                                      .fill(
                                                                    top: 40,
                                                                    child:
                                                                        Column(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceEvenly,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        ButtonWiseCMD(
                                                                            string:
                                                                                'REC Mode'),
                                                                        ButtonWiseCMD(
                                                                            string:
                                                                                'Erase MEM'),
                                                                        ButtonWiseCMD(
                                                                            string:
                                                                                'Refresh'),
                                                                      ],
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
                                                              height: 190,
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      top: 10,
                                                                      left: 15),
                                                              child: Stack(
                                                                children: [
                                                                  Text('Sensor',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .headline6),
                                                                  Positioned(
                                                                    top: 40,
                                                                    child: Text(
                                                                      'MAC:',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 75,
                                                                    child: Text(
                                                                      'Hw Version: ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 110,
                                                                    child: Text(
                                                                      'Fw Version: ',
                                                                      style: TextStyle(
                                                                          fontSize:
                                                                              15),
                                                                    ),
                                                                  ),
                                                                  Positioned(
                                                                    top: 145,
                                                                    child: Text(
                                                                      'Memory: ',
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
                                                  'assets/icons/cpu.svg',
                                                )),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Text('Check the stream');
                                  }
                                }))),
              ))),
    );
  }

  Container buildContainerBottonNavBar(
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
                writeData(SendWiseCMD.GPSCmdOn);
                break;
              case PageWise.pageIMU:

                writeData(SendWiseCMD.IMUCmdOn);
                break;
              case PageWise.pageCFG:
                if (previousIndex == PageWise.pageIMU)
                  writeData(SendWiseCMD.IMUCmdOff);
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
