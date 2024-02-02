import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwipeButton extends StatefulWidget {
  const SwipeButton(
      {super.key,
      required this.bgColor,
      required this.thumbColor,
      required this.thumbIcon,
      required this.borderRadius,
      required this.label,
      required this.height,
      required this.onSwipeComplete,
      required this.loadingWidget});
  final Color bgColor;
  final Color thumbColor;
  final Widget thumbIcon;
  final Widget label;
  final double borderRadius;
  final double height;
  final Widget loadingWidget;
  final Future<void> Function() onSwipeComplete;

  @override
  State<SwipeButton> createState() => _SwipeButtonState();
}

class _SwipeButtonState extends State<SwipeButton> {
  ValueNotifier<double> position = ValueNotifier(0);
  bool shouldExpand = false;
  bool xEnd = false;
  bool xLoading = false;

  @override
  void dispose() {
    position.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      // width: Get.width,
      child: Stack(
        children: [
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: xLoading ? widget.height : Get.width,
              height: widget.height,
              decoration: BoxDecoration(
                  color: widget.bgColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius)),
            ),
          ),
          Center(
            child: xLoading ? widget.loadingWidget : widget.label,
          ),
          if (!xLoading)
            ValueListenableBuilder(
              valueListenable: position,
              builder: (context, value, child) {
                return AnimatedPositioned(
                  duration: Duration(milliseconds: xEnd ? 200 : 0),
                  left: xEnd
                      ? shouldExpand
                          ? (Get.width - 40 - widget.height)
                          : 0
                      : min(max(value - widget.height / 2, 0),
                          (Get.width - 40 - widget.height)),
                  child: Container(
                    width: widget.height,
                    height: widget.height,
                    decoration: BoxDecoration(
                        color: widget.thumbColor,
                        borderRadius:
                            BorderRadius.circular(widget.borderRadius)),
                    child: widget.thumbIcon,
                  ),
                );
              },
            ),
          GestureDetector(
            onHorizontalDragUpdate: (details) {
              xEnd = false;
              position.value = details.globalPosition.dx;
            },
            onHorizontalDragEnd: (details) async {
              xEnd = true;
              if (details.velocity.pixelsPerSecond.dx == 0) {
                if (position.value < (Get.width * 0.25)) {
                  setState(() {
                    shouldExpand = false;
                  });
                } else {
                  setState(() {
                    shouldExpand = true;
                    xLoading = true;
                    xEnd = true;
                  });
                  await widget.onSwipeComplete();
                  position.value = 0;
                  setState(() {
                    xEnd = false;
                    xLoading = false;
                    shouldExpand = false;
                  });
                }
              } else if (details.velocity.pixelsPerSecond.dx > 0.0) {
                setState(() {
                  shouldExpand = true;
                  xLoading = true;
                });
                await widget.onSwipeComplete();
                position.value = 0;
                setState(() {
                  xLoading = false;
                  shouldExpand = false;
                });
              } else {
                setState(() {
                  shouldExpand = false;
                });
              }
            },
            child: Container(
              width: Get.width,
              height: widget.height,
              color: Colors.transparent,
            ),
          )
        ],
      ),
    );
  }
}
