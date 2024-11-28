// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:this_cashier/main.dart';
import 'package:this_cashier/providers/cart.dart';

import '../constant.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../screens/login.dart';
import '../utils/utils.dart';

class AuthService {
  static void loginUser({
    required BuildContext context,
    required String username,
    required String password,
  }) async {
    Utils.showLoadingIndicator(context);
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final navigator = Navigator.of(context);
    http.Response login = await http.post(
      Uri.parse("$serverUrl/login"),
      body: {
        "username": username,
        "password": password,
      },
    );

    navigator.pop();

    Utils.responseHandle(
      context: context,
      response: login,
      onSuccess: () async {
        final response = jsonDecode(login.body);
        final prefs = await Utils.getPreferences();
        await prefs.setString(
          "credentials",
          response["credentials"],
        );

        Map<String, dynamic> data = response["data"];
        data['credentials'] = prefs.getString("credentials");

        userProv.setUser(User.fromJson(data));
        navigator.pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ),
          (route) => false,
        );
      },
    );
  }

  static Future<void> getProfile(BuildContext context) async {
    final userProv = Provider.of<UserProvider>(context, listen: false);
    final prefs = await Utils.getPreferences();
    final credentials = prefs.getString("credentials");
    if (credentials != null) {
      http.Response checkCredentials = await http.get(
        Uri.parse("$serverUrl/users/profile"),
        headers: {"Authorization": "Bearer $credentials"},
      );

      if (checkCredentials.statusCode == 200) {
        final response = jsonDecode(checkCredentials.body);
        final prefs = await Utils.getPreferences();
        await prefs.setString(
          "credentials",
          response["credentials"],
        );
        Map<String, dynamic> data = response["data"];
        data['credentials'] = prefs.getString("credentials");
        userProv.setUser(User.fromJson(data));
        return;
      }
    }
  }

  static void logOut(BuildContext context) async {
    final navigator = Navigator.of(context);
    final prefs = await Utils.getPreferences();
    prefs.remove("credentials");
    Provider.of<Cart>(context, listen: false).emptyCart();
    navigator.pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
      (route) => false,
    );
  }
}
