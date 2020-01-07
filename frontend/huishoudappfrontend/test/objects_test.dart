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

class MockUser extends Mock implements User {}

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
    test('should return correct consumedata', () async {
      CurrentUser user = CurrentUser();
      var result = await user.getConsumeData(mode: 'test');
      var expected = [ConsumeData('mon', 1), ConsumeData('mon', 1)];
      expect(result, expected);
    });

    test('should return null on fail to get consumedata', () async {
      CurrentUser user = CurrentUser();
      var result = await user.getConsumeData(mode: 'testfail');
      expect(result, null);
    });

    test('should return correct groupconsumedata', () async {
      CurrentUser user = CurrentUser();
      var result = await user.getGroupConsumeData(mode: 'test');
      var expected = [
        ConsumeDataPerMonthPerUser('001', 1),
        ConsumeDataPerMonthPerUser('002', 2)
      ];
      expect(result, expected);
    });

    test('should return null on fail to get groupconsumedata', () async {
      CurrentUser user = CurrentUser();
      var result = await user.getGroupConsumeData(mode: 'testfail');
      expect(result, null);
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

    test('should return correct user', () async {
      var result = await User.getUser('', mode: 'test');
      var expected = User('001', 0, 'user', 'Q', '2019', 'groupAdmin');
      expect(result, expected);
    });

    test('should return null on fail to get user', () async {
      var result = await User.getUser('', mode: 'testfail');
      expect(result, null);
    });

    test('should return correct saldo', () async {
      var result = await User.getSaldo('', mode: 'test');
      var expected = '0.1';
      expect(result, expected);
    });

    test('should return 0 on fail to get saldo', () async {
      var result = await User.getSaldo('', mode: 'testfail');
      expect(result, '0');
    });
  });

  group('Group', () {
    test('should be constructed correctly', () {
      Group house = Group(users: ['001']);
      expect(house.users, ['001']);
    });

    test('should read in from json correctly', () {
      Map<String, dynamic> json = {
        "UserId0": "001",
        "UserId1": "002",
      };

      Group house = Group.fromJson(json);
      expect(house.users, ['001', '002']);
    });

    test('should have correct string representation', () {
      Group house = Group(users: ['001']);
      expect(house.toString(), '001\n');
    });

    test('should have names and pics read in from json correctly', () {
      Map<String, dynamic> json = {
        "0": {"name": "name1", "picture": "pic1"},
        "1": {"name": "name2", "picture": "pic2"},
      };
      expect(Group.namePicfromJson(json), [
        {"name": "name1", "picture": "pic1"},
        {"name": "name2", "picture": "pic2"}
      ]);
    });

    test('should return correct names and pics', () async {
      var result = await Group.getNamesAndPics(1, mode: 'test');
      var expected = [
        {'name': '001', 'picture': '2019'}
      ];
      expect(result, expected);
    });

    test('should return empty list on fail to get names and pics', () async {
      var result = await Group.getNamesAndPics(1, mode: 'testfail');
      expect(result, []);
    });

    test('should return correct group', () async {
      var result = await Group.getGroup(mode: 'test');
      var expected = Group(users: ['001', '002']);
      expect(result, expected);
    });

    test('should return null on fail to get group', () async {
      var result = await Group.getGroup(mode: 'testfail');
      expect(result, null);
    });
  });

  group('House', () {
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

    test('should return correct current house', () async {
      var result = await House.getCurrentHouse(mode: 'test');
      var expected = House(groupId: 1, createdAt: 'now', houseName: 'nombre');
      expect(result, expected);
    });

    test('should return null on fail to get current house', () async {
      var result = await House.getCurrentHouse(mode: 'testfail');
      expect(result, null);
    });
  });
  group('BeerTally', () {
    test('should be constructed correctly', () {
      BeerTally tally = BeerTally(count: [1, 1], product: 'product');
      expect(tally.count, [1, 1]);
      expect(tally.product, 'product');
    });

    test('should read in from json correctly', () {
      Map<String, dynamic> json = {
        "product": "bier",
        '0': {'uid': '001', 'count': 1},
        '1': {'uid': '002', 'count': 1}
      };

      BeerTally tally = BeerTally.fromJson(json);
      expect(tally.count, [1, 1]);
      expect(tally.product, 'bier');
    });

    test('should get count correctly', () {
      BeerTally tally = BeerTally(count: [1, 1], product: 'product');
      expect(tally.getCount(), [1, 1]);
    });

    test('should have correct string representation', () {
      BeerTally tally = BeerTally(count: [1, 1], product: 'bier');
      expect(tally.toString(), 'TODO:REMAKE TOSTRING');
    });

    test('should return correct tally', () async {
      var result = await BeerTally.getData(1, 'bier', mode: 'test');
      var expected = BeerTally(count: [1, 1], product: 'bier');
      expect(result, expected);
    });

    test('should return null on fail to get tally', () async {
      var result = await BeerTally.getData(1, 'bier', mode: 'testfail');
      expect(result, null);
    });
  });

  group('BeerEvent', () {
    test('should be constructed correctly', () {
      BeerEvent event =
          BeerEvent(1, 'auth', 'authname', 't', 'tname', 'now', 1);
      expect(event.gid, 1);
      expect(event.authorid, 'auth');
      expect(event.authorname, 'authname');
      expect(event.targetid, 't');
      expect(event.targetname, 'tname');
      expect(event.date, 'now');
      expect(event.mutation, 1);
    });

    test('should read in from json correctly', () {
      List<dynamic> json = [
        {
          'gid': 1,
          'authorid': 'a',
          'authorname': 'aname',
          'targetid': 't',
          'targetname': 'tname',
          'date': 'now',
          'mutation': 1
        },
        {
          'gid': 1,
          'authorid': 'a',
          'authorname': 'aname',
          'targetid': 't',
          'targetname': 'tname',
          'date': 'now',
          'mutation': 2
        }
      ];

      List<BeerEvent> events = BeerEvent.fromJson(json);
      expect(events[0].gid, 1);
      expect(events[0].mutation, 1);
      expect(events[1].gid, 1);
      expect(events[1].mutation, 2);
    });

    test('should copy correctly', () {
      BeerEvent event =
          BeerEvent(1, 'auth', 'authname', 't', 'tname', 'now', 1);
      BeerEvent copy = event.copyByVal();
      expect(copy.gid, 1);
      expect(copy.authorid, 'auth');
      expect(copy.authorname, 'authname');
      expect(copy.targetid, 't');
      expect(copy.targetname, 'tname');
      expect(copy.date, 'now');
      expect(copy.mutation, 1);
    });

    test('should return correct events', () async {
      var result = await BeerEvent.getData(1, mode: 'test');
      var expected = [
        BeerEvent(1,'001','henk','002','karin','now',1)
      ];
      expect(result, expected);
    });

    test('should return null on fail to get events', () async {
      var result = await BeerEvent.getData(1, mode: 'testfail');
      expect(result, null);
    });
  });

  group('ConsumeData', () {
    test('should construct correctly', () {
      ConsumeData consume = ConsumeData('now', 1);
      expect(consume.date, 'now');
      expect(consume.amount, 1);
    });
  });
  group('Product', () {
    test('should construct correctly', () {
      Product product = Product(1.0, 'bier');
      expect(product.price, 1.0);
      expect(product.name, 'bier');
    });

    test('should read in from json correctly', () {
      Map<String, dynamic> json = {
        '0': {'id': '1', 'name': 'bier', 'price': 1.0},
        '1': {'id': '2', 'name': 'ei', 'price': 2.0}
      };

      List<Product> products = Product.fromJson(json);
      expect(products[0].price, 1.0);
      expect(products[0].name, 'bier');
      expect(products[1].price, 2.0);
      expect(products[1].name, 'ei');
    });

    test('should return correct products', () async {
      var result = await Product.getData(1, mode: 'test');
      var expected = [
        Product(0.0, 'nombre')
      ];
      expect(result, expected);
    });

    test('should return empty list on fail to get products', () async {
      var result = await Product.getData(1, mode: 'testfail');
      expect(result, []);
    });
  });

  group('Schedules', () {
    test('should construct correctly', () {
      Schedules schedules = Schedules([]);
      expect(schedules.usersid, []);
    });
  });

  group('ConsumeDataPerMonthUser', () {
    test('should construct correctly', () {
      ConsumeDataPerMonthPerUser consume = ConsumeDataPerMonthPerUser('n', 1);
      expect(consume.name, 'n');
      expect(consume.amount, 1);
    });
  });
}
