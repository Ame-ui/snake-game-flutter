import 'package:cube/ybs/bus_line/c_bus_line.dart';
import 'package:cube/ybs/bus_line/m_bus_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

import 'package:latlong2/latlong.dart';

class BuslineDetailPage extends StatefulWidget {
  const BuslineDetailPage({super.key, required this.busLine});
  final BusLine busLine;

  @override
  State<BuslineDetailPage> createState() => _BuslineDetailPageState();
}

class _BuslineDetailPageState extends State<BuslineDetailPage> {
  @override
  void initState() {
    BusLineController busLineController = Get.find();
    busLineController.getBuslineRoute(widget.busLine);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
      body: GetBuilder<BusLineController>(
        builder: (controller) {
          return Column(
            children: [
              Container(
                height: 60,
                width: Get.width,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                      color: Colors.deepOrange.withOpacity(0.1),
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
                    Text(
                      'YBS ${widget.busLine.name.split('-').first}',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Stack(
                  children: [
                    FlutterMap(
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
                          controller.xLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.deepOrange,
                                  ),
                                )
                              : PolylineLayer(polylines: [
                                  Polyline(
                                      points: controller.polyLine,
                                      color: Colors.deepOrange.shade300,
                                      borderColor: Colors.deepOrange.shade900,
                                      borderStrokeWidth: 1,
                                      strokeWidth: 5)
                                ]),
                          MarkerLayer(
                              markers: controller.busStops
                                  .map((e) => Marker(
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
                                          shadowColor: Colors.deepOrange
                                              .withOpacity(0.2),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              enabled: false,
                                              onTap: null,
                                              height: 30,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20,
                                                      vertical: 0),
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
                                        ),
                                      ))
                                  .toList())
                        ]),
                    Container(
                      width: Get.width,
                      height: 10,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                            Colors.deepOrange.withOpacity(0.1),
                            Colors.deepOrange.withOpacity(0)
                          ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter)),
                    )
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
