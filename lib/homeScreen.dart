import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    Key key,
    @required this.tfhumnity,
    @required this.tfdevicetype,
    @required this.tfdirection,
    @required this.check,
    this.state,
    this.floatbutton,
    @required this.mucSV,
    @required this.onChangeMucSV,
    @required this.mucSVSelected,
    this.vitrix,
    this.vitriy,
    this.button,
    this.checkSave,
    this.addX,
    this.addY,
    this.scaffoldkey,
    this.subX,
    this.subY,
  }) : super(key: key);
  final Function floatbutton;
  final BluetoothState state;

  final TextField vitrix;
  final TextField vitriy;
  final TextField tfdirection;
  final TextField tfhumnity;
  final TextField tfdevicetype;
  final bool check;
  final bool checkSave;
  final List<DropdownMenuItem<String>> mucSV;
  final Function onChangeMucSV;
  final String mucSVSelected;
  final RaisedButton button;
  final RaisedButton addX;
  final RaisedButton addY;

  final RaisedButton subX;
  final RaisedButton subY;
  final GlobalKey scaffoldkey;

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    return Scaffold(
      key: scaffoldkey,
      appBar: AppBar(
        title: const Text('Map Beacon'),
        centerTitle: false,
      ),
      floatingActionButton: floatbutton(),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            state != BluetoothState.on
                ? Container(
                    color: Colors.redAccent,
                    child: new ListTile(
                      title: new Text(
                        'Bluetooth adapter is ${state.toString().substring(15)}',
                        style: Theme.of(context).primaryTextTheme.subhead,
                      ),
                      trailing: new Icon(
                        Icons.error,
                        color: Theme.of(context).primaryTextTheme.subhead.color,
                      ),
                    ),
                  )
                : Container(
                    child: Column(
                      children: [
                        (check) ? LinearProgressIndicator() : new Container(),
                        !check ? Text(now.hour.toString()) : Container(),
                        !check
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: tfdirection)
                            : Container(),
                        !check
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: tfhumnity)
                            : Container(),
                        !check
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("Mức độ sinh viên:"),
                                  Container(
                                    width: 100,
                                    child: DropdownButton(
                                        isExpanded: true,
                                        items: mucSV,
                                        value: mucSVSelected,
                                        onChanged: onChangeMucSV),
                                  ),
                                ],
                              )
                            : Container(),
                        !check
                            ? Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, bottom: 10),
                                decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 240, 240, 240),
                                    border: Border.all(
                                        width: 1.2, color: Colors.black12),
                                    borderRadius: const BorderRadius.all(
                                        const Radius.circular(10))),
                                child: tfdevicetype)
                            : Container(),

                        // thiết kế lại các nhập thông tin.
                        checkSave
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("X: "),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8 /
                                          2,
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                          border: Border.all(
                                              width: 1.2,
                                              color: Colors.black12),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      child: vitrix),
                                  Column(
                                    children: [addX, subX],
                                  )
                                ],
                              )
                            : Container(),
                        checkSave
                            ? Divider(
                                color: Colors.black45,
                                indent: 15,
                              )
                            : Container(),
                        checkSave
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text("Y: "),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8 /
                                          2,
                                      margin: EdgeInsets.only(
                                          left: 20, right: 20, bottom: 10),
                                      decoration: BoxDecoration(
                                          color: Color.fromARGB(
                                              255, 240, 240, 240),
                                          border: Border.all(
                                              width: 1.2,
                                              color: Colors.black12),
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(10))),
                                      child: vitriy),
                                  Column(
                                    children: [addY, subY],
                                  )
                                ],
                              )
                            : Container(),
                        checkSave
                            ? Divider(
                                color: Colors.black45,
                                indent: 15,
                              )
                            : Container(),
                        checkSave ? button : Container(),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
