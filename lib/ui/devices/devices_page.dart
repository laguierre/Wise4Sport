import 'dart:async';
import 'dart:convert' show utf8;

import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:vector_math/vector_math.dart' as VMath;

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
  bool isReady = false;
  bool isReadyBatt = false;
  bool isReadyTx = false;

  _DevicesPageState();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isReady = false;
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
      if (!isReady) {
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
              isReady = true;
            });
          }
          if (characteristic.uuid.toString().toUpperCase() ==
              CHARACTERISTIC_UUID_TX) {
            characteristicDeviceTx = characteristic;
            setState(() {
              isReadyTx = true;
              writeData("@O");
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
    if (!isReady) {
      Navigator.of(context).pop(true); //_Pop();
    }
  }

   _dataParser(List<int>dataFromDevice)  {
    var eulerString = utf8.decode(dataFromDevice);
    var eulerList = eulerString.split(',');
  }

  writeData(String Data) async {
    if (characteristicDeviceTx == null) {
      return;
    }
    List<int> bytes = utf8.encode(Data);
    characteristicDeviceTx.write(bytes);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text(widget.device.name),
          ),
          body: SafeArea(
            child: Container(
                child: !isReady
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Waiting...",
                            ),
                            const SizedBox(
                              height: 15,
                            ),
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
                                if(snapshot.hasData)
                                _dataParser(snapshot.data!);
                                return Center(
                                  child: Column(
                                    children: [],
                                  ),
                                );
                              } else {
                                return Text('Check the stream');
                              }
                            }))),
          )),
    );
  }

  AlertDialog ShowAlertDialog(
      BuildContext context, String title, String content, bool OnOff) {
    return new AlertDialog(
      elevation: 50,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15))),
      title: Text('Prueba'),
      content: Text('Prueba'),
      actions: <Widget>[
        new TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: new Text(
              'No',
              style: TextStyle(color: Colors.black, fontSize: 18),
            )),
        new TextButton(
          child: new Text(
            'Yes',
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          onPressed: () {
            if (OnOff) {
              writeData("@O");
            }
            disconnectFromDevice();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }
}
