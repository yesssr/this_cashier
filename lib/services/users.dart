import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../constant.dart';
import '../models/user.dart';
import '../utils/utils.dart';

class UserService {
  static const String _apiUsers = "$serverUrl/users";

  static Future<List<User>> getUsers({
    required int limit,
    required int offset,
    String? search,
    String? filter,
  }) async {
    final token = await Utils.getUserToken();
    String url = "$_apiUsers?limit=$limit&offset=$offset";
    if (filter != null) url += "&filter=$filter";
    if (search != null && search.isNotEmpty) url += "&search=$search";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body)['data'];
    return List<User>.from(data.map((e) => User.fromJson(e)));
  }

  static postUser({
    required BuildContext context,
    required String username,
    required dynamic photo,
    required int roleId,
    required String phone,
    required String password,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    final uri = Uri.parse(_apiUsers);
    var request = http.MultipartRequest("POST", uri)
      ..fields['username'] = username
      ..fields['phone'] = phone
      ..fields['password'] = password
      ..fields['role_id'] = "$roleId"
      ..headers.addAll({
        "Authorization": "Bearer $token",
      });

    if (photo != null && photo is File) {
      var file = await http.MultipartFile.fromPath("file", photo.path);
      request.files.add(file);
    }
    if (photo != null && photo is Uint8List) {
      var file = http.MultipartFile.fromBytes(
        "file",
        photo,
        filename: "upload-$username.jpg",
        contentType: MediaType('image', 'jpg'),
      );
      request.files.add(file);
    }

    final response = await request.send();
    if (context.mounted) {
      Navigator.of(context).pop();
      Utils.responseHandle(
        context: context,
        response: await http.Response.fromStream(response),
        onSuccess: () {
          Navigator.of(context).pop(true);
          Utils.showTheDialog(
            title: "Success",
            context: context,
            content: "USER BERHASIL DIBUAT!.",
          );
        },
      );
    }
  }

  static editUser({
    required BuildContext context,
    required int id,
    required String username,
    required String? photoName,
    required dynamic photo,
    required int roleId,
    required String phone,
    required String password,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    final uri = Uri.parse("$_apiUsers/$id");
    var request = http.MultipartRequest("PUT", uri)
      ..fields['username'] = username
      ..fields['phone'] = phone
      ..fields['photo'] = photoName!
      ..fields['password'] = password
      ..fields['role_id'] = "$roleId"
      ..headers.addAll({
        "Authorization": "Bearer $token",
      });

    if (photo != null && photo is File) {
      var file = await http.MultipartFile.fromPath("file", photo.path);
      request.files.add(file);
    }
    if (photo != null && photo is Uint8List) {
      var file = http.MultipartFile.fromBytes(
        "file",
        photo,
        filename: "upload-$username.jpg",
        contentType: MediaType('image', 'jpg'),
      );
      request.files.add(file);
    }

    final response = await request.send();
    if (context.mounted) {
      Navigator.of(context).pop();
      Utils.responseHandle(
        context: context,
        response: await http.Response.fromStream(response),
        onSuccess: () {
          Navigator.of(context).pop(true);
          Utils.showTheDialog(
            title: "Success",
            context: context,
            content: "DATA USER BERHASIL DIPERBARUI!.",
          );
        },
      );
    }
  }

  static Future<void> deleteUser(
    BuildContext context,
    int userId,
  ) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    http.Response response = await http.delete(
      Uri.parse("$_apiUsers/$userId"),
      headers: {
        "Authorization": "Bearer $token",
      },
    );

    if (context.mounted) {
      Navigator.of(context).pop();
      Utils.responseHandle(
        context: context,
        response: response,
        onSuccess: () {
          Navigator.of(context).pop(true);
          Utils.showTheDialog(
            title: "Success",
            context: context,
            content: "USER BERHASIL DIHAPUS!.",
          );
        },
      );
    }
  }
}
