import 'dart:ffi';

import 'package:http/http.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'dart:convert';
import 'package:collection/collection.dart';

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
    final Response res = await get("http://seprojects.nl:8080/authCurrent?uid=$uid",
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

  Future<List<ConsumeDataPerMonthPerUser>> getGroupConsumeData(
      {String mode = 'main'}) async {
    String gid = CurrentUser().groupId.toString();
    List<ConsumeDataPerMonthPerUser> placeHolderList;

    Response res;
    if (mode == 'test') {
      res = Response(json.encode({'001': 1, '002': 2}), 200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({'001': 1, '002': 2}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getTallyPerUserPerMonth?gid=$gid",
          headers: {'Content-Type': 'application/json'});
    }
    if (res.statusCode == 200) {
      placeHolderList =
          CurrentUser._listGroupDataFromJson(json.decode(res.body));
    } else {
      print("Could not make list of data");
    }
    return placeHolderList;
  }

  Future<List<ConsumeData>> getConsumeData({mode = 'main'}) async {
    String uid = CurrentUser().userId.toString();
    String gid = CurrentUser().groupId.toString();
    List<ConsumeData> placeHolderListConsumeData;

    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({
            '001': {'mon': 1},
            '002': {'mon': 1}
          }),
          200);
    } else if (mode == 'testfail') {
      res = Response(
          json.encode({
            '001': {'mon': 1},
            '002': {'mon': 1}
          }),
          400);
    } else {
      res = await get(
          "http://10.0.2.2:8080/getTallyPerUserPerDay?gid=$gid&uid=$uid",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is User) {
      return this.userId == other.userId;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(json["uid"], json["groupid"], json["global_permissions"],
        json["display_name"], json["picture_link"], json["group_permissions"]);
  }

  static Future<User> getUser(String cuid, {String mode = 'main'}) async {
    String uid = cuid;
    User placeholdesUser;
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({
            "global_permissions": "user",
            "uid": "001",
            "groupid": 0,
            "group_permissions": "groupAdmin",
            "display_name": "Q",
            "picture_link": "2019"
          }),
          200);
    } else if (mode == 'testfail') {
      res = Response(
          json.encode({
            "global_permissions": "user",
            "uid": "001",
            "groupid": 0,
            "group_permissions": "groupAdmin",
            "display_name": "Q",
            "picture_link": "2019"
          }),
          400);
    } else {
      res = await get("http://10.0.2.2:8080/authCurrent?uid=$uid",
          headers: {'Content-Type': 'application/json'});
    }

    if (res.statusCode == 200) {
      placeholdesUser = User.fromJson(json.decode(res.body));
    } else {
      print("Could not find user");
    }
    return placeholdesUser;
  }

  static Future<String> getSaldo(String uid, {String mode = 'main'}) async {
    String saldo = '0';
    Response res;
    if (mode == 'test') {
      res = Response(json.encode(0.1), 200);
    } else if (mode == 'testfail') {
      res = Response(json.encode(0.1), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getSaldoPerUser?uid=$uid",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is Group) {
      return this.users.every((el) {
        return other.users.contains(el);
      });
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

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

  static Future<Group> getGroup({mode = 'main'}) async {
    CurrentUser currentUser;
    if (mode == 'main') {
      currentUser = CurrentUser();
    } else {
      currentUser = CurrentUser.fromJson({
        "global_permissions": "",
        "uid": "",
        "groupid": 1,
        "group_permissions": "",
        "display_name": "",
        "picture_link": ""
      });
    }
    String groupId = currentUser.groupId.toString();
    Group currentGroup;
    Response res;
    if (mode == 'test') {
      res = Response(json.encode({'UserId0': '001', 'UserId1': '002'}), 200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getGroup?gid=$groupId",
          headers: {'Content-Type': 'application/json'});
    }
    if (res.statusCode == 200) {
      currentGroup = Group.fromJson(json.decode(res.body));
    } else {
      print(res.statusCode.toString());
      print('Could not find group');
    }
    return currentGroup;
  }

  static Future<List<Map>> getNamesAndPics(int gid,
      {String mode = 'main'}) async {
    List<Map> namePics = [];
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({
            '0': {'name': '001', 'picture': '2019'}
          }),
          200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getPicsAndNames?gid=$gid",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is House) {
      return this.groupId == other.groupId;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
        groupId: json['groupid'],
        createdAt: json['created_at'],
        houseName: json['name']);
  }
  static Future<House> getCurrentHouse({String mode = 'main'}) async {
    CurrentUser currentUser;
    if (mode == 'main') {
      currentUser = await CurrentUser.updateCurrentUser();
    } else {
      currentUser = CurrentUser.fromJson({
        "global_permissions": "",
        "uid": "",
        "groupid": 1,
        "group_permissions": "",
        "display_name": "",
        "picture_link": ""
      });
    }
    String groupID = currentUser.groupId.toString();
    House currentGroup;
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({'groupid': 1, 'created_at': 'now', 'name': 'nombre'}),
          200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getGroupName?gid=$groupID",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is BeerTally) {
      return this.product == other.product;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

  List<int> getCount() {
    return this.count;
  }

  static Future<BeerTally> getData(int gid, String product,
      {String mode = 'main'}) async {
    BeerTally beer;
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({
            'product': 'bier',
            '0': {'uid': '001', 'count': 1},
            '1': {'uid': '002', 'count': 1}
          }),
          200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getTally?gid=$gid&product=$product",
          headers: {'Content-Type': 'application/json'});
    }

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

  @override
  bool operator ==(other) {
    if (other is BeerEvent) {
      return this.gid == other.gid &&
          this.authorid == other.authorid &&
          this.targetid == other.targetid &&
          this.date == other.date;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

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

  static Future<List<BeerEvent>> getData(int gid,
      {String mode = 'main'}) async {
    List<BeerEvent> beerEvents;
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode([
            {
              'gid': 1,
              'authorid': '001',
              'authorname': 'henk',
              'targetid': '002',
              'targetname': 'karin',
              'product': 'bier',
              'mutation': 1,
              'date': 'now'
            }
          ]),
          200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getTallyEntries?gid=$gid",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is ConsumeData) {
      return this.date == other.date && this.amount == other.amount;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;
}

class Product {
  final double price;
  final String name;
  Product(this.price, this.name);

  @override
  bool operator ==(other) {
    if (other is Product) {
      return this.price == other.price && this.name == other.name;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;

  static Future<List<Product>> getData(int gid, {String mode = 'main'}) async {
    List<Product> products = [];
    Response res;
    if (mode == 'test') {
      res = Response(
          json.encode({
            '0': {'id': '001', 'name': 'nombre', 'price': 0.0}
          }),
          200);
    } else if (mode == 'testfail') {
      res = Response(json.encode({}), 400);
    } else {
      res = await get("http://10.0.2.2:8080/getAllProducts?gid=$gid",
          headers: {'Content-Type': 'application/json'});
    }
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

  @override
  bool operator ==(other) {
    if (other is ConsumeDataPerMonthPerUser) {
      return this.name == other.name && this.amount == other.amount;
    } else {
      return false;
    }
  }

  @override
  external int get hashCode;
}

//TODO:
//Class Schedules
//Class Group_Permissions
