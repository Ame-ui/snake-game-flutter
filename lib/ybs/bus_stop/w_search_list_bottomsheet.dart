import 'package:cube/ybs/bus_stop/m_bus_stop.dart';
import 'package:cube/ybs/util/extensions.dart';
import 'package:cube/ybs/util/map_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:get/get.dart';

class SearchListBottomsheet extends StatefulWidget {
  const SearchListBottomsheet(
      {super.key,
      required this.searchList,
      required this.mapController,
      required this.mapAnimationController});
  final List<BusStop> searchList;
  final MapController mapController;
  final AnimationController mapAnimationController;

  @override
  State<SearchListBottomsheet> createState() => _SearchListBottomsheetState();
}

class _SearchListBottomsheetState extends State<SearchListBottomsheet>
    with TickerProviderStateMixin {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.height * 0.6,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Center(
            child: Container(
              width: 60,
              height: 5,
              decoration: BoxDecoration(
                  color: Colors.grey, borderRadius: BorderRadius.circular(100)),
            ),
          ),
          20.heightBox(),
          Expanded(
            child: widget.searchList.isEmpty
                ? const Center(
                    child: Text(
                      'No search result',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                : Scrollbar(
                    controller: scrollController,
                    interactive: true,
                    thickness: 4,
                    radius: const Radius.circular(10),
                    child: ListView.separated(
                      controller: scrollController,
                      padding: EdgeInsets.zero,
                      itemCount: widget.searchList.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.withOpacity(0.2),
                        thickness: 1,
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        return Material(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () async {
                              Get.back();

                              // await Future.delayed(
                              //     const Duration(milliseconds: 100));
                              MapServie().animateLatlng(
                                  animationController:
                                      widget.mapAnimationController,
                                  fromLatlng:
                                      widget.mapController.camera.center,
                                  toLatlng: widget.searchList[index].position,
                                  mapController: widget.mapController,
                                  zoom: 16);
                            },
                            overlayColor: MaterialStatePropertyAll(
                                Colors.deepOrange.withOpacity(0.1)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 15),
                              color: Colors.transparent,
                              child: Row(
                                children: [
                                  const Icon(
                                    TablerIcons.map_pin_filled,
                                    color: Colors.deepOrange,
                                  ),
                                  10.widthBox(),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.searchList[index].name,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          widget.searchList[index].nameEn,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
