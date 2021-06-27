import 'package:flutter/material.dart';
import 'package:wise4sport/ui/search/ble_instance.dart';
import 'package:wise4sport/ui/search/search_dev.dart';

import '../../constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  double _sizeLogoRed = 150;

  @override
  void initState() {
    Future.delayed(
        Duration(milliseconds: delaySplash + 500),
        () => Navigator.of(context).pushReplacement(PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, _) {
              return FadeTransition(
                opacity: animation,
                child: BleInstance(),
              );
            })));

    super.initState();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var _sizeLogoWise = new Size(size.width * 5, size.height * 5);
    return SafeArea(
      child: Scaffold(
        body: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: 1),
          duration: const Duration(milliseconds: delaySplash),
          builder: (context, double value, _) {
            return Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                colors: [
                  Colors.blueGrey.shade200,
                  Colors.grey,
                  Colors.red.shade50,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomLeft,
              )),
              child: Stack(
                children: [
                  Positioned(
                      top: size.height / 2 - _sizeLogoWise.height / 2,
                      left: size.width / 2 - _sizeLogoWise.width / 2,
                      child: Opacity(
                        opacity: value,
                        child: Transform.scale(
                          scale: 1 - value.clamp(0, 0.77),
                          child: Image.asset(
                            "assets/images/wise.png",
                            height: _sizeLogoWise.height,
                            width: _sizeLogoWise.width,
                          ),
                        ),
                      )),
                  Positioned(
                    bottom: 25 * value - 80 * (1 - value),
                    left: size.width / 2 - _sizeLogoRed / 2,
                    child: Opacity(
                      opacity: value,
                      child: Image.asset(
                        "assets/images/redimec.png",
                        height: 35,
                        width: _sizeLogoRed,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
