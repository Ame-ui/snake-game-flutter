import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'm_bus_stop.dart';

class BusStopController extends GetxController {
  List<BusStop> busStops = [];
  List<BusStop> searchResult = [];
  bool xExpand = false;

  @override
  void onInit() {
    fetchBusStops();
    super.onInit();
  }

  void fetchBusStops() async {
    String str = await rootBundle.loadString('assets/bus_stop.json');
    var data = jsonDecode(str);
    Iterable iterable = data['elements'];
    for (var element in iterable) {
      busStops.add(BusStop.fromJson(element));
    }
  }
}
