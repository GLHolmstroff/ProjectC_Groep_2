import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huishoudappfrontend/Objects.dart';
import 'package:huishoudappfrontend/setup/auth.dart';
import 'package:mockito/mockito.dart';

class MockCurrentUser extends Mock implements CurrentUser {
  //Empty constructor needed for making Mocks
  MockCurrentUser();

  //Mock method for injecting test json
  static Future<CurrentUser> updateCurrentUser() async {
    return CurrentUser.fromJson({
      "global_permissions": "user",
      "uid": "JdQOZfDU0fclLWzqjMCfpp9m8hz2",
      "groupid": 1,
      "group_permissions": "groupAdmin",
      "display_name": "Quinten",
      "picture_link": "2019-12-0214,26,48,451629testfile.png"
    });
  }
}

class MockUser extends Mock implements User {
  
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('CurrentUser', () {
    test('should initialize to null', () {
      CurrentUser currentUser = CurrentUser();
      expect(currentUser.userId, null);
      expect(currentUser.groupId, null);
      expect(currentUser.globalPermissions, null);
      expect(currentUser.displayName, null);
      expect(currentUser.picture_link, null);
      expect(currentUser.group_permission, null);
    });

    test('should read in from Json correctly', () {
      Map<String, dynamic> json = {
        "global_permissions": "user",
        "uid": "JdQOZfDU0fclLWzqjMCfpp9m8hz2",
        "groupid": 1,
        "group_permissions": "groupAdmin",
        "display_name": "Quinten",
        "picture_link": "2019-12-0214,26,48,451629testfile.png"
      };

      CurrentUser user = CurrentUser.fromJson(json);
      expect(user.globalPermissions, 'user');
      expect(user.userId, 'JdQOZfDU0fclLWzqjMCfpp9m8hz2');
      expect(user.groupId, 1);
      expect(user.group_permission, 'groupAdmin');
      expect(user.displayName, 'Quinten');
      expect(user.picture_link, '2019-12-0214,26,48,451629testfile.png');
    });

    test('should be updated by updateCurrentUser', () async {
      CurrentUser user = CurrentUser();
      MockCurrentUser.updateCurrentUser();

      expect(user.globalPermissions, 'user');
      expect(user.userId, 'JdQOZfDU0fclLWzqjMCfpp9m8hz2');
      expect(user.groupId, 1);
      expect(user.group_permission, 'groupAdmin');
      expect(user.displayName, 'Quinten');
      expect(user.picture_link, '2019-12-0214,26,48,451629testfile.png');
    });

    test('should return consumedata', () async {
      CurrentUser user = MockCurrentUser();
      when(user.getConsumeData())
          .thenAnswer((_) => Future.value(List<ConsumeData>()));

      expect(await user.getConsumeData(), List<ConsumeData>());
    });

    test('should have correct string representation', () {
      CurrentUser user = CurrentUser();
      MockCurrentUser.updateCurrentUser();
      expect(user.toString(),
          "userID: JdQOZfDU0fclLWzqjMCfpp9m8hz2\ngroupID: 1\npermission: user\nName: Quinten\n");
    });
  });
  group('User', () {
    test('should be able to be constructed', () {
      var user = User('001', 1, 'user', 'Henk', 'NaN', 'user');
      expect(user.userId, '001');
      expect(user.groupId, 1);
      expect(user.globalPermissions, 'user');
      expect(user.displayName, 'Henk');
      expect(user.picture_link, 'NaN');
      expect(user.group_permission, 'user');
    });

    test('should read in from json correctly', () {
      Map<String, dynamic> json = {
        "global_permissions": "user",
        "uid": "JdQOZfDU0fclLWzqjMCfpp9m8hz2",
        "groupid": 1,
        "group_permissions": "groupAdmin",
        "display_name": "Quinten",
        "picture_link": "2019-12-0214,26,48,451629testfile.png"
      };

      User user = User.fromJson(json);
      expect(user.globalPermissions, 'user');
      expect(user.userId, 'JdQOZfDU0fclLWzqjMCfpp9m8hz2');
      expect(user.groupId, 1);
      expect(user.group_permission, 'groupAdmin');
      expect(user.displayName, 'Quinten');
      expect(user.picture_link, '2019-12-0214,26,48,451629testfile.png');
    });


  });

  group('House',() {
    test('should be constructed correctly', () {
      House house = House(groupId: 1, createdAt: 'now', houseName: 'name');
      expect(house.groupId, 1);
      expect(house.createdAt, 'now');
      expect(house.houseName, 'name');
    });

    test('should read in from json correctly', () {
      Map<String, dynamic> json = {
        "created_at": "now",
        "name": "name",
        "groupid": 1,
        
      };

      House house = House.fromJson(json);
      expect(house.groupId, 1);
      expect(house.createdAt, 'now');
      expect(house.houseName, 'name');
    });
  });
}
