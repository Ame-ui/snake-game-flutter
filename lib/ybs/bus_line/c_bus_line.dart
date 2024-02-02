import 'dart:convert';

import 'package:cube/ybs/bus_line/m_bus_line.dart';
import 'package:cube/ybs/bus_stop/c_bus_stop.dart';
import 'package:cube/ybs/bus_stop/m_bus_stop.dart';
import 'package:cube/ybs/util/route_service.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class BusLineController extends GetxController {
  bool xLoading = true;
  List<BusLine> busLines = [];
  List<LatLng> polyLine = [];
  List<BusStop> busStops = [];
  @override
  void onInit() {
    fetchBusStops();
    super.onInit();
  }

  Future<void> getBuslineRoute(BusLine busLine) async {
    xLoading = true;
    // update();
    busStops.clear();
    for (var element in busLine.members) {
      if (element.busLineMemberType == BusLineMemberType.node) {
        var result = isContain(element.memberId);
        if (result != null) {
          busStops.add(result);
        }
      }
    }

    polyLine = await RouteService().getYBSBusRouteCoordinates(busLine.members);
    xLoading = false;
    update();
  }

  BusStop? isContain(String id) {
    BusStopController busStopController = Get.find();
    for (var element in busStopController.busStops) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }

  void fetchBusStops() async {
    String str = await rootBundle.loadString('assets/bus_line.json');
    var data = jsonDecode(str);
    Iterable iterable = data['elements'];
    for (var element in iterable) {
      busLines.add(BusLine.fromJson(element));
    }

    busLines.sort((a, b) {
      int int1 = extractNumber(a.busNumber);
      int int2 = extractNumber(b.busNumber);

      return (int1.compareTo(int2));
    });
  }

  int extractNumber(String str) {
    RegExp regExp = RegExp(r'\d+');
    var match = regExp.firstMatch(str);
    if (match != null) {
      return int.tryParse(match.group(0).toString()) ?? 0;
    } else {
      return 0;
    }
  }
}
