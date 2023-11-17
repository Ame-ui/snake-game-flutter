import 'dart:math';

import 'package:cube/snake/c_snake_controller.dart';
import 'package:cube/snake/w_control_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameView extends StatefulWidget {
  const GameView({super.key});

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blueGrey.shade700,
        body: Center(
          child: GetBuilder<SnakeController>(builder: (snkController) {
            return Column(
              children: [
                // const Spacer(),
                Container(
                  decoration:
                      BoxDecoration(color: Colors.black.withOpacity(0.75)),
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        snkController.totalRow,
                        (colIndex) => Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:
                              List.generate(snkController.totalRow, (rowIndex) {
                            bool xSnake = false;
                            bool xHead = false;
                            bool xFood =
                                (snkController.snakeFood.dx == rowIndex &&
                                    snkController.snakeFood.dy == colIndex);
                            for (var element in snkController.snake) {
                              if (colIndex == element.currentPos.dy) {
                                if (rowIndex == element.currentPos.dx) {
                                  xSnake = true;
                                  xHead = element.xHead;
                                }
                              }
                            }
                            SnakeHeading snakeHeading =
                                snkController.snakeHeading;
                            return Container(
                              width: Get.width / snkController.totalRow,
                              height: Get.width / snkController.totalRow,
                              decoration: BoxDecoration(
                                  color: (xSnake)
                                      ? xHead
                                          ? Colors.green
                                          : Colors.green.shade700
                                      : (xFood)
                                          ? Colors.red
                                          : Colors.transparent,
                                  shape: xFood
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  border: xSnake
                                      ? Border.all(
                                          color: Colors.black.withOpacity(0.25))
                                      : null),
                              child: xHead
                                  ? Transform.rotate(
                                      angle: snakeHeading == SnakeHeading.up ||
                                              snakeHeading == SnakeHeading.down
                                          ? degreeToRadian(-90)
                                          : 0,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          CircleAvatar(
                                            radius: Get.width /
                                                snkController.totalRow *
                                                0.1,
                                            backgroundColor: Colors.black,
                                          ),
                                          CircleAvatar(
                                            radius: Get.width /
                                                snkController.totalRow *
                                                0.1,
                                            backgroundColor: Colors.black,
                                          )
                                        ],
                                      ),
                                    )
                                  : null,
                            );
                          }),
                        ),
                      )),
                ),
                const Spacer(),
                Visibility(
                  visible: !snkController.xGameStarted,
                  replacement: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Score : ',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 22,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        '${snkController.snake.length - 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Select Diffifulty:   ',
                        style: TextStyle(
                          color: Colors.white60,
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      DropdownButton(
                          value: snkController.totalRow,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                          dropdownColor: Colors.blueGrey,
                          iconEnabledColor: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          items: List.generate(
                              10,
                              (index) => DropdownMenuItem(
                                  value: index + 3,
                                  child: Center(
                                    child: Text(
                                      '${index + 3}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ))),
                          onChanged: (value) {
                            snkController.totalRow = value ?? 3;
                            snkController.dropFood();
                            snkController.update();
                          }),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        if (snkController.xGameStarted) {
                          snkController.moveTimer.cancel();
                          snkController.restartGame(false);
                          snkController.xGameStarted = false;
                        } else {
                          snkController.xGameStarted = true;
                          snkController.moveSnake();
                        }
                        snkController.update();
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        width: 60,
                        height: 60,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.7)),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              snkController.xGameStarted
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              size: 55,
                              color: Colors.black,
                            ),
                            Icon(
                              snkController.xGameStarted
                                  ? Icons.stop
                                  : Icons.play_arrow,
                              size: 50,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Visibility(
                        visible: snkController.xGameStarted,
                        child: SizedBox(
                          width: 50,
                        )),
                    Visibility(
                      visible: snkController.xGameStarted,
                      child: InkWell(
                        onTap: () {
                          if (snkController.xGamePause) {
                            snkController.xGamePause = false;
                            snkController.moveSnake();
                          } else {
                            snkController.xGamePause = true;
                            snkController.moveTimer.cancel();
                          }
                          snkController.update();
                        },
                        child: Container(
                          width: 60,
                          height: 60,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.green,
                            border: Border.all(
                                color: Colors.black.withOpacity(0.7)),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Icon(
                                snkController.xGamePause
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 55,
                                color: Colors.black,
                              ),
                              Icon(
                                snkController.xGamePause
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                size: 50,
                                color: Colors.yellow,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: ControlButton(
                          bgColor: !snkController.xGameStarted ||
                                  snkController.xGamePause
                              ? Colors.white24
                              : Colors.white70,
                          icon: Icons.arrow_drop_up_outlined,
                          onTap: !snkController.xGameStarted ||
                                  snkController.xGamePause
                              ? null
                              : () {
                                  snkController.snakeHeading = SnakeHeading.up;
                                }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ControlButton(
                            bgColor: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? Colors.white24
                                : Colors.white70,
                            icon: Icons.arrow_left,
                            onTap: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? null
                                : () {
                                    snkController.snakeHeading =
                                        SnakeHeading.left;
                                  }),
                        ControlButton(
                            bgColor: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? Colors.white24
                                : Colors.white70,
                            icon: Icons.arrow_drop_down,
                            onTap: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? null
                                : () {
                                    snkController.snakeHeading =
                                        SnakeHeading.down;
                                  }),
                        ControlButton(
                            bgColor: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? Colors.white24
                                : Colors.white70,
                            icon: Icons.arrow_right,
                            onTap: !snkController.xGameStarted ||
                                    snkController.xGamePause
                                ? null
                                : () {
                                    snkController.snakeHeading =
                                        SnakeHeading.right;
                                  })
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  double degreeToRadian(double degree) => degree * pi / 180;
}
