class User {
  final String userId;
  final int groupId;
  final String globalPermissions;
  final String displayName;

  User({this.userId,this.groupId,this.globalPermissions,this.displayName});

  factory User.fromJson(Map<String,dynamic> json) {
    return User(
      userId: json['uid'],
      groupId: json['groupid'],
      globalPermissions: json['global_permissions'],
      displayName: json['display_name'],
    );
  }

  @override
  String toString() {
    return "userID: " + this.userId + "\n" +
             "groupID: " + this.groupId.toString() + "\n" +
            "permission: " + this.globalPermissions + "\n" +
            "Name: " + this.displayName + "\n";
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

