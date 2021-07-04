import 'dart:async';
import 'dart:convert' show utf8;
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vector_math/vector_math.dart' as VMath;
import 'package:wise4sport/data/wise_class.dart';

import '../../constants.dart';

const int kGPSDataPackeSize = 6;

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

  _DevicesPageState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReadyRx = false;
    isReadyTx = false;
    isReadyBatt = false;
    Pitch = "";
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
  }

  _dataParser(List<int> dataFromDevice) {
    var eulerString = utf8.decode(dataFromDevice);
    var eulerList = eulerString.split(';');

    if (eulerList.length == kGPSDataPackeSize) {
      var GPSData = eulerList[0].split(',');
      if (GPSData.length == 3) {
        WiseGPSData.TimeStamp = GPSData[0];
        WiseGPSData.Flag = GPSData[0];
        WiseGPSData.Fix = GPSData[2];
      }
      GPSData = eulerList[1].split(',');
      if (GPSData.length == 2) {
        WiseGPSData.LAT = GPSData[0].replaceAll("POS: ", "");
        WiseGPSData.LONG = GPSData[1];
      }
      GPSData = eulerList[2].split(',');
      if (GPSData.length == 2) {
        WiseGPSData.VelE = GPSData[0].replaceAll("VEL: ", "");
        WiseGPSData.VelN = GPSData[1];
      }
      GPSData = eulerList[3].split(',');
      if (GPSData.length == 3) {
        WiseGPSData.aACC = GPSData[0].replaceAll("ACC:", "");
        WiseGPSData.vACC = GPSData[1];
        WiseGPSData.sACC = GPSData[2];
      }
      WiseGPSData.PDOP = eulerList[4].replaceAll('PDOP: ', "");
      WiseGPSData.SAT = eulerList[5].replaceAll('SAT: ', "");
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
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.device.name),
          ),
          body: SafeArea(
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
                                return Center(
                                  child: Column(
                                    children: [
                                      TextButton(
                                          onPressed: () {
                                            if (isReadyTx) {
                                              writeData('@3');
                                            }
                                          },
                                          child: Text('Ok')),
                                      TextButton(
                                          onPressed: () {
                                            if (isReadyTx) {
                                              disconnectFromDevice();
                                              Navigator.of(context).pop(true);
                                            }
                                          },
                                          child: Text('Volver')),
                                      Text(WiseGPSData.getTimeStamp()),
                                      Text(WiseGPSData.getFix()),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('LAT: ' + WiseGPSData.getLAT()),
                                          Text('LONG: ' + WiseGPSData.getLONG())
                                        ],
                                      ),
                                      Text('East Speed: ' +
                                          WiseGPSData.getSpeedEast() +
                                          '\t\tNorth Speed: ' +
                                          WiseGPSData.getSpeedNorth()),
                                      Text('aACC: ' +
                                          WiseGPSData.getaAcc() +
                                          '\t\tvACC: ' +
                                          WiseGPSData.getvAcc() +
                                          '\t\tsACC: ' +
                                          WiseGPSData.getsAcc()),
                                      Text('PDOP: ' + WiseGPSData.getPDOP()),
                                      Text('Visible SAT: ' +
                                          WiseGPSData.getSAT()),
                                      SizedBox(height: 80),
                                      TextButton(
                                          onPressed: () {
                                            if (isReadyTx) {
                                              writeData('@0');
                                            }
                                          },
                                          child: Text('OFF')),
                                    ],
                                  ),
                                );
                              } else {
                                return Text('Check the stream');
                              }
                            }))),
          )),
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
