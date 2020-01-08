import 'dart:io';

import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/login_widget.dart';
import 'package:huishoudappfrontend/profileconstants.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'Objects.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'services/permission_serivce.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:huishoudappfrontend/setup/widgets.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'design.dart';
import 'package:huishoudappfrontend/groupmanagement/groupsetup_widget.dart';

class Profilepage extends StatefulWidget {
  static String tag = 'profile_page';

  @override
  State<StatefulWidget> createState() => _Profilepage();
}

class _Profilepage extends State<Profilepage> {
  final fromkey = GlobalKey<FormState>();
  FormType _formType = FormType.editprofile;
  String _name;
  CurrentUser currentUser = CurrentUser();
  String userhouseName;
  bool loginWithEmail;
  ProfileConstants profCons;

  @override
  void initState() {
    super.initState();
    initActual();
  }

  Future<void> initActual() async {
    String temphouse = (await House.getCurrentHouse()).houseName;
    CurrentUser tempCurrentUser = await CurrentUser.updateCurrentUser();
    setState(() {
      userhouseName = temphouse;
      currentUser = tempCurrentUser;
    });
  }

  Future<bool> _loggedinWithEmail() async {
    final auth = Provider.of(context).auth;
    try {
      String loginMethode = (await auth.getUserIdToken());
      return (loginMethode == "password");
    } catch (e) {
      return false;
    }
  }

  Future<ProfileConstants> _makeProfileConstants() async {
    loginWithEmail = await _loggedinWithEmail();
    print('login met email =' + loginWithEmail.toString());
    profCons = ProfileConstants(loginWithEmail);
    return profCons;
  }

  Future<String> getImgUrl() async {
    String uid = await Auth().currentUser();
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://seprojects.nl:8080/files/users?uid=$uid&t=$timeStamp";
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
    var uid = await Auth().currentUser();
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
        'file', await image.readAsBytes(),
        filename: timeStamp + 'testfile.png');

    var uri = Uri.parse("http://seprojects.nl:8080/files/upload");
    var request = new MultipartRequest("POST", uri);
    request.fields['uid'] = uid;
    request.files.add(mf);

    var response = await request.send();
    if (response.statusCode == 302) setState(() {});
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

  Future<void> _sendChangePasswordEmail() async {
    final auth = Provider.of(context).auth;
    print(await auth.getUserIdToken());
    try {
      await auth.sendResetPasswordEmail(await auth.getEmailUser());
      print("ResetEmail send");
      try {
        await auth.signOut();
        print("loged out");
        Navigator.popUntil(context, ModalRoute.withName(LoginPage.tag));
      } catch (a) {
        print(a);
      }
    } catch (e) {
      print(e);
    }
  }

