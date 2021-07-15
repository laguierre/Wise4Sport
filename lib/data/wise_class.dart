///Wise Classes///
class SendWiseCMD {
  static const String GPSCmdOn = '@3';
  static const String GPSCmdOff = '@3';
  static const String IMUCmdOn = '@8';
  static const String IMUCmdOff = '@8';
}

class PageWise {
  static const int pageGPS = 0;
  static const int pageIMU = 1;
  static const int pageCFG = 3;
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

  String TimeStamp = '';
  String LAT = '';
  String LONG = '';
  String VelE = '';
  String VelN = '';
  String ACC = '';
  String PDOP = '';
  String SAT = '';
  String Fix = '';
  String Flag = '';
  String aACC = '';
  String vACC = '';
  String sACC = '';

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
