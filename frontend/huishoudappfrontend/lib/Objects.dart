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
  String group_permission;

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
    _instance.group_permission = json['group_permissions'];
    return _instance;
  }

  CurrentUser._internal() {
    if (this.userId == null) {
      updateCurrentUser();
    }
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

  static List<ConsumeData> _listFromJson(Map<String, dynamic> json) {
    List<ConsumeData> lst = new List<ConsumeData>();
    ConsumeData placeholder;
    json.forEach((k, v) => v.forEach((k1, v1) => lst.add(ConsumeData(k1, v1))));
    return lst;
  }

  Future<List<ConsumeData>> getConsumeData() async {
    String uid = CurrentUser().userId.toString();
    String gid = CurrentUser().groupId.toString();
    List<ConsumeData> placeHolderListConsumeData;
    final Response res = await get(
        "http://10.0.2.2:8080/getTallyPerUserPerDay?gid=$gid&uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      placeHolderListConsumeData =
          CurrentUser._listFromJson(json.decode(res.body));
    } else {
      print("Could not make list of data");
    }
    return placeHolderListConsumeData;
  }
}

class User extends BaseUser {
  User(userId, groupId, globalPermissions, displayName, picture_link) {
    this.userId = userId;
    this.groupId = groupId;
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
    final Response res = await get("http://10.0.2.2:8080/getGroup?gid=$groupId",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      currentGroup = Group.fromJson(json.decode(res.body));
    } else {
      print(res.statusCode.toString());
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
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      currentGroup = House.fromJson(json.decode(res.body));
    } else {
      print(res.statusCode);
      print("Could not find group");
    }
    return currentGroup;
  }
}

class BeerTally {
  //TODO: Link with group
  final Map<String, int> count;
  final Map<String, String> pics;

  BeerTally({this.count, this.pics});

  Map<String, int> getCount() {
    return this.count;
  }

  List<Map<String, int>> getCountAsList() {
    List<Map<String, int>> out = List<Map<String, int>>();
    this.count.forEach((k, v) {
      Map<String, int> single = Map<String, int>();
      single[k] = v;
      out.add(single);
    });

    return out;
  }

  Map<String, String> getPics() {
    return this.pics;
  }

  List<Map<String, String>> getPicsAsList() {
    List<Map<String, String>> out = List<Map<String, String>>();
    this.pics.forEach((k, v) {
      Map<String, String> single = Map<String, String>();
      single[k] = v;
      out.add(single);
    });

    return out;
  }

  static Future<BeerTally> getData(int gid) async {
    BeerTally beer;
    final Response res = await get(
        "http://10.0.2.2:8080/getTallyByName?gid=$gid",
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      beer = BeerTally.fromJson(json.decode(res.body));
    } else {
      print(res.statusCode);
      print("Could not find beer data");
    }
    return beer;
  }

  factory BeerTally.fromJson(Map<String, dynamic> json) {
    Map<String, int> count = new Map<String, int>();
    Map<String, String> pics = new Map<String, String>();
    json.forEach((k, v) {
      count[k] = v["count"];
      pics[k] = v["picture"];
    });
    return BeerTally(count: count, pics: pics);
  }

  String toString() {
    String out = "";
    this.count.forEach(
        (k, v) => out += k + " drank " + v.toString() + " beers" + "\n");
    return out;
  }
}

class BeerEvent {
  int gid;
  String authorid;
  String authorname;
  String targetid;
  String targetname;
  String date;
  int mutation;

  BeerEvent(this.gid, this.authorid, this.authorname, this.targetid,
      this.targetname, this.date, this.mutation);

  BeerEvent copyByVal() {
    return BeerEvent(this.gid, this.authorid, this.authorname, this.targetid,
        this.targetname, this.date, this.mutation);
  }

  static List<BeerEvent> fromJson(List<dynamic> json) {
    List<BeerEvent> out = List<BeerEvent>();
    json.forEach((event) {
      BeerEvent beer = new BeerEvent(
          event["gid"],
          event["authorid"],
          event["authorname"],
          event["targetid"],
          event["targetname"],
          event["date"],
          event["mutation"]);
      out.add(beer);
    });
    return out;
  }

  static Future<List<BeerEvent>> getData(int gid) async {
    List<BeerEvent> beerEvents;
    final Response res = await get(
        "http://10.0.2.2:8080/getTallyEntries?gid=$gid",
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      beerEvents = BeerEvent.fromJson(json.decode(res.body));
    } else {
      print("Could not find beer data");
    }
    return beerEvents;
  }
}

class ConsumeData {
  final String date;
  final int amount;
  ConsumeData(this.date, this.amount);
}

class Schedules {
  String taskName;
  List usersid;
  String endDate;
  String infoTask;

  Schedules(this.usersid);
}

//TODO:
//Class Schedules
//Class Group_Permissions
