import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
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

class Profilepage extends StatefulWidget {
  static String tag = 'profile_page';

  @override
  State<StatefulWidget> createState() => _Profilepage();
}

class _Profilepage extends State<Profilepage> {
  final fromkey = GlobalKey<FormState>();
  FormType _formType = FormType.editprofile;
  String _name;
  bool loginWithEmail;
  ProfileConstants profCons;

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

  File _image;

  Future<String> getImgUrl() async {
    String uid = await Auth().currentUser();
    String timeStamp =
        DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
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
    MultipartFile mf = MultipartFile.fromBytes(
        'file', await image.readAsBytes(),
        filename: timeStamp + 'testfile.png');

    var uri = Uri.parse("http://10.0.2.2:8080/files/upload");
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

  /*Future<User> getUser() async {
    String uid = await Auth().currentUser();
    User currentUser;
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentUser = User.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return currentUser;
  }*/

  /*Future<House> getHouse() async {
    User currentUser = await User.getCurrentUser();
    String groupID = currentUser.groupId.toString();
    House currentGroup;
    final Response res = await get(
        "http://10.0.2.2:8080/getGroupName?gid=$groupID",
        headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentGroup = House.fromJson(json.decode(res.body));
    } else {
      print("Could not find group");
    }
    return currentGroup;
  }*/

  void _sendChangePasswordEmail() async {
    final auth = Provider.of(context).auth;
    print(await auth.getUserIdToken());
    try {
      await auth.sendResetPasswordEmail(await auth.getEmailUser());
      print("ResetEmail send");
      try {
        await auth.signOut();
        print("loged out");
        //Navigator.pop(context);
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
          title: new Text(type),
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
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                ),
              ),
            ),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Opslaan"),
              onPressed: _submitnewname,
            ),
          ],
        );
      },
    );
  }

  void _submitnewname() async {
    if (fromkey.currentState.validate()) {
      fromkey.currentState.save();
      Navigator.pop(context);
      setState(() {});
      print(_name);
      String uid = await Auth().currentUser();
      final Response res = await get(
          "http://10.0.2.2:8080/userUpdateDisplayName?uid=$uid&displayname=$_name",
          headers: {'Content-Type': 'application/json'});
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
      _sendChangePasswordEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    //widgets variables
    final clipper = ClipPath(
      child: Container(
        color: Colors.red,
      ),
      clipper: getClipper(),
    );

    FutureBuilder<User> userDisplayname = FutureBuilder<User>(
      future: User.getCurrentUser(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.displayName,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          );
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return AnimatedLiquidCustomProgressIndicator();
      },
    );

    final userHouseText = Text(
      'Jouw huis',
      style: TextStyle(
        fontSize: 20.0,
        fontStyle: FontStyle.italic,
        color: Colors.white
      ),
    );

    FutureBuilder<House> userHouseName = FutureBuilder<House>(
      future: House.getCurrentHouse(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return new GestureDetector(
            onTap: () {
              print('hallo');
            },
            child: Text(snapshot.data.houseName,
            style: TextStyle(
              fontSize: 20,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),),
          );
          //return Text("Welcome, " + snapshot.data.displayName);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        }

        // By default, show a loading spinner.
        return AnimatedLiquidCustomProgressIndicator();
      },
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
                        color: Colors.black,
                        image: DecorationImage(
                            image: NetworkImage(imgUrl), fit: BoxFit.cover),
                        borderRadius: BorderRadius.circular(75.0),
                        border: Border.all(
                          color: Colors.white,
                          width: 4.0,
                        )));
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return Icon(Icons.photo_camera);
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
        backgroundColor: Colors.red,
      );

    final upperpart = new Container(
      color: Colors.red,
      height: MediaQuery.of(context).size.height / 3,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: <Widget>[
          Positioned(
            width: 150,
            top: 35,
            left: MediaQuery.of(context).size.width/2 - 75,
            child: profielimage,
          ),
          Positioned(
            width: 40,
            height: 40,
            top: 20,
            left: MediaQuery.of(context).size.width/2 - 75,
            child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.black,
                ),
                onPressed: () => {},
              ),
          )
        ],
      ),
    );

    final middelpart = new Container(
      color: Colors.redAccent,
      height: MediaQuery.of(context).size.height / 12,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          userDisplayname,
          VerticalDivider(color: Colors.white, thickness: 2,),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              userHouseText,
              userHouseName,
            ],
          ),
          VerticalDivider(color: Colors.white, thickness: 2,),
          Text("Saldo"),
        ],
      ),
    );


    return new Scaffold(
      body: Container(
          child: Column(
        children: <Widget>[
          upperpart,
          middelpart,
          Container(
            color: Colors.pink,
            height: 30,
            width: 30,
            
          )
        ],
      )),
      floatingActionButton: settingsButton,
    );

    /*return new Scaffold(
      body: new Stack(
        children: <Widget>[
          clipper,
          Positioned(
            width: 400.0,
            top: MediaQuery.of(context).size.height / 13,
            child: Column(
              children: <Widget>[
                GestureDetector(
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
                                    color: Colors.black,
                                    image: DecorationImage(
                                        image: NetworkImage(imgUrl),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(75.0),
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 4.0,
                                    )));
                          } else if (snapshot.hasError) {
                            return Text("${snapshot.error}");
                          }
                          return Icon(Icons.photo_camera);
                        }),
                  ),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    userDisplayname,
                    Column(
                      children: <Widget>[
                        Column(
                          children: <Widget>[userHouseText, userHouseName],
                        ),
                      ],
                    ),
                    Text('saldo')
                  ],
                ),
                SizedBox(
                  height: 30.0,
                  child: Container(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            width: 260,
            top: MediaQuery.of(context).size.height / 13,
            child: Container(
              width: 40,
              height: 40,
              child: FloatingActionButton(
                backgroundColor: Colors.white,
                child: Icon(
                  Icons.photo_camera,
                  color: Colors.black,
                ),
                onPressed: () => {},
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: FutureBuilder<ProfileConstants>(
          future: _makeProfileConstants(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return PopupMenuButton<String>(
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
        backgroundColor: Colors.red,
      ),
    );*/
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 2.5);
    path.lineTo(size.width, size.height / 2.5);
    path.lineTo(size.width, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return true;
  }
}
