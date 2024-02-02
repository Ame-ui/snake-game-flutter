import 'package:cube/ybs/bus_line/c_bus_line.dart';
import 'package:cube/ybs/bus_line/v_bus_line_detail.dart';
import 'package:cube/ybs/util/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_super_scaffold/flutter_super_scaffold.dart';
import 'package:get/get.dart';

class BusLinePage extends StatelessWidget {
  const BusLinePage({super.key});

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
                const Text(
                  'Bus lines',
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
            child: GetBuilder<BusLineController>(
              builder: (controller) {
                return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    itemCount: controller.busLines.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Get.to(() => BuslineDetailPage(
                                busLine: controller.busLines[index],
                              ));
                        },
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Text(
                                  controller
                                      .extractNumber(
                                          controller.busLines[index].busNumber)
                                      .toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              20.widthBox(),
                              Expanded(
                                child: Text(
                                  '${controller.busLines[index].from} -> ${controller.busLines[index].to}',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(
                          thickness: 2,
                          height: 20,
                        ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
