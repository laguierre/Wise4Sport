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
  bool isReadyRx = false;
  bool isReadyBatt = false;
  bool isReadyTx = false;
  late String Pitch = "", Roll = "", Yaw = "";

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
    var eulerList = eulerString.split(',');
    print(eulerList);
    if (eulerList.length == 3) {
      Pitch = (double.tryParse(eulerList[0]) ?? 0).toStringAsFixed(2);
      Yaw = (double.tryParse(eulerList[1]) ?? 0).toStringAsFixed(2); //roll
      Roll = (double.tryParse(eulerList[2]) ?? 0).toStringAsFixed(2);
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
                                      Text('$Pitch \t\t $Roll \t\t: $Yaw')
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

  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text(''),
          ),
        )) ??
        false;
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
              writeData("@0");
            }
            disconnectFromDevice();
            Navigator.of(context).pop(true);
          },
        ),
      ],
    );
  }

  /*Future<bool> _onWillPop() async{
    return ( await showDialog(
        context: context,
        builder: (context) =>
        ShowAlertDialog(context, "Are you sure?",
            "Do you want to disconnect device and go back", false) ??
            false));
*/

}
