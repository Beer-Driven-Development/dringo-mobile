import 'dart:convert';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/pivot.dart';
import 'package:dringo/domain/rating.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/domain/stats.dart';
import 'package:dringo/domain/user.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class DegustationProvider with ChangeNotifier, SecureStorageMixin {
  List<Beer> _beers = [];
  Beer _currentBeer;
  bool _isCompleted = false;
  List<Stats> _stats = [];


  Beer get currentBeer {
    return _currentBeer;
  }
  bool get isCompleted {
    return _isCompleted;
  }

  set isCompleted(bool status) {
    _isCompleted = status;
  }

  List<Pivot> _pivots = [];

  List<Beer> get beers {
    return [..._beers];
  }

  List<Pivot> get pivots {
    return [..._pivots];
  }

  List<Stats> get stats {
    return [... _stats];
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

  Future<void> first(int roomId) async {
    final token = await getSecureStorage("token");

    final response = await post(
      AppUrl.rooms + '/' + roomId.toString() + '/first',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final Beer loadedBeer = new Beer.fromJson(responseData['beer']);

      _currentBeer = loadedBeer;
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

  Future<void> next(int roomId, int beerId) async {
    final token = await getSecureStorage("token");
    final Map<String, dynamic> data = {'beerId': beerId};
    final response =
        await post(AppUrl.rooms + '/' + roomId.toString() + '/next',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
            body: json.encode(data));

    if (response.statusCode == 400) {
      isCompleted = true;
      notifyListeners();
    } else if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final Beer loadedBeer = new Beer.fromJson(responseData['beer']);

      _currentBeer = loadedBeer;
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

  Future<void> getStats(int roomId) async {
    final token = await this.getSecureStorage("token");
    if (token == null) {
      return;
    }

    final response = await get(
      AppUrl.rooms + '/' + roomId.toString() +'/stats',
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + token,
      },
    );

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body) as List;

      final List<Stats> stats = [];
      for (var stat in responseData) {
        var currentStat = new Stats.fromJson(stat);
        stats.add(currentStat);
      }
      _stats = stats;
      notifyListeners();
    }
  }


}
