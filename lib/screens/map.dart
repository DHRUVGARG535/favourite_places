import 'package:favourite_places/models/place.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({
    super.key,
    this.isSelecting = true,
    this.location = const PlaceLocation(
      address: '',
      lat: 37.422,
      lng: -122.084,
    ),
  });

  final bool isSelecting;
  final PlaceLocation location;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _pickedLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isSelecting ? 'Choose Your Location' : 'Your Loctation',
        ),
        actions: [
          if (widget.isSelecting)
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(_pickedLocation);
              },
              icon: Icon(Icons.save),
            ),
        ],
      ),
      body: GoogleMap(
        onTap:
            !widget.isSelecting
                ? null
                : (value) {
                  setState(() {
                    _pickedLocation = value;
                  });
                },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.location.lat, widget.location.lng),
          zoom: 16,
        ),
        markers:
            (_pickedLocation == null && widget.isSelecting)
                ? {}
                : {
                  Marker(
                    markerId: MarkerId('m1'),
                    position:
                        _pickedLocation ??
                        LatLng(widget.location.lat, widget.location.lng),
                  ),
                },
      ),
    );
  }
}
