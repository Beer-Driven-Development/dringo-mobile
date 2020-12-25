import 'dart:convert';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DegustationProvider with ChangeNotifier, SecureStorageMixin {
  List<Beer> _beers = [];
  List<Pivot> _pivots = [];

  List<Beer> get beers {
    return [..._beers];
  }

  List<Pivot> get pivots {
    return [..._pivots];
  }

  Future<void> start(int roomId, List<User> participants) async {
    final token = await getSecureStorage("token");
    var encodedParticipants = new List<Map<String, dynamic>>();
    for (User participant in participants) {
      encodedParticipants.add(participant.toJson());
    }

    final Map<String, List<Map<String, dynamic>>> participantsData = {
      'participants': encodedParticipants
    };

    final response = await post(
      AppUrl.rooms + '/' + roomId.toString() + '/start',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
      body: json.encode(participantsData),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final beersData = responseData['beers'];
      final List<Beer> loadedBeers = [];
      beersData.forEach((beerData) {
        loadedBeers.add(Beer.fromJson(beerData));
      });
      _beers = loadedBeers;
      notifyListeners();
      final pivotsData = responseData['pivots'];
      final List<Pivot> loadedPivots = [];
      pivotsData.forEach((pivotData) {
        loadedPivots.add(Pivot.fromJson(pivotData));
      });
      _pivots = loadedPivots;
      notifyListeners();
    }
  }

  Future<void> degustation(int roomId) async {
    final token = await getSecureStorage("token");

    final response = await post(
      AppUrl.rooms + '/' + roomId.toString() + '/degustation',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final beersData = responseData['beers'];
      final List<Beer> loadedBeers = [];
      beersData.forEach((beerData) {
        loadedBeers.add(Beer.fromJson(beerData));
      });
      _beers = loadedBeers;
      notifyListeners();
      final pivotsData = responseData['pivots'];
      final List<Pivot> loadedPivots = [];
      pivotsData.forEach((pivotData) {
        loadedPivots.add(Pivot.fromJson(pivotData));
      });
      _pivots = loadedPivots;
      notifyListeners();
    }
  }

  Future<Rating> vote(int roomId, int beerId, int pivotId, double score) async {
    final token = await getSecureStorage("token");

    final Map<String, dynamic> ratingData = {
      'beerId': beerId,
      'pivotId': pivotId,
      'score': score
    };

    final response = await post(
      AppUrl.rooms + '/' + roomId.toString() + '/vote',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
      body: json.encode(ratingData),
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final rating = Rating.fromJson(responseData);
      notifyListeners();
      return rating;
    }
  }
}
