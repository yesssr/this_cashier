import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

import '../constant.dart';
import '../models/product.dart';
import '../utils/utils.dart';

class ProductService {
  static const String _apiProduct = "$serverUrl/products";

  static Future<List<Product>> getProducts({
    required int limit,
    required int offset,
    String? search,
    String? category,
  }) async {
    final token = await Utils.getUserToken();
    String url = "$_apiProduct?limit=$limit&offset=$offset";
    if (category != null) url += "&category=$category";
    if (search != null && search.isNotEmpty) url += "&search=$search";

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
      },
    );
    final data = jsonDecode(response.body)['data'];
    return List<Product>.from(data.map((e) => Product.fromJson(e)));
  }

  static postProduct({
    required BuildContext context,
    required String name,
    required dynamic photo,
    required int stok,
    required String price,
    required String category,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    final uri = Uri.parse(_apiProduct);
    var request = http.MultipartRequest("POST", uri)
      ..fields['name'] = name
      ..fields['price'] = price
      ..fields['category'] = category
      ..fields['stok'] = "$stok"
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
        filename: "upload-$name.jpg",
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
        onSuccess: () async {
          Navigator.of(context).pop(true);
          Utils.showTheDialog(
            title: "Success",
            context: context,
            content: "PRODUK BERHASIL DIBUAT!.",
          );
        },
      );
    }
  }

  static editProduct({
    required BuildContext context,
    required int id,
    required String name,
    required dynamic photo,
    required int stok,
    required String price,
    required String category,
    required String photoName,
  }) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    final uri = Uri.parse("$_apiProduct/$id");
    var request = http.MultipartRequest("PUT", uri)
      ..fields['name'] = name
      ..fields['price'] = price
      ..fields['category'] = category
      ..fields['stok'] = "$stok"
      ..fields['photo'] = photoName
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
        filename: "upload-$name.jpg",
        contentType: MediaType('image', 'jpg'),
      );
      request.files.add(file);
    }

    final response = await request.send();
    if (context.mounted) {
      Navigator.of(context, rootNavigator: true).pop();
      Utils.responseHandle(
        context: context,
        response: await http.Response.fromStream(response),
        onSuccess: () async {
          Navigator.of(context).pop(true);
          Utils.showTheDialog(
            title: "Success",
            context: context,
            content: "DATA PRODUK BERHASIL DIPERBARUI!.",
          );
        },
      );
    }
  }

  static Future<void> deleteProduk(
    BuildContext context,
    int productId,
  ) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    http.Response response = await http.delete(
      Uri.parse("$_apiProduct/$productId"),
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
            content: "PRODUK BERHASIL DIHAPUS!.",
          );
        },
      );
    }
  }

  static Future<void> updateStok(
    BuildContext context,
    int productId,
    int stok,
  ) async {
    Utils.showLoadingIndicator(context);
    final token = await Utils.getUserToken();

    http.Response response = await http.put(
        Uri.parse("$_apiProduct/update-stock/$productId"),
        headers: {"Authorization": "Bearer $token"},
        body: {"stok": "$stok"});

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
            content: "STOK PRODUK BERHASIL DIPERBARUI!.",
          );
        },
      );
    }
  }
}
