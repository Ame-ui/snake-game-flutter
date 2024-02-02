import 'package:cube/ybs/bus_line/v_bus_line.dart';
import 'package:cube/ybs/bus_stop/v_bus_stop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

class YbsHomePage extends StatelessWidget {
  const YbsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FlutterSuperScaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () {
              Get.to(() => const BusStopPage());
            },
            child: const Text(
              'Bus stop',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Get.to(() => const BusLinePage());
            },
            child: const Text(
              'Bus lines',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          )
        ],
      ),
    );
  }
}
