import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

enum BusLineMemberType { node, way, none }

class BusLine {
  String id;
  String name;
  String nameEn;
  LatLng center;
  String busNumber;
  String from;
  String to;
  List<BusLineMember> members;

  BusLine(
      {required this.id,
      required this.name,
      required this.nameEn,
      required this.busNumber,
      required this.center,
      required this.from,
      required this.members,
      required this.to});

  factory BusLine.fromJson(Map data) {
    return BusLine(
        id: data['id'].toString(),
        name: data['tags']['name'] ?? '',
        nameEn: data['tags']['name:en'] ?? '',
        busNumber: data['tags']['ref'].toString(),
        center: LatLng(data['center']['lat'], data['center']['lon']),
        from: data['tags']['from'] ?? '',
        members: (data['members'] as Iterable)
            .map((e) => BusLineMember.fromJson(e))
            .toList(),
        to: data['tags']['to'] ?? '');
  }
}

class BusLineMember {
  String memberId;
  String role;
  BusLineMemberType busLineMemberType;
  BusLineMember(
      {required this.memberId,
      required this.role,
      required this.busLineMemberType});

  factory BusLineMember.fromJson(Map data) {
    return BusLineMember(
        memberId: data['ref'].toString(),
        role: data['role'].toString(),
        busLineMemberType: BusLineMemberType.values.firstWhereOrNull(
                (element) =>
                    data['type'].toString().toLowerCase() ==
                    element.name.toLowerCase()) ??
            BusLineMemberType.none);
  }
}
