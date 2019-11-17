import 'package:flutter/material.dart';
import 'package:huishoudappfrontend/services/permission_serivce.dart';
import 'package:huishoudappfrontend/setup/auth.dart';




class Provider extends InheritedWidget {
  final BaseAuth auth;
  final PermissionsService perm;

  Provider({
    Key key,
    Widget child,
    this.auth,
    this.perm,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }

  static Provider of(BuildContext context) =>
      (context.inheritFromWidgetOfExactType(Provider) as Provider);
}