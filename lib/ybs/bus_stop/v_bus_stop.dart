import 'dart:async';

import 'package:cube/ybs/bus_stop/c_bus_stop.dart';
import 'package:cube/ybs/bus_stop/w_search_list_bottomsheet.dart';
import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

class BusStopPage extends StatefulWidget {
  const BusStopPage({super.key});

  @override
  State<BusStopPage> createState() => _BusStopPageState();
}

class _BusStopPageState extends State<BusStopPage>
    with TickerProviderStateMixin {
  Timer timer = Timer(Duration.zero, () {});
  MapController mapController = MapController();
  late AnimationController markarAnimationController;
  late AnimationController mapAnimationController;
  @override
  void initState() {
    mapAnimationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    markarAnimationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    super.initState();
  }

  @override
  void dispose() {
    markarAnimationController.dispose();
    mapAnimationController.dispose();

    mapController.dispose();
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
      body: Column(
        children: [
          Container(
            height: 60,
            width: Get.width,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(color: Colors.white, boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0,
                  blurRadius: 5,
                  offset: const Offset(0, 5))
            ]),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(Icons.keyboard_arrow_left_rounded),
                ),
                const SizedBox(
                  width: 20,
                ),
                const Text(
                  'Bus stops',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                          child: Text(
                        'Click marker to see the Bus Stop name',
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.7),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ))
                    ];
                  },
                  child: const Icon(Icons.help),
                )
              ],
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                FlutterMap(
                    mapController: mapController,
                    options: const MapOptions(
                        maxZoom: 18,
                        minZoom: 1,
                        initialCenter: LatLng(16.8508661, 96.1489691)),
                    children: [
                      TileLayer(
                          urlTemplate:
                              'https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png'
                          // 'https://s.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
                          ),
                      GetBuilder<BusStopController>(
                        builder: (controller) {
                          return MarkerLayer(markers: [
                            ...controller.searchResult
                                .map(
                                  (e) => Marker(
                                    rotate: true,
                                    point: e.position,
                                    alignment: Alignment.topCenter,
                                    child: PopupMenuButton(
                                      position: PopupMenuPosition.over,
                                      offset: const Offset(0, -55),
                                      splashRadius: 100,
                                      padding: const EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      shadowColor:
                                          Colors.deepOrange.withOpacity(0.2),
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                          enabled: false,
                                          onTap: null,
                                          height: 30,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 0),
                                          child: Text(
                                            e.nameEn,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          ),
                                        )
                                      ],
                                      child: AnimatedBuilder(
                                          animation: markarAnimationController,
                                          builder: (context, child) {
                                            return Transform.scale(
                                              scale: markarAnimationController
                                                  .value,
                                              child: Icon(
                                                TablerIcons.map_pin_filled,
                                                color: Colors.deepOrange,
                                                size: 30,
                                                shadows: [
                                                  Shadow(
                                                      color: Colors.black
                                                          .withOpacity(0.2),
                                                      blurRadius: 7)
                                                ],
                                              ),
                                            );
                                          }),
                                    ),
                                  ),
                                )
                                .toList()
                          ]);
                        },
                      ),
                    ]),
                Container(
                  width: Get.width,
                  height: 10,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                    Colors.deepOrange.withOpacity(0.1),
                    Colors.deepOrange.withOpacity(0)
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
                )
              ],
            ),
          ),
          GetBuilder<BusStopController>(
            builder: (controller) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, -5))
                ]),
                child: TextField(
                  decoration: InputDecoration(
                      suffixIcon: InkWell(
                        onTap: () async {
                          Get.bottomSheet(
                              SearchListBottomsheet(
                                  mapAnimationController:
                                      mapAnimationController,
                                  searchList: controller.searchResult,
                                  mapController: mapController),
                              isScrollControlled: true,
                              enterBottomSheetDuration:
                                  const Duration(milliseconds: 300));
                          FocusScope.of(context).unfocus();
                        },
                        child: Container(
                            width: 30,
                            height: 30,
                            color: Colors.transparent,
                            child: Stack(
                              alignment: const Alignment(0.8, -0.8),
                              children: [
                                const Center(child: Icon(Icons.list)),
                                Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                      color: Colors.deepOrange,
                                      borderRadius: BorderRadius.circular(100)),
                                  child: Text(
                                    controller.searchResult.length.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ),
                      border: InputBorder.none,
                      prefixIcon: const Icon(Icons.search),
                      hintText: 'Search'),
                  onTapOutside: (event) => FocusScope.of(context).unfocus(),
                  onChanged: (value) {
                    timer.cancel();
                    markarAnimationController.value = 1;
                    markarAnimationController.reverse();
                    controller.searchResult.clear();
                    timer = Timer(const Duration(milliseconds: 500), () {
                      if (value.isNotEmpty) {
                        for (var element in controller.busStops) {
                          if (element.name
                                  .toLowerCase()
                                  .contains(value.toLowerCase()) ||
                              element.nameEn
                                  .toLowerCase()
                                  .contains(value.toLowerCase())) {
                            controller.searchResult.add(element);
                          }
                        }
                      }
                      controller.searchResult.sort(
                        (a, b) => a.nameEn.compareTo(b.nameEn),
                      );
                      controller.update();
                      markarAnimationController.reset();
                      markarAnimationController.forward();
                    });
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
