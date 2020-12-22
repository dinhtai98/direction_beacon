import 'package:direction_device/beacon.dart';
import 'package:direction_device/flutter_blue_beacon.dart';
import 'package:direction_device/homeScreen.dart';
import 'package:direction_device/info_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'dart:async';

import 'package:postgres/postgres.dart';

void main() {
  runApp(FlutterBlueApp());
}

class FlutterBlueApp extends StatefulWidget {
  FlutterBlueApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _FlutterBlueAppState createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  FlutterBlueBeacon flutterBlueBeacon = FlutterBlueBeacon.instance;
  FlutterBlue _flutterBlue = FlutterBlue.instance;

  /// Scanning
  StreamSubscription _scanSubscription;
  // Map<int, Beacon> beacons = new Map();
  List<Beacon> beaconsss = [];
  bool isScanning = false;

  /// State
  StreamSubscription _stateSubscription;
  BluetoothState state = BluetoothState.unknown;

  TextEditingController huminityctl,
      directionctl,
      deviceTypectl,
      studentctl,
      x,
      y;
  int humnity = 0;
  String devicetypes = "";
  String direction = "";
  double vitriX = 1;
  double vitriY = 1;

  bool checkInfo = false;

  bool checkSave = false;

  List<String> listMucSV = ["Thưa", "Vừa", "Đông"];
  List<IDBeaconss> listIDBeacon = [
    IDBeaconss(id: 0, idbeacons: '60:77:71:8E:7E:59'), // BlueCharm màu tím
    IDBeaconss(id: 1, idbeacons: '60:77:71:8E:66:66'), // BlueCharm màu vàng
    IDBeaconss(id: 2, idbeacons: '60:77:71:8E:6F:A6'), // BlueCharm màu xám
  ];

// danh sách beacon san được tại vị trí đứng.
  List<DistanceTest> listDistanceBeacon;

  String selectedMucSV;

  GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey();
    huminityctl = TextEditingController();
    directionctl = TextEditingController();
    deviceTypectl = TextEditingController();
    studentctl = TextEditingController();
    x = TextEditingController();
    y = TextEditingController();

    x.text = vitriX.toString();
    y.text = vitriY.toString();

    // dropdown mức độ sinh viên
    listDropMucSV = builListDropdownMenuMucSV(listMucSV);
    selectedMucSV = listMucSV[0];
    // danh sách beacon san tại vi trí đứng.
    listDistanceBeacon = [];

