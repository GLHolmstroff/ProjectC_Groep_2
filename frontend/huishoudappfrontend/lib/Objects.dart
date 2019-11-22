import 'dart:ffi';

import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';

class BaseUser {
  String userId;
  int groupId;
  String globalPermissions;
  String displayName;
  String picture_link;

  @override
  String toString() {
    return "userID: " +
        this.userId +
        "\n" +
        "groupID: " +
        this.groupId.toString() +
        "\n" +
        "permission: " +
        this.globalPermissions +
        "\n" +
        "Name: " +
        this.displayName +
        "\n";
  }
}

class CurrentUser extends BaseUser {
  static final CurrentUser _instance = CurrentUser._internal();

  factory CurrentUser() {
    return _instance;
  }

  factory CurrentUser.fromJson(Map<String, dynamic> json) {
    _instance.userId = json['uid'];
    _instance.groupId = json['groupid'];
    _instance.globalPermissions = json['global_permissions'];
    _instance.displayName = json['display_name'];
    _instance.picture_link = json['picture_link'];
    return _instance;
  }

  CurrentUser._internal() {
    userId = null;
    groupId = null;
    globalPermissions = null;
    displayName = null;
  }

  static Future<CurrentUser> updateCurrentUser() async {
    String uid = await Auth().currentUser();
    CurrentUser placehoderCurrentUser;
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      placehoderCurrentUser = CurrentUser.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return placehoderCurrentUser;
  }
}

class User extends BaseUser {
  User(userId, groupId, globalPermissions, displayName, picture_link) {
    this.userId = userId;
    this.userId = groupId;
    this.globalPermissions = globalPermissions;
    this.displayName = displayName;
    this.picture_link = picture_link;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["uid"], json["groupid"], json["global_permissions"],
        json["display_name"], json["picture_link"]);
  }

  static Future<User> getUser(String cuid) async {
    String uid = cuid;
    User placeholdesUser;
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      placeholdesUser = User.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return placeholdesUser;
  }
}

class Group {
  //TODO: Add groupid, etc. and ways to query them
  final List<String> users;

  Group({this.users});

  factory Group.fromJson(Map<String, dynamic> json) {
    List<String> users = new List<String>();
    String keyPart = "UserId";

    for (var i = 0; i < json.length; i++) {
      String key = keyPart + i.toString();
      users.add(json[key]);
    }

    return Group(users: users);
  }

  String toString() {
    String out = "";
    this.users.forEach((el) => out += el + "\n");
    return out;
  }

  static Future<Group> getGroup() async {
    CurrentUser currentUser = CurrentUser();
    String groupId = currentUser.groupId.toString();
    Group currentGroup;
    final Response res = await get("http://10.0.2.2:8080/getAllInGroup?gid=$groupId",
        headers: {'Content-Type': 'application/json'});
        if(res.statusCode == 200){
          currentGroup = Group.fromJson(json.decode(res.body));
        } else {
          print('Could not find group');
        }
    return currentGroup;
  }
}

class House {
  final int groupId;
  final String createdAt;
  final String houseName;

  House({this.groupId, this.createdAt, this.houseName});

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
        groupId: json['groupid'],
        createdAt: json['created_at'],
        houseName: json['name']);
  }
  static Future<House> getCurrentHouse() async {
    CurrentUser currentUser = await CurrentUser.updateCurrentUser();
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
  }
}

class BeerTally {
  //TODO: Link with group
  final Map<String, int> count;

  BeerTally({this.count});

  Map<String, int> getCount() {
    return this.count;
  }

  factory BeerTally.fromJson(Map<String, dynamic> json) {
    Map<String, int> count = new Map<String, int>();
    json.forEach((k, v) => count[k] = v);

    return BeerTally(count: count);
  }

  String toString() {
    String out = "";
    this.count.forEach(
        (k, v) => out += k + " drank " + v.toString() + " beers" + "\n");
    return out;
  }
}

//TODO:
//Class Schedules
//Class Group_Permissions