  void _showDialog(String type) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
          title: new Text(
            type,
            style: TextStyle(color: Colors.orange[700]),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: fromkey,
              child: new TextFormField(
                keyboardType: TextInputType.text,
                validator: NameValidator.validate,
                onSaved: (value) => _name = value,
                decoration: InputDecoration(
                  hintText: 'Je nieuwe naam',
                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(
                      color: Colors.orange[700],
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text(
                "Opslaan",
                style: TextStyle(color: Colors.orange[700]),
              ),
              onPressed: _submitnewname,
            ),
          ],
        );
      },
    );
  }

  void _kickUser() async {
    String uid = currentUser.userId;
    final Response res =
        await get("http://seprojects.nl:8080/deleteUserFromGroup?uid=$uid");
    if (json.decode(res.body)["result"] == "success") {
      //setState(() {
      //  visible = false;
      //});
      Navigator.popAndPushNamed(context, LoginPage.tag);
    }
  }

  void _kickUserDialog() {
    showDialog(
        context: (context),
        builder: (BuildContext context) {
          return (AlertDialog(
            title: Text("Jezelf uit jouw huis verwijderen"),
            content: Container(
              height: 100,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Text("Weet u zeker dat u uw huis wilt verlaten?"),
                  ),
                  Text("Al uw data zal hierdoor verloren gaan.")
                ],
              ),
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text(
                  "Verwijderen",
                  style: TextStyle(color: Colors.orange[700]),
                ),
                onPressed: _kickUser,
              ),
              new FlatButton(
                child: new Text(
                  "Anuleren",
                  style: TextStyle(color: Colors.orange[700]),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ));
        });
  }

  void _submitnewname() async {
    if (fromkey.currentState.validate()) {
      fromkey.currentState.save();
      Navigator.pop(context);
      print(_name);
      String uid = currentUser.userId;
      final Response res = await get(
          "http://seprojects.nl:8080/userUpdateDisplayName?uid=$uid&displayname=$_name",
          headers: {'Content-Type': 'application/json'});
      CurrentUser tempCurrentUser = await CurrentUser.updateCurrentUser();
      setState(() {
        currentUser = tempCurrentUser;
      });
    }
  }

  void _choiceAction(String choice) async {
    if (choice == profCons.editUserName) {
      _showDialog("Verander je naam");
    } else if (choice == profCons.signOut) {
      try {
        Auth auth = Provider.of(context).auth;
        await auth.signOut();
        //Navigator.pop(context);
      } catch (e) {
        print(e);
        print('logt niet uit');
      }
    } else if (choice == "Verander wachtwoord") {
      try {
        await _sendChangePasswordEmail();
      } catch (e) {
        print(e);
      }
    } else if (choice == profCons.huisVerlaten) {
      _kickUserDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    //widgets variables
    final clipper = ClipPath(
      child: Container(
        color: Design.rood,
      ),
      clipper: getClipper(),
    );

    final profielimage = GestureDetector(
      onTap: _imageOptionsDialogBox,
      child: Container(
        width: 150.0,
        height: 150.0,
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
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(75.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 1.0,
                        )));
              } else if (snapshot.hasError) {
                return Icon(Icons.person, color: Colors.white);
              }
              return Icon(
                Icons.photo_camera,
                color: Colors.green,
              );
            }),
      ),
    );

    FloatingActionButton settingsButton = FloatingActionButton(
      onPressed: () {},
      child: FutureBuilder<ProfileConstants>(
        future: _makeProfileConstants(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PopupMenuButton<String>(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              onSelected: _choiceAction,
              itemBuilder: (BuildContext context) {
                return snapshot.data.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
              icon: Icon(Icons.settings),
            );
          } else {
            return Icon(Icons.settings);
          }
        },
      ),
      backgroundColor: Design.rood,
    );

    final upperpart = new Container(
      color: Design.rood,
      height: (MediaQuery.of(context).size.height - Design.navBarHeight) * 0.30,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          clipper,
          Positioned(
            width: 150,
            top: 35,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: profielimage,
          ),
          Positioned(
            width: 40,
            height: 40,
            top: 20,
            left: MediaQuery.of(context).size.width / 2 - 75,
            child: FloatingActionButton(
              backgroundColor: Design.orange2,
              child: Icon(
                Icons.photo_camera,
                color: Colors.white,
              ),
              onPressed: () => _imageOptionsDialogBox(),
            ),
          )
        ],
      ),
    );

    final middelpart = new Material(
        
        child: Container(
          color: Design.rood,
          height: (MediaQuery.of(context).size.height - 50) * 0.08,
          width: MediaQuery.of(context).size.width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              //userDisplayname,
              Text(

                currentUser.displayName != null
                    ? currentUser.displayName
                    : "Laden...",

                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300
                  // fontStyle: FontStyle.italic,
                ),
              ),
              // VerticalDivider(
              //   color: Design.geel,
              //   thickness: 2,
              // ),

              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(userhouseName != null ? userhouseName : "Laden...", style: TextStyle( color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300)),
                ],
              ),

              // VerticalDivider(
              //   color: Design.geel,
              //   thickness: 2,
              // ),

              FutureBuilder<String>(
                future: User.getSaldo(currentUser.userId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("Saldo: "+ snapshot.data,style: TextStyle( color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w300));
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("${snapshot.error}");
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),

            ],
          ),
        ));

    final bottompart = new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
              decoration: new BoxDecoration(
                borderRadius: BorderRadius.circular(100.0),
              ),
              //height: (MediaQuery.of(context).size.height - 50) * 0.40,
              child: FutureBuilder<List<ConsumeData>>(
                future: CurrentUser().getConsumeData(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Card(
                        elevation: 3,
                        child: SfCartesianChart(
                            title: ChartTitle(
                              text: "Jouw bier data",
                              borderWidth: 8,
                              
                              alignment: ChartAlignment.near,
                              textStyle: ChartTextStyle(
                                color: Design.orange2,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            primaryXAxis: CategoryAxis(),
                            series: <ChartSeries>[
                              SplineSeries<ConsumeData, String>(
                                splineType: SplineType.monotonic,
                                dataSource: snapshot.data,
                                color: Design.orange2,
                                // borderMode: AreaBorderMode.excludeBottom,

                                // borderWidth: 2,
                                xValueMapper: (ConsumeData data, _) =>
                                    data.date,
                                yValueMapper: (ConsumeData data, _) =>
                                    data.amount,
                                dataLabelSettings:
                                    DataLabelSettings(isVisible: true),
                              )
                            ]),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text("${snapshot.error}");
                  } else {
                    return Center(
                        child: Container(
                      width: 100,
                      height: 100,
                      child: CircularProgressIndicator(),
                    ));
                  }
                },
              ))
        ]);

    return new Scaffold(
      body: ListView(
        children: <Widget>[
          Container(
            color: Colors.grey[100],
            child: Column(
              children: <Widget>[
                upperpart,
                middelpart,
                bottompart,
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: settingsButton,
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width * 1.9, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return true;
  }
}
