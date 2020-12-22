class DirectionBeacon {
  int id;
  double x;
  double y;
  double distanceBeacon;
  String direction;
  String time;
  int huminity;
  String student;
  String deviceTypes;
  DirectionBeacon({
    this.id,
    this.x,
    this.y,
    this.distanceBeacon,
    this.direction,
    this.time,
    this.huminity,
    this.student,
    this.deviceTypes,
  });

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'id': id,
      'x': x,
      'y': y,
      'distanceBeacon': distanceBeacon,
      'direction': direction,
      'time': time,
      'huminity': huminity,
      'student': student,
      'deviceTypes': deviceTypes
    };
    return map;
  }

  DirectionBeacon.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    x = map['x'];
    y = map['y'];
    distanceBeacon = map['distanceBeacon'];
    direction = map['direction'];
    time = map['time'];
    huminity = map['huminity'];
    student = map['student'];
    deviceTypes = map['deviceTypes'];
  }
}

class DistanceTest {
  int idDistance;
  double distance;
  int idBeacon;
  DistanceTest({this.idDistance, this.distance, this.idBeacon});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      // 'idDistance': idDistance,
      'distance': distance,
      'idBeacon': idBeacon,
    };
    return map;
  }

  DistanceTest.fromMap(Map<String, dynamic> map) {
    idDistance = map['idDistance'];
    distance = map['distance'];
    idBeacon = map['idBeacon'];
  }
}

class IDBeaconss {
  int id;
  String idbeacons;
  IDBeaconss({this.id, this.idbeacons});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'idbeacons': idbeacons,
    };
    return map;
  }

  IDBeaconss.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    idbeacons = map['idbeacons'];
  }
}
