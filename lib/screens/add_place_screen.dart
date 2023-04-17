import 'dart:io';

import 'package:flutter/material.dart';
import 'package:great_places/models/place.dart';
import 'package:great_places/providers/great_places.dart';
import 'package:provider/provider.dart';

import '../widgets/image_input.dart';
import '../widgets/location_input.dart';

class AddPlaceScreen extends StatefulWidget {
  static const routeName = '/add-place';

  @override
  State<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends State<AddPlaceScreen> {
  final _titleController = TextEditingController();

  File _pickedImage = File('');

  PlaceLocation? _pickedLocation;

  void _selectPlace(double lat, double lng) {
    _pickedLocation = PlaceLocation(latitude: lat, longitude: lng);
  }

  void _selectImage(File myPickedImage) {
    _pickedImage = myPickedImage;
  }

  void _savePlace() {
    if (_titleController.text.isEmpty ||
        _pickedImage.path == '' ||
        _pickedLocation == null) {
      return;
    }
    Provider.of<GreatPlaces>(context, listen: false)
        .addPlace(_titleController.text, _pickedImage, _pickedLocation);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new place'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // User Inputs
          // Expanded gets all the height it can get, and leaves the rest for the button, since it is at the end of the screen
          Expanded(
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(label: Text('Titlte')),
                  ),
                  const SizedBox(height: 10),
                  ImageInput(_selectImage),
                  const SizedBox(height: 10),
                  LocationInput(_selectPlace),
                ],
              ),
            )),
          ),
          ElevatedButton.icon(
            onPressed: _savePlace,
            style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).accentColor),
            icon: const Icon(Icons.add),
            label: const Text('Add place'),
          ),
        ],
      ),
    );
  }
}
