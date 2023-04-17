import 'dart:io';

import 'package:flutter/material.dart';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    // returns a copy of the items
    return [..._items];
  }

  Place findById(String id) {
    return _items.firstWhere((place) => place.id == id);
  }

  Future<void> addPlace(
    String pickedTitle,
    File pickedImage,
    PlaceLocation? pickedLocation,
  ) async {
    final double? pickedLat = pickedLocation?.latitude;
    final double? pickedLng = pickedLocation?.longitude;
    if (pickedLat != null && pickedLng != null) {
      final address =
          await LocationHelper.getPlaceAddress(pickedLat, pickedLng);
      final updatedLocation = PlaceLocation(
          latitude: pickedLat, longitude: pickedLng, address: address);
      final newPlace = Place(
        id: DateTime.now().toString(),
        title: pickedTitle,
        location: updatedLocation,
        image: pickedImage,
      );
      _items.add(newPlace);
      notifyListeners();
      // inserts the data in the sqlite database
      DBHelper.insert('user_places', {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address,
      });
    }
  }

  Future<void> fetchAndSetPlaces() async {
    // fetches the data from the sqlite databas
    final dataList = await DBHelper.getData('user_places');
    // saves the data locally in the memory
    _items = dataList
        .map((item) => Place(
              id: item['id'],
              title: item['title'],
              location: PlaceLocation(
                latitude: item['loc_lat'],
                longitude: item['loc_lng'],
                address: item['address'],
              ),
              image: File(item['image']),
            ))
        .toList();
    notifyListeners();
  }
}
