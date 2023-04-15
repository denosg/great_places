import 'package:flutter/material.dart';
import 'package:location/location.dart';

import '../helpers/location_helper.dart';
import '../screens/maps_screen.dart';

class LocationInput extends StatefulWidget {
  const LocationInput({super.key});

  @override
  State<LocationInput> createState() => _LocationInputState();
}

class _LocationInputState extends State<LocationInput> {
  String _previewImageUrl = '';

  Future<void> _getCurrentUserLocation() async {
    final locData = await Location().getLocation();
    final latitude = locData.latitude;
    final longitude = locData.longitude;
    if (latitude != null && longitude != null) {
      final staticMapImageUrl = LocationHelper.generateLocationPreviewImage(
          latitude: latitude, longitude: longitude);
      setState(() {
        _previewImageUrl = staticMapImageUrl;
      });
    }
  }

  Future<void> _selectOnMap() async {
    final selectedLocation = await Navigator.of(context).push(MaterialPageRoute(
      fullscreenDialog: true,
      builder: (context) => const MapScreen(
        isSelecting: true,
      ),
    ));
    if (selectedLocation == null) {
      return;
    }
    // ...
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          child: _previewImageUrl == ''
              ? const Text(
                  'No location chosen',
                  textAlign: TextAlign.center,
                )
              : Image.network(
                  _previewImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton.icon(
              onPressed: _getCurrentUserLocation,
              icon: const Icon(Icons.location_on),
              label: Text(
                'Current Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
            TextButton.icon(
              onPressed: _selectOnMap,
              icon: const Icon(Icons.map),
              label: Text(
                'Select Location',
                style: TextStyle(color: Theme.of(context).primaryColor),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
