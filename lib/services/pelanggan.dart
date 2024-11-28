import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../constant.dart';
import '../models/pelanggan.dart';
import '../utils/utils.dart';

class PelangganService {
  static const _apiPelanggan = "$serverUrl/pelanggan";

  static Future<List<Pelanggan>> getPelanggans({
    required int limit,
    required int offset,
    String? search,
  }) async {
    final token = await Utils.getUserToken();
    String url = "$_apiPelanggan?limit=$limit&offset=$offset";
    if (search != null && search.isNotEmpty) url += "&search=$search";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body)['data'];
    return List<Pelanggan>.from(data.map((e) => Pelanggan.fromJson(e)));
  }

  static Future<Pelanggan?> postPelanggan({
    required BuildContext context,
    required String name,
    required String address,
    required String phone,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();
    final uri = Uri.parse(_apiPelanggan);

    http.Response response = await http.post(
      uri,
      headers: {"Authorization": "Bearer $token"},
      body: {
        "name": name,
        "address": address,
        "phone": phone,
      },
    );

    if (context.mounted) {
      Navigator.of(context).pop();
    }

    if (response.statusCode == 201) {
      return Pelanggan.fromJson(jsonDecode(response.body)['data']);
    } else {
      if (context.mounted) {
        Utils.showTheDialog(
          context: context,
          title: "Error",
          content:
              jsonDecode(response.body)['message'].toString().toUpperCase(),
        );
      }
      return null;
    }
  }
}
