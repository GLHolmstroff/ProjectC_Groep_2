import 'dart:collection';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:huishoudappfrontend/design.dart';
import 'package:huishoudappfrontend/schedules/schoonmaakrooster_widget.dart';
import 'package:huishoudappfrontend/services/permission_serivce.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../profile.dart';
import '../Objects.dart';
import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'admintaskadder_widget.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ClickedOnTask extends StatefulWidget {
  static String tag = "clickedontask_widget";

  final Map clickedTask;

  const ClickedOnTask({Key key, this.clickedTask}) : super(key: key);

  @override
  _ClickedOnTaskState createState() => _ClickedOnTaskState();
}

class _ClickedOnTaskState extends State<ClickedOnTask> {
  bool taskDone = false;
  Map task;

  void initState() {
    super.initState();
    initActual();
  }

  initActual() async {
    var res = await get(
        "http://seprojects.nl:8080/getTask?tid=${widget.clickedTask["taskid"]}");
    if (res.statusCode == 200) {
      var jsonTask = json.decode(res.body);
      setState(() {
        task = jsonTask;
      });
    } else {
      print(res.statusCode);
    }
  }

  Future<String> getImgUrl() async {
    int tid = task["taskid"];
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://seprojects.nl:8080/files/tasks?tid=$tid&t=$timeStamp";
  }

  Future<File> openGallery() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    _updateImage(image);
  }

  Future<File> openCamera() async {
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    _updateImage(image);
  }

  Future<void> _updateImage(File image) async {
    String timeStamp = DateTime.now()
        .toString()
        .replaceAllMapped(" ", (Match m) => "")
        .replaceAllMapped(r':', (Match m) => ",")
        .replaceAllMapped(r'.', (Match m) => ",");

    final Directory tempDir = await getTemporaryDirectory();
    File compressed = await FlutterImageCompress.compressAndGetFile(
        image.absolute.path, "${tempDir.path}/temp.png");
    while (compressed.lengthSync() > 120000) {
      compressed = await FlutterImageCompress.compressAndGetFile(
          compressed.absolute.path, "${tempDir.path}/temp.png",
          quality: 80);
    }

    MultipartFile mf = MultipartFile.fromBytes(
        'file', await compressed.readAsBytes(),
        filename: timeStamp + 'taskfile.png');

    var uri = Uri.parse("http://seprojects.nl:8080/files/uploadtask");
    var request = new MultipartRequest("POST", uri);
    request.fields['taskid'] = widget.clickedTask["taskid"].toString();
    request.files.add(mf);

    var response = await request.send();
    if (response.statusCode == 302) {
      var res = await get(
          "http://seprojects.nl:8080/getTask?tid=${widget.clickedTask["taskid"]}");
      if (res.statusCode == 200) {
        var task = json.decode(res.body);
        setState(() {});
      } else {
        print(res.statusCode);
      }
    }
  }

  Future<void> _imageOptionsDialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: new SingleChildScrollView(
              child: new ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: new Text('Take a picture'),
                    onTap: () async {
                      var perm = PermissionsService();
                      if (!await perm.hasCameraPermission()) {
                        perm.requestCameraPermission(onPermissionDenied: () {
                          print('Permission has been denied');
                        });
                      }
                      openCamera();
                      Navigator.pop(context);
                    },
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                  GestureDetector(
                    child: new Text('Select from gallery'),
                    onTap: () async {
                      var perm = PermissionsService();
                      if (!await perm.hasStoragePermission()) {
                        perm.requestStoragePermission(onPermissionDenied: () {
                          print('Permission has been denied');
                        });
                      }
                      openGallery();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget titleWidget() {
    return Container(
      height: 125,
      child: Text(
        widget.clickedTask["taskname"],
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: 30, color: Colors.white),
      ),
      alignment: Alignment(-0.8, 0.8),
      decoration: BoxDecoration(
          color: Design.materialRood,
          boxShadow: [BoxShadow(color: Design.materialRood, blurRadius: 15.0)]),
    );
  }

  Widget dueDate() {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            "Einddatum taak:",
            style: TextStyle(fontSize: 16),
          ),
          Spacer(),
          Text(
            widget.clickedTask["datedue"],
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget isTaskDone() {
    if (widget.clickedTask["done"] == 0) {
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Taak afgerond?", style: TextStyle(fontSize: 16)),
                Spacer(),
                Checkbox(
                  value: taskDone,
                  onChanged: (bool value) {
                    setState(() {
                      taskDone = value;
                    });
                  },
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Text("Bijgevoegde foto:", style: TextStyle(fontSize: 16)),
            SizedBox(height: 5.0),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Card(
                elevation: 3,
                child: InkWell(
                  child: FutureBuilder<String>(
                      future: getImgUrl(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          var imgUrl = snapshot.data;
                          print(imgUrl);
                          return Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      imgUrl,
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.0,
                                  )));
                        } else if (snapshot.hasError) {
                          return Icon(Icons.error);
                        }
                        return Icon(
                          Icons.photo_camera,
                          color: Colors.green,
                        );
                      }),
                  onTap: () {
                    _imageOptionsDialogBox();
                  },
                ),
              ),
            ),
          ],
        ),
      );
    }
    return Container(height: 0);
  }

  Widget showApprovals() {
    if (widget.clickedTask["done"] == 1) {
      var value = widget.clickedTask["approvals"];
      return Row(
        children: <Widget>[
          Text("Goedkeuringen: ", style: TextStyle(fontSize: 16)),
          Spacer(),
          Text("$value/3", style: TextStyle(fontSize: 16))
        ],
      );
    }
    return Container(height: 0);
  }

  Future<void> makeTaskDone() async {
    var tid = widget.clickedTask["taskid"];

    final Response res = await get(
        "http://seprojects.nl:8080/makeTaskDone?tid=$tid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: "Taak zit nu in beoordelingsfase");
      Navigator.pop(context);
    } else {
      print(res.statusCode.toString());
    }
  }

  Future<void> endTask() async {
    var tid = widget.clickedTask["taskid"];

    final Response res = await get("http://seprojects.nl:8080/endTask?tid=$tid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      Fluttertoast.showToast(msg: "Taak is helemaal afgerond!");
      Navigator.pop(context);
    } else {
      print(res.statusCode.toString());
    }
  }

  Widget endTaskButton() {
    if (widget.clickedTask["approvals"] >= 3) {
      return Center(
        child: RaisedButton(
          child: Text(
            "Taak volledig afronden",
            style: TextStyle(fontSize: 16),
          ),
          onPressed: () {
            endTask();
          },
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36.0),
              side: BorderSide(color: Design.orange2)),
        ),
      );
    }
    return Container(height: 0);
  }

  void buttonPressAction() {
    if (taskDone) {
      makeTaskDone();
    } else {
      Navigator.pop(context);
    }
  }

  Widget buildButton() {
    return Center(
      child: RaisedButton(
        child: Text(
          "Gereed",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: () {
          buttonPressAction();
        },
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(36.0),
            side: BorderSide(color: Design.materialRood)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            titleWidget(),
            Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 50),
                  dueDate(),
                  SizedBox(height: 40),
                  isTaskDone(),
                  SizedBox(height: 50),
                  showApprovals(),
                  SizedBox(height: 10),
                  endTaskButton(),
                  SizedBox(height: 10),
                  buildButton()
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
