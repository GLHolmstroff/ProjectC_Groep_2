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
    List<String> users;
    String keyPart = "UserId";

    for( var i = 0; i < json.length; i++){
        String key = keyPart + i.toString();
        users.add(json[key]);
      }
    
    return Group(
      users: users
    );
  }
}

class BeerTally {
  //TODO: Link with group
  final Map<String,int> count;

  BeerTally({this.count});

  factory BeerTally.fromJson(Map<String,dynamic> json) {
    Map<String,int> count;
    json.forEach((k,v) => count[k] = v);
    
    return BeerTally(
      count: count
    );
  }
}

//TODO:
//Class Schedules
//Class Group_Permissions

