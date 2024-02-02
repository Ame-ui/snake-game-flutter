import 'dart:convert';

import 'package:cube/ybs/bus_line/m_bus_line.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart'; // Import the latlng package

class RouteService {
  Future<List<LatLng>> getYBSBusRouteCoordinates(
      List<BusLineMember> memberlist) async {
    List<LatLng> latlngList = [];
    print(memberlist.length);
    int i = 1;
    for (var element in memberlist) {
      print('${i++} ${element.busLineMemberType.name}');
      // if (element.busLineMemberType == BusLineMemberType.node) {
      //   LatLng? node = await getLatlngWithNodeId(element.memberId);
      //   if (node != null) {
      //     latlngList.add(node);
      //   }
      // } else
      if (element.busLineMemberType == BusLineMemberType.way) {
        List<LatLng> way = await getLatlngListWithWayId(element.memberId);
        latlngList.addAll(way);
      }
    }
    return latlngList;
  }

  Future<LatLng?> getLatlngWithNodeId(String nodeId) async {
    String overpassEndpoint = 'https://overpass-api.de/api/interpreter';
    String query = '''
    [out:json];
    node($nodeId);
    out;
  ''';

    try {
      Uri uri = Uri.parse(overpassEndpoint);
      http.Response response = await http.post(uri, body: {'data': query});

      if (response.statusCode == 200) {
        // Parse the JSON response
        Map<String, dynamic> data = json.decode(response.body);

        // Extract coordinates from the response
        var node = data['elements'][0];
        if (node.containsKey('lat') && node.containsKey('lon')) {
          double lat = node['lat'];
          double lng = node['lon'];
          return LatLng(lat, lng);
        }
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return null;
  }

  Future<List<LatLng>> getLatlngListWithWayId(String wayId) async {
    String overpassEndpoint = 'https://overpass-api.de/api/interpreter';
    String query = '''
    [out:json];
    way($wayId);
    out geom;
  ''';

    // try {
    Uri uri = Uri.parse(overpassEndpoint);
    http.Response response = await http.post(uri, body: query);

    if (response.statusCode == 200) {
      // Parse the JSON response
      Map<String, dynamic> data = json.decode(response.body);
      // superPrint(data);

      List<LatLng> nodeArray = [];
      if ((data['elements'] as Iterable).isNotEmpty) {
        var way = data['elements'][0];

        if (way.containsKey('geometry')) {
          List<LatLng> coordinates = [];
          for (var node in way['geometry']) {
            double lat = node['lat'];
            double lng = node['lon'];
            coordinates.add(LatLng(lat, lng));
          }
          return coordinates;
        }
      }
    } else {
      print('Failed to fetch data. Status code: ${response.body}');
    }
    // } catch (error) {
    //   print('Error: $error');
    // }

    return [];
  }
}
