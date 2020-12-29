import 'package:flutter/material.dart';
import 'package:dringo/domain/beer.dart';

class Stats {
  Beer beer;
  String avg;

  Stats({this.beer, this.avg});


  factory Stats.fromJson(Map<String, dynamic> responseData) {
    return Stats(
      beer: Beer.fromRatingJson(responseData['beer']),
    avg: responseData['avg']
    );
  }
}
