import 'dart:convert';

import 'package:dringo/domain/beer.dart';
import 'package:dringo/domain/secure_storage.dart';
import 'package:dringo/util/app_url.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class BeerProvider with ChangeNotifier, SecureStorageMixin {
  List<Beer> _beers = [];

  List<Beer> get beers {
    return [..._beers];
  }

  Future<void> addBeer(Beer beer) async {
    final token = await getSecureStorage("token");

    final Map<String, dynamic> beerData = {
      'name': beer.name,
      'abv': beer.abv,
      'roomId': beer.roomId
    };

    final response =
        await post(AppUrl.rooms + '/' + beer.roomId.toString() + '/beers',
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ' + token,
            },
            body: json.encode(beerData));

    if (response.statusCode == 201) {
      final responseData = json.decode(response.body);
      final List<Beer> beers = _beers;
      final beer = Beer.fromJson(responseData);
      beers.add(beer);
      _beers = beers;
      notifyListeners();
    }
  }

  Future<void> deleteBeer(Beer beer) async {
    final token = await getSecureStorage("token");

    final response = await delete(
        AppUrl.rooms +
            '/' +
            beer.room.id.toString() +
            '/beers/' +
            beer.id.toString(),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + token,
        });

    if (response.statusCode == 200) {
      var removedBeer =
          _beers.firstWhere((deletedBeer) => deletedBeer.id == beer.id);
      final List<Beer> beers = _beers;
      beers.remove(removedBeer);
      _beers = beers;
      notifyListeners();
    }
  }
}
