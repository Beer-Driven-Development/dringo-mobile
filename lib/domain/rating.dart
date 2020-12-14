import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/user.dart';

import 'beer.dart';

class Rating {
  int id;
  Beer beer;
  Pivot pivot;
  User evaluator;
  double score;

  Rating({this.id, this.beer, this.pivot, this.evaluator, this.score});

  factory Rating.fromJson(Map<String, dynamic> responseData) {
    return Rating(
        id: responseData['id'],
        beer: Beer.fromRatingJson(responseData['beer']),
        evaluator: User.fromJson(responseData['evaluator']),
        pivot: Pivot.fromRatingJson(responseData['pivot']),
        score: responseData['score']);
  }
}
