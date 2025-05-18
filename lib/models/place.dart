import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = Uuid();

class PlaceLocation {
  const PlaceLocation({
    required this.address,
    required this.lat,
    required this.lng,
  });
  final String address;
  final double lat;
  final double lng;
}

class Place {
  final String title;
  final String id;
  final File image;
  final PlaceLocation location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}
