import 'package:dringo/domain/user.dart';
import 'package:flutter/material.dart';

class Category with ChangeNotifier {
  int id;
  String name;

  Category(
      {@required this.id,
        @required this.name
        });

  factory Category.fromJson(Map<String, dynamic> responseData) {
    return Category(
      id: responseData['id'],
      name: responseData['name'],
    );
  }
}
