
class BaseUser  {
  String userId;
  int groupId;
  String globalPermissions;
  String displayName;

  @override
  String toString() {
    return "userID: " + User._instance.userId + "\n" +
             "groupID: " + this.groupId.toString() + "\n" +
            "permission: " + this.globalPermissions + "\n" +
            "Name: " + this.displayName + "\n";
  }
}

class User extends BaseUser{
  static final User _instance =  User._internal(); 
  
  factory User(){
    return _instance;
  }

  factory User.fromJson(Map<String,dynamic> json) {
      _instance.userId = json['uid'];
      _instance.groupId = json['groupid'];
      _instance.globalPermissions = json['global_permissions'];
      _instance.displayName = json['display_name'];
      return _instance;
  }

  User._internal(){
    userId = null;
    groupId = null;
    globalPermissions = null;
    displayName = null;
  } 
}

class Group {
  //TODO: Add groupid, etc. and ways to query them
  final List<String> users;

  

  Group({this.users});

  factory Group.fromJson(Map<String,dynamic> json) {
    List<String> users = new List<String>();
    String keyPart = "UserId";

    for( var i = 0; i < json.length; i++){
        String key = keyPart + i.toString();
        users.add(json[key]);
      }
    
    return Group(
      users: users
    );
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


    factory House.fromJson(Map<String,dynamic> json) {
    return House(
      groupId: json['groupid'],
      createdAt: json['created_at'],
      houseName: json['name']
    );
  }
    
}

class BeerTally {
  //TODO: Link with group
  final Map<String,int> count;

  BeerTally({this.count});

  Map<String,int> getCount(){
    return this.count;
  }

  factory BeerTally.fromJson(Map<String,dynamic> json) {
    Map<String,int> count = new Map<String, int>();
    json.forEach((k,v) => count[k] = v);
    
    return BeerTally(
      count: count
    );
  }

  String toString(){
    String out = "";
    this.count.forEach((k,v) => out += k + " drank " + v.toString() + " beers" + "\n");
    return out;
  }
}

//TODO:
//Class Schedules
//Class Group_Permissions

