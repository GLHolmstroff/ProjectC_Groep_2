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
    userId = null;
    groupId = null;
    globalPermissions = null;
    displayName = null;
    if (this.userId == null) {
      updateCurrentUser();
    }
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
    json.forEach(
      (k, v) => v.forEach(
        (k1, v1) => lst.add(ConsumeData(k1, v1)),
      ),
    );

    return lst;
  }

  static List<ConsumeDataPerMonthPerUser> _listGroupDataFromJson(
      Map<String, dynamic> json) {
    List<ConsumeDataPerMonthPerUser> lst =
        new List<ConsumeDataPerMonthPerUser>();
    json.forEach((k, v) => lst.add(ConsumeDataPerMonthPerUser(k, v)));

    return lst;
  }

  Future<List<ConsumeDataPerMonthPerUser>> getGroupConsumeData() async {
    String gid = CurrentUser().groupId.toString();
    List<ConsumeDataPerMonthPerUser> placeHolderList;
    final Response res = await get(
        "http://10.0.2.2:8080/getTallyPerUserPerMonth?gid=$gid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      placeHolderList =
          CurrentUser._listGroupDataFromJson(json.decode(res.body));
    } else {
      print("Could not make list of data");
    }
    return placeHolderList;
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
  User(userId, groupId, globalPermissions, displayName, picture_link,
      group_permission) {
    this.userId = userId;
    this.groupId = groupId;
    this.globalPermissions = globalPermissions;
    this.displayName = displayName;
    this.picture_link = picture_link;
    this.group_permission = group_permission;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["uid"], json["groupid"], json["global_permissions"],
        json["display_name"], json["picture_link"], json["group_permissions"]);
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

  static Future<String> getSaldo(String uid) async {
    String saldo = '0';
    final Response res = await get(
        "http://10.0.2.2:8080/getSaldoPerUser?uid=$uid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      print(res.body);
      saldo = res.body;
    } else {
      print("could not find saldo");
    }
    return saldo;
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

  static Future<List<Map>> getNamesAndPics(int gid) async {
    List<Map> namePics = [];
    final Response res = await get(
        "http://10.0.2.2:8080/getPicsAndNames?gid=$gid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      namePics = Group.namePicfromJson(json.decode(res.body));
    } else {
      print(res.statusCode.toString());
      print('Could not find group');
    }
    return namePics;
  }

  static List<Map> namePicfromJson(Map json) {
    List<Map> namePics = [];
    for (int i = 0; i < json.length; i++) {
      namePics.add(json[i.toString()]);
    }
    return namePics;
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
  final List<int> count;
  final String product;

  BeerTally({this.count, this.product});

  List<int> getCount() {
    return this.count;
  }

  static Future<BeerTally> getData(int gid, String product) async {
    BeerTally beer;
    final Response res = await get(
        "http://10.0.2.2:8080/getTally?gid=$gid&product=$product",
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
    List<int> count = new List<int>();
    String product = json["product"];
    for (int i = 0; i < json.length - 1; i++) {
      count.add(json["$i"]["count"]);
    }
    return BeerTally(count: count, product: product);
  }

  String toString() {
    String out = "TODO:REMAKE TOSTRING";
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

class Product {
  final double price;
  final String name;
  Product(this.price, this.name);

  static Future<List<Product>> getData(int gid) async {
    List<Product> products = [];
    final Response res = await get(
        "http://10.0.2.2:8080/getAllProducts?gid=$gid",
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      products = Product.fromJson(json.decode(res.body));
    } else {
      print("Could not find beer data");
    }
    return products;
  }

  static List<Product> fromJson(Map<String, dynamic> json) {
    List<Product> products = [];
    for (int i = 0; i < json.length; i++) {
      products.add(
          Product(json[i.toString()]["price"], json[i.toString()]["name"]));
    }
    return products;
  }
}

class Schedules {
  String taskName;
  List usersid;
  String endDate;
  String infoTask;

  Schedules(this.usersid);
}

class ConsumeDataPerMonthPerUser {
  final String name;
  final int amount;
  ConsumeDataPerMonthPerUser(this.name, this.amount);
}

//TODO:
//Class Schedules
//Class Group_Permissions
