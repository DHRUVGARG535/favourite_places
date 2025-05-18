import 'package:favourite_places/models/place.dart';
import 'package:favourite_places/screens/place_detail.dart';
import 'package:flutter/material.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({super.key, required this.placesList});

  final List<Place> placesList;

  @override
  Widget build(BuildContext context) {
    if (placesList.isEmpty) {
      return Center(
        child: Text(
          'No Place Added',
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: placesList.length,
      itemBuilder:
          (ctx, index) => ListTile(
            leading: CircleAvatar(
              backgroundImage: FileImage(placesList[index].image),
            ),
            title: Text(
              placesList[index].title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: Text(
              placesList[index].location.address,
              style: Theme.of(context).textTheme.bodySmall!.copyWith(
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => PlaceDetailScreen(place: placesList[index]),
                ),
              );
            },
          ),
    );
  }
}
