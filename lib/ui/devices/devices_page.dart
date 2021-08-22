import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wise4sport/data/utils/btn_widgets.dart';
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

class _DevicesPageState extends State<DevicesPage>
    with TickerProviderStateMixin {
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
  bool isPlay = false;
  bool isRefresh = false;
  bool isFw = false;
  bool isHw = false;
  bool isMem = false;
  bool isMAC = false;
  bool isREC = false;
  int totalPage = 3;

  late AnimationController _animationController;

  _DevicesPageState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReadyRx = false;
    isReadyTx = false;
    isReadyBatt = false;
    connectToDevice();
    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1))
          ..stop(canceled: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
        if (!isGPSon) {
          writeData(SendWiseCMD.GPSCmdOff);
          return;
        }
        if (data.contains('P:') && !isIMUon) {
          writeData(SendWiseCMD.IMUCmdOff);
          return;
        }
      }
      if (currentIndex == PageWise.pageIMU) {
        if (data.contains('FIX:')) {
          writeData(SendWiseCMD.GPSCmdOff);
          return;
        }
        if (data.contains('P:') && !isIMUon) {
          writeData(SendWiseCMD.IMUCmdOff);
          return;
        }
        _parserIMUData(data);
      }
      if (currentIndex == PageWise.pageCFG) {
        if (data.contains('FIX:')) {
          writeData(SendWiseCMD.GPSCmdOff);
          return;
        }
        if (data.contains('P')) {
          writeData(SendWiseCMD.IMUCmdOff);
          return;
        }
        _parserCFGData(data);
      }
      if (data.contains('@5')) {
        isREC = true;
      }
      if (data.contains('@6')) {
        isREC = false;
      }
    }
  }

  void _parserCFGData(String data) {
    if (data.contains('MEMST')) {
      var parser = data.split(',');
      if (parser.length == 3) {
        WiseCFGData.setMem(parser[2].replaceAll('\n', ''));
        isMem = true;
      }
    }
    if (data.contains('Firmware')) {
      WiseCFGData.setFwVersion(data.replaceAll('Firmware', ''));
      isFw = true;
    }
    if (data.contains('-')) {
      String buffer = data.replaceAll('@I', '');
      WiseCFGData.setMAC(buffer.toUpperCase());
      isMAC = true;
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
        WiseGPSData.TimeStamp = GPSData[0].replaceAll('T:', "");
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
      if (bytes.length < 20) {
        try {
          await characteristicDeviceTx.write(bytes, withoutResponse: true);
        } catch (e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final PageController _pageController = PageController(initialPage: 0);
    var size = MediaQuery.of(context).size;
    var responsive = Responsive(context);
    double sizeDotWidth = responsive.diagonalPercent(1.5);
    double sizeDotSpace = responsive.diagonalPercent(1);

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
            child: !isReadyRx
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Waiting...", style: TextStyle(fontSize: 20),),
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
                      colors: wiseGradientBack,
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
                            _dataParser(snapshot.data!);
                            return Stack(children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: responsive.height * 0.10,
                                  bottom: responsive.height * 0.15,
                                ),
                                child: PageView(
                                  onPageChanged: (page) {
                                    currentIndex = page;
                                    setState(() {
                                      if (isPlay) {
                                        isPlay = false;
                                      }
                                    });
                                    switch (currentIndex) {
                                      case PageWise.pageGPS:
                                        setState(() {
                                          isRefresh = false;
                                          isIMUon = false;
                                        });
                                        _initGPSLabels();
                                        break;
                                      case PageWise.pageIMU:
                                        _initIMULabels();
                                        setState(() {
                                          isRefresh = false;
                                        });

                                        break;
                                      case PageWise.pageCFG:
                                        setState(() {
                                          isRefresh = true;
                                        });
                                        _initCFGLabels();
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
                                        size: size,
                                        WiseCFGData: WiseCFGData,
                                        characteristicDeviceTx:
                                            characteristicDeviceTx,
                                        isREC: isREC),
                                  ],
                                ),
                              ),
                              Positioned(
                                //right: responsive                .widthPercent(responsive.width * 0.03),
                                bottom: 0,
                                right: 0,
                                child: SizedBox(
                                    height: size.height * 0.14,
                                    width: size.height * 0.14,
                                    child: MaterialButton(
                                      splashColor: Colors.transparent,
                                      highlightElevation: 0,
                                      hoverElevation: 0,
                                      focusElevation: 0,
                                      elevation: 0,
                                      disabledElevation: 0,
                                      shape: CircleBorder(),
                                      child: isPlay
                                          ? SvgPicture.asset(cancelSVG)
                                          : !isRefresh
                                              ? SvgPicture.asset(playSVG)
                                              : AnimatedBuilder(
                                                  animation:
                                                      _animationController,
                                                  child: SvgPicture.asset(
                                                      refreshSVG,
                                                      height:
                                                          responsive.height *
                                                              0.08),
                                                  builder:
                                                      (BuildContext context,
                                                          Widget? child) {
                                                    return Transform.rotate(
                                                      angle:
                                                          _animationController
                                                                  .value *
                                                              2 *
                                                              pi,
                                                      child: child,
                                                    );
                                                  },
                                                ),
                                      onPressed: () {
                                        setState(() {
                                          isPlay = !isPlay;
                                        });
                                        switch (currentIndex) {
                                          case PageWise.pageGPS:
                                            if (isPlay)
                                              isGPSon = true;
                                            else
                                              isGPSon = false;
                                            _gpsOn(isGPSon);
                                            break;
                                          case PageWise.pageIMU:
                                            if (isPlay) {
                                              isIMUon = true;
                                            } else {
                                              isIMUon = false;
                                            }
                                            _imuOn(isIMUon);
                                            break;
                                          case PageWise.pageCFG:
                                            isPlay = false;

                                            _animationController.repeat();
                                            _CFGOn();
                                            Timer(Duration(seconds: 5), () {
                                              _animationController.stop(
                                                  canceled: true);
                                              _animationController.reset();
                                            });

                                            break;
                                          default:
                                            break;
                                        }
                                      },
                                    )),
                              ),
                              Positioned(
                                left: 10,
                                bottom: 35,
                                child: BtnSVG(
                                  width: 170,
                                  height: 50,
                                  label: !isREC ? 'REC' : 'STOP',
                                  image: !isREC ? recSVG : stopSVG,
                                  onTap: () {
                                    setState(() {
                                      isREC = !isREC;
                                    });
                                    if(isREC)
                                      writeData(SendWiseCMD.RECModeOn);
                                    else
                                      writeData(SendWiseCMD.RECModeOff);
                                  },
                                ),
                              ),
                              Positioned(
                                left: responsive.width / 2 -
                                    totalPage * sizeDotSpace,
                                bottom: responsive.height * 0.12,
                                child: SmoothPageIndicator(
                                    effect: WormEffect(
                                        spacing: sizeDotSpace,
                                        radius: sizeDotWidth,
                                        dotWidth: sizeDotWidth,
                                        dotHeight: sizeDotWidth,
                                        activeDotColor: Colors.white54),
                                    controller: _pageController,
                                    count: totalPage),
                              ),
                            ]);
                          } else {
                            return Text('Check the stream');
                          }
                        }))),
      ),
    );
  }

  void _initCFGLabels() {
    WiseCFGData.fwVersion = 'N/A';
    WiseCFGData.hwVersion = 'N/A';
    WiseCFGData.mac = 'N/A';
    WiseCFGData.mem = 'N/A';
    isFw = false;
    isMAC = false;
    isHw = false;
    isMem = false;
  }

  void _initIMULabels() {
    WiseIMUData.a = 'N/A';
    WiseIMUData.m = 'N/A';
    WiseIMUData.p = 'N/A';
    WiseIMUData.q = 'N/A';
    WiseIMUData.v = 'N/A';
  }

  void _initGPSLabels() {
    WiseGPSData.TimeStamp = "N/A";
    WiseGPSData.Flag = 'N/A';
    WiseGPSData.Fix = 'N/A';
    WiseGPSData.LAT = 'N/A';
    WiseGPSData.LONG = 'N/A';
    WiseGPSData.VelE = 'N/A';
    WiseGPSData.VelN = 'N/A';
    WiseGPSData.aACC = 'N/A';
    WiseGPSData.vACC = 'N/A';
    WiseGPSData.sACC = 'N/A';
    WiseGPSData.PDOP = 'N/A';
    WiseGPSData.SAT = 'N/A';
  }

  void _CFGOn() {
    Stream.periodic(const Duration(milliseconds: 500)).take(10).listen((_) {
      if (!isMAC) {
        writeData(SendWiseCMD.MACCmd);
      }
    });
    Stream.periodic(const Duration(milliseconds: 500)).take(10).listen((_) {
      if (!isMem) {
        writeData(SendWiseCMD.MEMCmd);
      }
    });
    Stream.periodic(const Duration(milliseconds: 500)).take(10).listen((_) {
      if (!isFw) {
        writeData(SendWiseCMD.FWVersionCmd);
        //Future.delayed(const Duration(milliseconds: 100), () {});
      }
    });
  }

  void _imuOn(bool isOn) {
    if (isOn)
      writeData(SendWiseCMD.IMUCmdOn + '\n\r');
    else
      writeData(SendWiseCMD.IMUCmdOff + '\n\r');
  }

  void _gpsOn(bool isOn) {
    if (isOn) {
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
                borderRadius: BorderRadius.all(Radius.circular(kBorderRadiusMainContainer))),
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
        Future.value(false);
  }
}
