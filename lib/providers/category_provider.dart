import 'dart:convert';

import 'package:dringo/domain/category.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CategoryProvider with ChangeNotifier, SecureStorageMixin {
  List<Category> _categories = [];
  List<Pivot> _pivots = [];

  List<Category> get categories {
    return [..._categories];
  }

  List<Pivot> get pivots {
    return [..._pivots];
  }

  deletePivots() {
    _pivots = [];
  }

  Future<void> getAll() async {
    final token = await getSecureStorage("token");

    final response = await get(
      AppUrl.categories,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      final List<Category> categories = [];
      for (var category in responseData) {
        categories.add(Category.fromJson(category));
      }

      _categories = categories;
      notifyListeners();
    }
  }

  Future<void> addCategory(int roomId, int id, int weight) async {
    final token = await getSecureStorage("token");

    final Map<String, dynamic> categoryData = {'id': id, 'weight': weight};

    final response =
        await post(AppUrl.rooms + '/' + roomId.toString() + '/categories',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
            body: json.encode(categoryData));

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);

      final pivot = Pivot.fromJson(responseData);
      final List<Pivot> pivots = _pivots;
      pivots.add(pivot);
      _pivots = pivots;
      notifyListeners();
    }
  }

  Future<void> deletePivot(int roomId, int pivotId) async {
    final token = await getSecureStorage("token");

    final response = await delete(
        AppUrl.rooms +
            '/' +
            roomId.toString() +
            '/categories/' +
            pivotId.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token,
        });

    if (response.statusCode == 200) {
      var pivot = _pivots.firstWhere((pivot) => pivot.id == pivotId);
      final List<Pivot> pivots = _pivots;
      pivots.remove(pivot);
      _pivots = pivots;
      notifyListeners();
    }
  }
}
