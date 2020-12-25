import 'package:dringo/domain/category.dart';
import 'package:dringo/domain/room.dart';
import 'package:flutter/material.dart';

class Pivot with ChangeNotifier {
  int id;
  int weight;
  Category category;
  Room room;

  Pivot({@required this.id, @required this.weight, this.category, this.room});

  factory Pivot.fromJson(Map<String, dynamic> responseData) {
    return Pivot(
        id: responseData['id'] as int,
        weight: responseData['weight'] as int,
        category: Category.fromJson(responseData['category']),
        room: Room.fromDegustationJson(responseData['room']));
  }

  factory Pivot.fromRatingJson(Map<String, dynamic> responseData) {
    return Pivot(
        id: responseData['id'] as int, weight: responseData['weight'] as int);
  }
}