    _flutterBlue.state.then((s) {
      setState(() {
        state = s;
      });
    });
    // Subscribe to state changes
    _stateSubscription = _flutterBlue.onStateChanged().listen((s) {
      setState(() {
        state = s;
      });
    });
  }

  @override
  void dispose() {
    _stateSubscription?.cancel();
    _stateSubscription = null;
    _scanSubscription?.cancel();
    _scanSubscription = null;
    super.dispose();
  }

  _showSnackBar(context, message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  List<DropdownMenuItem<String>> listDropMucSV;

  List<DropdownMenuItem<String>> builListDropdownMenuMucSV(List dsMucDoSV) {
    List<DropdownMenuItem<String>> item = List();
    for (String mucdosv in dsMucDoSV) {
      item.add(DropdownMenuItem(
        value: mucdosv,
        child: Text(mucdosv),
      ));
    }
    return item;
  }

  onChangedDropItemMucSV(String _selected) {
    setState(() {
      selectedMucSV = _selected;
      print(selectedMucSV);
    });
  }

// kiểm tra beacon scan được có thuộc danh sách beacon quản lý không?
  bool checkBeaconInList(Beacon b, List<IDBeaconss> listB) {
    for (IDBeaconss _bb in listB) {
      if (_bb.idbeacons == b.id) {
        return true;
      }
    }
    return false;
  }

  // get id của beacon quét được trong danh sách beacon quản lý
  int getIndexBeaconInList(Beacon b, List<IDBeaconss> listB) {
    for (IDBeaconss _bb in listB) {
      if (_bb.idbeacons == b.id) {
        return _bb.id;
      }
    }
    return null;
  }

  _startScan() {
    if (humnity == 0 || direction == "" || devicetypes == "") {
      _showSnackBar(context, "Vui lòng nhập đầy đủ thông tin!");
      return;
    }
    DateTime now = DateTime.now();
    setState(() {
      checkSave = !checkSave;
      checkInfo = true;
    });

    print("Scanning now");
    _scanSubscription = flutterBlueBeacon.scan(timeout: null).listen((beacon) {
      setState(() {
        // scan danh sách tín hiệu beacon để lưu vào data

        if (checkBeaconInList(beacon, listIDBeacon)) {
          if (!checkSave) {
            // xác định danh sách beacon cần lưu.
            if (listDistanceBeacon.length < 6) {
              listDistanceBeacon.add(DistanceTest(
                  distance: beacon.distance,
                  idBeacon: getIndexBeaconInList(beacon, listIDBeacon)));
            } else {
              int sodem0 = 0;
              int sodem1 = 0;
              int sodem2 = 0;
              double sum0 = 0;
              double sum1 = 0;
              double sum2 = 0;

              // tính giá trị trung bình của từng beacon của danh sách đã scan
              for (var i = 0; i < listDistanceBeacon.length; i++) {
                if (listDistanceBeacon[i].idBeacon == 0) {
                  sodem0++;
                  sum0 += listDistanceBeacon[i].distance;
                }
                if (listDistanceBeacon[i].idBeacon == 1) {
                  sodem1++;
                  sum1 += listDistanceBeacon[i].distance;
                }
                if (listDistanceBeacon[i].idBeacon == 2) {
                  sodem2++;
                  sum2 += listDistanceBeacon[i].distance;
                }
              }

              // if ((sum0 == 0 && sum1 == 0) ||
              //     (sum0 == 0 && sum2 == 0) ||
              //     (sum1 == 0 && sum2 == 0) ||
              //     (sum0 == 0 && sum1 == 0 && sum2 == 0))
              if (sum0 == 0 || sum1 == 0 || sum2 == 0) {
                // print("Không lưu được khoản giá trị này vui lòng Scan lại");
                _showSnackBar(context,
                    "Không lưu được khoản giá trị này vui lòng Scan lại");
              } else {
                _showSnackBar(context, "Đã lưu được tệp giá trị Beacon");
                // print(
                //     "===================================================================== $sum0 $sodem0 \n $sum1 $sodem1 \n $sum2 $sodem2 \n $direction ${now.hour} \n $humnity $selectedMucSV $devicetypes");

                // lưu dữ liệu scan được vào db với giá trị trung bình của từng beacon đã scan.
                insertDirectionBeacon(
                  vitriX,
                  vitriY,
                  // sum0 == 0 ? 0 : sum0 / sodem0,
                  // sum1 == 0 ? 0 : sum1 / sodem1,
                  // sum2 == 0 ? 0 : sum2 / sodem2,
                  sum0 / sodem0, sum1 / sodem1, sum2 / sodem2,
                  direction,
                  now.hour,
                  humnity,
                  selectedMucSV,
                  devicetypes,
                );
              }
              // trả lại dữ liệu ban đầu để tiếp tục xử lý tiếp theo.
              setState(() {
                sodem0 = 0;
                sodem1 = 0;
                sodem2 = 0;
                sum0 = 0;
                sum1 = 0;
                sum2 = 0;
                listDistanceBeacon = [];
                checkSave = !checkSave;
              });
            }
          }
        }
      });
    }, onDone: _stopScan);

    setState(() {
      isScanning = true;
    });
  }

  _stopScan() {
    print("Scan stopped");
    _scanSubscription?.cancel();
    _scanSubscription = null;
    setState(() {
      // thiết lập lại toàn bộ giá trị cho lần scan tiếp theo.
      huminityctl.text = "";
      deviceTypectl.text = "";
      directionctl.text = "";
      humnity = 0;
      direction = "";
      devicetypes = "";
      vitriX = 1;
      vitriY = 1;
      listDistanceBeacon = [];
      checkInfo = false;
      checkSave = false;
      isScanning = false;
    });
  }

  _buildScanningButton() {
    if (state != BluetoothState.on) {
      return null;
    }
    if (isScanning) {
      return new FloatingActionButton(
        child: new Icon(Icons.stop),
        onPressed: _stopScan,
        backgroundColor: Colors.red,
      );
    } else {
      return new FloatingActionButton(
          child: new Icon(Icons.search), onPressed: _startScan);
    }
  }

  // save data online.

  insertDirectionBeacon(
      double x,
      double y,
      double distanceBeacon1,
      double distanceBeacon2,
      double distanceBeacon3,
      String direction,
      int time,
      int huminity,
      String student,
      String devicetypes) async {
    var connection = new PostgreSQLConnection("27.71.233.181", 5432, "Beacon",
        username: "postgres", password: "CsiTeamAns@0719");
    await connection.open();
    await connection.query(
        "insert into map_direction(x,y,distancebeacon1,distancebeacon2,distancebeacon3,direction,time,huminity,student,devicetypes) values ('$x','$y','$distanceBeacon1','$distanceBeacon2','$distanceBeacon3','$direction','$time','$huminity','$student','$devicetypes')");
    await connection.close();
    return;
  }

// ====================================

  @override
  Widget build(BuildContext context) {
    final RaisedButton button = RaisedButton(
      onPressed: () {
        setState(() {
          checkSave = !checkSave;
        });
      },
      child: Icon(Icons.save_alt),
    );

    final RaisedButton addX = RaisedButton(
      onPressed: () {
        setState(() {
          vitriX += 1;
        });
        x.text = vitriX.toString();
      },
      child: Icon(Icons.add),
    );
    final RaisedButton addY = RaisedButton(
      onPressed: () {
        setState(() {
          vitriY += 1;
        });
        y.text = vitriY.toString();
      },
      child: Icon(Icons.add),
    );

    final RaisedButton subX = RaisedButton(
      onPressed: () {
        setState(() {
          vitriX -= 1;
        });
        x.text = vitriX.toString();
      },
      child: Text("-"),
    );
    final RaisedButton subY = RaisedButton(
      onPressed: () {
        setState(() {
          vitriY -= 1;
        });
        y.text = vitriY.toString();
      },
      child: Text("-"),
    );

    final TextField _x = TextField(
      controller: x,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Tọa độ x',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          vitriX = double.parse(text);
        });
      },
    );
    final TextField _y = TextField(
      controller: y,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Tọa độ y',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          vitriY = double.parse(text);
        });
      },
    );
    final TextField _txthumnity = TextField(
      controller: huminityctl,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          hintText: 'Nhập nhiệt độ',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          humnity = int.parse(text);
        });
      },
    );
    final TextField _txtdevicetype = TextField(
      controller: deviceTypectl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Loại thiết bị',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          devicetypes = text;
        });
      },
    );
    final TextField _txtdirection = TextField(
      controller: directionctl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
          hintText: 'Hướng di chuyển',
          contentPadding: EdgeInsets.all(10),
          border: InputBorder.none),
      autocorrect: false,
      onChanged: (text) {
        setState(() {
          direction = text;
        });
      },
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.white,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: HomeScreen(
        tfhumnity: _txthumnity,
        tfdevicetype: _txtdevicetype,
        tfdirection: _txtdirection,
        check: checkInfo,
        state: state,
        floatbutton: _buildScanningButton,
        mucSV: listDropMucSV,
        onChangeMucSV: onChangedDropItemMucSV,
        mucSVSelected: selectedMucSV,
        vitrix: _x,
        vitriy: _y,
        button: button,
        checkSave: checkSave,
        addX: addX,
        addY: addY,
        subX: subX,
        subY: subY,
        scaffoldkey: _scaffoldKey,
      ),
    );
  }
}
