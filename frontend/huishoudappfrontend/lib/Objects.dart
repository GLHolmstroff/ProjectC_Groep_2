import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';

class User {
  final String userId;
  final int groupId;
  final String globalPermissions;
  final String displayName;

  User({this.userId, this.groupId, this.globalPermissions, this.displayName});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['uid'],
      groupId: json['groupid'],
      globalPermissions: json['global_permissions'],
      displayName: json['display_name'],
    );
  }

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

  static Future<User> getCurrentUser() async {
    String uid = await Auth().currentUser();
    return getUser(uid);
  }

  static Future<User> getUser(String cuid) async {
    String uid = cuid;
    User currentUser;
    final Response res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      currentUser = User.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return currentUser;
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
