import 'package:flutter/material.dart';

class WiseGPSDataClass {
  WiseGPSData(
      String timeStamp,
      String lat,
      String long,
      String velE,
      String velN,
      String acc,
      String PDOP,
      String sat,
      String fix,
      String flag,
      String aAcc,
      String vACC,
      String sACC) {
    this.timeStamp = timeStamp;
    this.lat = lat;
    this.long = long;
    this.velN = velN;
    this.velE = velE;
    this.acc = acc;
    this.PDOP = PDOP;
    this.sat = sat;
    this.fix = fix;
    this.flag = flag;
    this.aACC = aACC;
    this.vACC = vACC;
    this.sACC = sACC;
  }

  String timeStamp = 'N/A';
  String lat = 'N/A';
  String long = 'N/A';
  String velE = 'N/A';
  String velN = 'N/A';
  String acc = 'N/A';
  String PDOP = 'N/A';
  String sat = 'N/A';
  String fix = 'N/A';
  String flag = 'N/A';
  String aACC = 'N/A';
  String vACC = 'N/A';
  String sACC = 'N/A';

  String getTimeStamp() => this.timeStamp;

  String getLAT() => this.lat;

  String getLONG() => this.long;

  String getSpeedEast() => this.velE;

  String getSpeedNorth() => this.velN;

  String getACC() => this.acc;

  String getPDOP() => this.PDOP;

  String getSAT() => this.sat;

  String getFix() => this.fix;

  String getFlag() => this.flag;

  String getsAcc() => this.sACC;

  String getaAcc() => this.aACC;

  String getvAcc() => this.vACC;

  void setTimeStamp(String string) => this.timeStamp = string;

  void setLAT(String string) => this.lat = string;

  void setLONG(String string) => this.long = string;

  void setSpeedEast(String string) => this.velE = string;

  void setSpeedNorth(String string) => this.velN = string;

  void setACC(String string) => this.acc = string;

  void setPDOP(String string) => this.PDOP = string;

  void setSAT(String string) => this.sat = string;

  void setFix(String string) => this.fix = string;

  void setFlag(String string) => this.flag = string;

  void setsAcc(String string) => this.sACC = string;

  void setaAcc(String string) => this.aACC = string;

  void setvAcc(String string) => this.vACC = string;
}
