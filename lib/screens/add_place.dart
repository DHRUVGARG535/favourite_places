import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/provider/new_item_provider.dart';
import 'package:favourite_places/widgets/image_input.dart';
import 'package:favourite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AppPlaceScreenState();
}

class _AppPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  File? _selectedImage;
  PlaceLocation? _selectedLocation;
  final titleContoller = TextEditingController();

  void _savePlace() {
    final enteredText = titleContoller.text;

    if (enteredText.isEmpty ||
        _selectedImage == null ||
        _selectedLocation == null) {
      return;
    }

    ref
        .read(favouriteProvider.notifier)
        .addFavouritePalce(
          Place(
            title: titleContoller.text,
            image: _selectedImage!,
            location: _selectedLocation!,
          ),
        );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    super.dispose();
    titleContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add new Place')),

      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: titleContoller,
              decoration: InputDecoration(label: Text('Title')),
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            SizedBox(height: 10),
            ImageInput(
              onPickImage: (image) {
                _selectedImage = image;
              },
            ),
            SizedBox(height: 10),
            LocationInput(
              onSelectLocation: (location) {
                _selectedLocation = location;
              },
            ),
            SizedBox(height: 16),

            ElevatedButton.icon(
              onPressed: _savePlace,

              icon: Icon(Icons.add),
              label: Text('Add Place'),
            ),
          ],
        ),
      ),
    );
  }
}
