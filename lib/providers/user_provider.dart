import 'package:flutter/material.dart';

import '../models/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User(
    id: null,
    roleId: null,
    username: "",
    phone: "",
    photo: "",
    role: "",
    slug: "",
    credentials: "",
  );

  User get getUser => _user;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }
}
