import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wise4sport/ui/splash/splash.dart';

void main() {
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Wise4Sport',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Roboto'),
        ),
      ),
      home: SplashScreen(),
    );
  }
}