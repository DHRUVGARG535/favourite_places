import 'dart:convert';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/map.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class LocationInput extends StatefulWidget {
  const LocationInput({super.key, required this.onSelectLocation});

  final void Function(PlaceLocation location) onSelectLocation;

  @override
  State<LocationInput> createState() {
    return _LocationInputState();
  }
}

class _LocationInputState extends State<LocationInput> {
  
  _saveLocation(double lat, double lng) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=AIzaSyA6YeZ0Br3kX7L3ZgZM4QRjGFmtSamV77w',
    );
    final respose = await http.get(url);
    final resData = json.decode(respose.body);

    final address = resData['results'][0]['formatted_address'];

    setState(() {
      _pickedLocation = PlaceLocation(address: address, lat: lat, lng: lng);
      _isGettingLocation = false;
    });

    widget.onSelectLocation(_pickedLocation!);
  }

  PlaceLocation? _pickedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_pickedLocation == null) {
      return '';
    }

    final lat = _pickedLocation!.lat;
    final lng = _pickedLocation!.lng;
    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng=&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=AIzaSyA6YeZ0Br3kX7L3ZgZM4QRjGFmtSamV77w';
  }

  void _getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();

    final lat = locationData.latitude;
    final lng = locationData.longitude;

    if (lat == null || lng == null) {
      return;
    }

    _saveLocation(lat, lng);
  }

  void _selectOnMap() async {
    final location = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(builder: (ctx) => MapScreen()),
    );

    if(location == null){
      return;

    }

    _saveLocation(location.latitude, location.longitude);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No location chosen!',
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
        color: Theme.of(context).colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );

    if (_isGettingLocation) {
      previewContent = CircularProgressIndicator();
    }

    if (_pickedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    }

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(width: 1),
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
          ),

          height: 170,
          width: double.infinity,
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              label: Text('Get Current Location'),
              icon: Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed:_selectOnMap,
              label: Text('Select On Map'),
              icon: Icon(Icons.map),
            ),
          ],
        ),
      ],
    );
  }
}
