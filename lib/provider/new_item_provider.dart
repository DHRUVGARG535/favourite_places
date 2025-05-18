import 'dart:io';

import 'package:favourite_places/models/place.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart' as syspaths;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

class NewItemNotifier extends StateNotifier<List<Place>> {
  NewItemNotifier() : super([]);

  Future<Database> getDatabse() async {
    final dbPath = await sql.getDatabasesPath();
    final db = await sql.openDatabase(
      path.join(dbPath, 'places.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE user_places(id TEXT PRIMARY KEY,title TEXT,image TEXT,lat REAL,lng REAL,address TEXT)',
        );
      },
      version: 1,
    );

    return db;
  }

  Future<void> loadPlaces() async {
    final db = await getDatabse();
    final data = await db.query('user_places');
    final places =
        data
            .map(
              (row) => Place(
                id: row['id'] as String,
                title: row['title'] as String,
                image: File(row['image'] as String),
                location: PlaceLocation(
                  address: row['address'] as String,
                  lat: row['lat'] as double,
                  lng: row['lng'] as double,
                ),
              ),
            )
            .toList();

    state = places;
  }

  void addFavouritePalce(Place place) async {
    final appDir = await syspaths.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedImage = await place.image.copy('${appDir.path}/$filename');
    print(appDir.path);

    final db = await getDatabse();

    db.insert('user_places', {
      'id': place.id,
      'title': place.title,
      'image': copiedImage.path,
      'lat': place.location.lat,
      'lng': place.location.lng,
      'address': place.location.address,
    });

    state = [
      ...state,
      Place(title: place.title, image: copiedImage, location: place.location),
    ];
  }
}

final favouriteProvider = StateNotifierProvider<NewItemNotifier, List<Place>>(
  (ref) => NewItemNotifier(),
);
