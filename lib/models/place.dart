import 'package:uuid/uuid.dart';

var uuid = Uuid();

class Place {
  final String title;
  final String id;

  Place({required this.title}) : id = uuid.v4();
}
