import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:huishoudappfrontend/login_widget.dart';
import 'package:huishoudappfrontend/setup/provider.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:huishoudappfrontend/page_container.dart';
import 'package:huishoudappfrontend/setup/validators.dart';
import 'Objects.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:toast/toast.dart';
import 'package:image_picker/image_picker.dart';

import 'services/permission_serivce.dart';

class Profilepage extends StatefulWidget {
  static String tag = 'profile_page';
  _Profilepage createState() => _Profilepage();
}

class _Profilepage extends State<Profilepage> {
  final fromkey = GlobalKey<FormState>();
  FormType _formType = FormType.editprofile;
  String _name;
  File _image;

  Future<String> getImgUrl() async{
    String uid = await Auth().currentUser();
    String timeStamp = DateTime.now().toString().replaceAllMapped(" ", (Match m) => "");
    return "http://10.0.2.2:8080/files/users?uid=$uid&t=$timeStamp";
  }

  Future<File> openGallery() async {
    var uid = await Auth().currentUser();
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    String timeStamp = DateTime.now().toString()
    .replaceAllMapped(" ", (Match m) => "")
    .replaceAllMapped(r':', (Match m)=>",")
    .replaceAllMapped(r'.', (Match m)=>",");
    MultipartFile mf = MultipartFile.fromBytes('file', await image.readAsBytes(), filename: timeStamp + 'testfile.png');
    
    var uri = Uri.parse("http://10.0.2.2:8080/files/upload");
    var request = new MultipartRequest("POST", uri);
    request.fields['uid'] = uid;
    request.files.add(mf);
    print(request.fields);
    var response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 302) setState(() {});
  }

  Future<File> openCamera() async {
    var uid = await Auth().currentUser();
    File image = await ImagePicker.pickImage(source: ImageSource.camera);
    String timeStamp = DateTime.now().toString()
    .replaceAllMapped(" ", (Match m) => "")
    .replaceAllMapped(r':', (Match m)=>",")
    .replaceAllMapped(r'.', (Match m)=>",");
    MultipartFile mf = MultipartFile.fromBytes('file', await image.readAsBytes(), filename: timeStamp + 'testfile.png');

    var uri = Uri.parse("http://10.0.2.2:8080/files/upload");
    var request = new MultipartRequest("POST", uri); 
    request.fields['uid'] = uid; 
    request.files.add(mf);

    var response = await request.send();
    if (response.statusCode == 200) print('Uploaded!');
  }

  Future<void> _imageOptionsDialogBox() {
  return showDialog(context: context,
    builder: (BuildContext context) {
        return AlertDialog(
          content: new SingleChildScrollView(
            child: new ListBody(
              children: <Widget>[
                GestureDetector(
                  child: new Text('Take a picture'),
                  onTap: () async {
                    var perm = PermissionsService();
                    if(!await perm.hasCameraPermission()){
                      perm.requestCameraPermission(
                        onPermissionDenied: () {
                          print('Permission has been denied');
                        }
                      );
                    }
                    openCamera();
                  },
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                ),
                GestureDetector(
                  child: new Text('Select from gallery'),
                  onTap: () async {
                    var perm = PermissionsService();
                    if(!await perm.hasStoragePermission()){
                      perm.requestStoragePermission(
                        onPermissionDenied: () {
                          print('Permission has been denied');
                        }
                      );
                    }
                    openGallery();
                    },
                ),
              ],
            ),
          ),
        );
      });
}

  Future<User> getUser() async {
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
  }

  Future<House> getHouse() async {

    User currentUser = await getUser();
    String groupID = currentUser.groupId.toString();
    House currentGroup;
    final Response res = await get("http://10.0.2.2:8080/getGroupName?gid=$groupID",
        headers: {'Content-Type': 'application/json'});
    print(res.statusCode);
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentGroup = House.fromJson(json.decode(res.body));
    } else {
      print("Could not find group");
    }
    return currentGroup;
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
      print(_name);
      String uid = await Auth().currentUser();
      final Response res = await get("http://10.0.2.2:8080/userUpdateDisplayName?uid=$uid&displayname=$_name",
        headers: {'Content-Type': 'application/json'});
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(
              color: Colors.black.withOpacity(0.9),
            ),
            clipper: getClipper(),
          ),
          Positioned(
            width: 400.0,
            top: MediaQuery.of(context).size.height / 5,
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
                        if(snapshot.hasData){
                          var imgUrl = snapshot.data;
                          print(imgUrl);
                          return Container(decoration: BoxDecoration(
                            color:Colors.black, 
                            image: DecorationImage(
                              image: NetworkImage(imgUrl)
                            ),
                            borderRadius: BorderRadius.circular(75.0),
                          )
                          );
                        }else if (snapshot.hasError) {
                          return Text("${snapshot.error}");
                        }
                        return CircularProgressIndicator();
                      }
                    ),
                  ),
                ),
                SizedBox(
                  height: 50.0,
                ),
                FutureBuilder<User>(
                  future: getUser(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return new GestureDetector(
                        onTap: () {
                          _showDialog("Verander je naam");
                        },
                        child: Text("Welkom, " + snapshot.data.displayName),
                      );
                      //return Text("Welcome, " + snapshot.data.displayName);
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
                Text(
                  'placeholder bijnaam',
                  style: TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                SizedBox(
                  height: 30.0,
                ),
                Column(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Text(
                          'Jouw huis',
                          style: TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        FutureBuilder<House>(
                          future: getHouse(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return new GestureDetector(
                                onTap: () {
                                  _showDialog("Verander je naam");
                                },
                                child: Text(
                                    snapshot.data.houseName),
                              );
                              //return Text("Welcome, " + snapshot.data.displayName);
                            } else if (snapshot.hasError) {
                              return Text("${snapshot.error}");
                            }

                            // By default, show a loading spinner.
                            return CircularProgressIndicator();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.0,
                ),
                Container(
                  height: 30.0,
                  width: 95.0,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    shadowColor: Colors.redAccent,
                    color: Colors.red,
                    elevation: 10.0,
                    child: GestureDetector(
                      onTap: () async {
                        try {
                          Auth auth = Provider.of(context).auth;
                          await auth.signOut();
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                          Navigator.pop(context);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Center(
                        child: Text(
                          'Log uit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = new Path();

    path.lineTo(0.0, size.height / 1.9);
    path.lineTo(size.width + 125, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldclipper) {
    return true;
  }
}
