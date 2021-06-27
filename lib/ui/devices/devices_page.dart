import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicesPage extends StatefulWidget {
  final BluetoothDevice device;
  const DevicesPage({Key? key, required this.device}) : super(key: key);

  @override
  _DevicesPageState createState() => _DevicesPageState();
}

class _DevicesPageState extends State<DevicesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
