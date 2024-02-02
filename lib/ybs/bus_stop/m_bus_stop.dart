import 'package:latlong2/latlong.dart';

class BusStop {
  String id;
  String name;
  String nameEn;
  LatLng position;

  BusStop(
      {required this.id,
      required this.name,
      required this.nameEn,
      required this.position});

  factory BusStop.fromJson(Map data) {
    return BusStop(
        id: data['id'].toString(),
        name: data['tags']['name'] ?? '',
        nameEn: data['tags']['name:en'] ?? '',
        position: LatLng(double.parse(data['lat'].toString()),
            double.parse(data['lon'].toString())));
  }
}
