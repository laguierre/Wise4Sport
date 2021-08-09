import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsive{
  double _width = 0.0, _height = 0.0, _diagonal = 0.0;
  bool _isTablet = false;

  double get width => _width;
  double get heith => _height;
  double get diagonal => _diagonal;
  bool get isTable => _isTablet;

  static Responsive of(BuildContext context) => Responsive(context);
  Responsive(BuildContext context){
    final Size  size = MediaQuery.of(context).size;
    this._width = size.width;
    this._height = size.height;
    this._diagonal = math.sqrt(math.pow(_width, 2) + math.pow(_height, 2));
    this._isTablet = size.shortestSide >= 600;
  }
  double weightPercent(double percent) => _width * percent/100;
  double heightPercent(double percent) => _height * percent/100;
  double diagonalPercent(double percent) => _diagonal * percent/100;
}