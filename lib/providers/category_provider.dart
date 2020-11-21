import 'dart:convert';

import 'package:dringo/domain/category.dart';
import 'package:dringo/util/app_url.dart';
import 'package:dringo/util/shared_preference.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  Future<void> getAll() async {
    final token = await UserPreferences().getToken();

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

      _categories =  categories;
      notifyListeners();
    }
  }


}
