// Import the test package and Counter class
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:huishoudappfrontend/Objects.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  //Set mocks for auth
  const MethodChannel('package:huishoudappfrontend/setup/auth.dart')
  .setMockMethodCallHandler((MethodCall methodCall) async {
    if (methodCall.method == 'currentUser') {
      return '001'; 
    }
    return null;
  });
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

    test('should read in from Json correctly',  ()  {
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

    test('value should be decremented', () {
      expect(0, 0);
    });
  });
}
