import 'dart:core';

const int kGPSDataPackeSize = 6;
const int kIMUDataPackeSize = 6;
const int kWiseACK = 2;
const String delimiterGPS = ';';
const String delimiterIMU = ' ';

///Wise Classes///
class SendWiseCMD {
  static const String GPSCmdOn = '@3';
  static const String GPSCmdOff = '@3';
  static const String IMUCmdOn = '@8';
  static const String IMUCmdOff = '@8';
  static const String MEMCmd = '@M';
  static const String MACCmd = '@I';
  static const String HWVersionCmd = '@H';
}

class PageWise {
  static const int pageGPS = 0;
  static const int pageIMU = 1;
  static const int pageCFG = 2;
}

class WiseCFGDataClass {
  String mem = 'N/A';
  String hwVersion = 'N/A';
  String fwVersion = 'N/A';
  String mac = 'N/A';

  WiseCFGData(String mem, String hwVersion, String fwVersion, String mac) {
    this.mem = mem;
    this.hwVersion = hwVersion;
    this.fwVersion = fwVersion;
    this.mac = mac;
  }

  String getMem() {
    return this.mem;
  }

  void setMem(String mem) {
    this.mem = mem;
  }

  String getHwVersion() {
    return this.hwVersion;
  }

  void setHwVersion(String hwVersion) {
    this.hwVersion = hwVersion;
  }

  String getFwVersion() {
    return this.fwVersion;
  }

  void setFwVersion(String fwVersion) {
    this.fwVersion = hwVersion;
  }

  String getMAC() {
    return this.mac;
  }

  void setMAC(String mac) {
    this.mac = mac;
  }
}

class WiseGPSDataClass {
  WiseGPSData(
      String TimeStamp,
      String Lat,
      String Long,
      String VelE,
      String VelN,
      String ACC,
      String PDOP,
      String SAT,
      String Fix,
      String Flag,
      String aACC,
      String vACC,
      String sACC) {
    this.TimeStamp = TimeStamp;
    this.LAT = LAT;
    this.LONG = LONG;
    this.VelN = VelN;
    this.VelE = VelE;
    this.ACC = ACC;
    this.PDOP = PDOP;
    this.SAT = SAT;
    this.Fix = Fix;
    this.Flag = Flag;
    this.aACC = aACC;
    this.vACC = vACC;
    this.sACC = sACC;
  }

  String TimeStamp = 'N/A';
  String LAT = 'N/A';
  String LONG = 'N/A';
  String VelE = 'N/A';
  String VelN = 'N/A';
  String ACC = 'N/A';
  String PDOP = 'N/A';
  String SAT = 'N/A';
  String Fix = 'N/A';
  String Flag = 'N/A';
  String aACC = 'N/A';
  String vACC = 'N/A';
  String sACC = 'N/A';

  String getTimeStamp() {
    return this.TimeStamp;
  }

  String getLAT() {
    return this.LAT;
  }

  String getLONG() {
    return this.LONG;
  }

  String getSpeedEast() {
    return this.VelE;
  }

  String getSpeedNorth() {
    return this.VelN;
  }

  String getACC() {
    return this.ACC;
  }

  String getPDOP() {
    return this.PDOP;
  }

  String getSAT() {
    return this.SAT;
  }

  String getFix() {
    return this.Fix;
  }

  String getFlag() {
    return this.Flag;
  }

  String getsAcc() {
    return this.sACC;
  }

  String getaAcc() {
    return this.aACC;
  }

  String getvAcc() {
    return this.vACC;
  }
}

class WiseIMUDataClass {
  String p = 'N/A';
  String q = 'N/A';
  String v = 'N/A';
  String a = 'N/A';
  String m = 'N/A';

  WiseIMUData(String p, String q, String v, String a, String m) {
    this.p = p;
    this.q = q;
    this.v = v;
    this.a = a;
    this.m = m;
  }

  String getP() {
    return this.p;
  }

  void setP(String p) {
    this.p = p;
  }

  String getQ() {
    return this.q;
  }

  void setQ(String q) {
    this.q = q;
  }

  String getV() {
    return this.v;
  }

  void setV(String v) {
    this.v = v;
  }

  String getACC() {
    return this.a;
  }

  void setACC(String a) {
    this.a = a;
  }

  void setMAG(String m) {
    this.m = m;
  }

  String getMAG() {
    return this.m;
  }
}
