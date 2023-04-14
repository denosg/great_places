import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    // returns a copy of the items
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: null,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    // inserts the data in the sqlite database
    DBHelper.insert('user_places', {
      'id': newPlace.id,
      'title': newPlace.title,
      'image': newPlace.image.path,
    });
  }

  Future<void> fetchAndSetPlaces() async {
    // fetches the data from the sqlite databas
    final dataList = await DBHelper.getData('user_places');
    // saves the data locally in the memory
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: null,
              image: File(item['image']),
            ))
        .toList();
    notifyListeners();
  }
}
