import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'm_snake.dart';

enum SnakeHeading { up, down, left, right }

class SnakeController extends GetxController {
  int totalRow = 8;
  List<SnakeBody> snake = [
    SnakeBody(xHead: true, currentPos: SnakePosition(dx: 0, dy: 0)),
  ];

  SnakePosition snakeFood = SnakePosition(dx: 0, dy: 0);
  SnakeHeading snakeHeading = SnakeHeading.right;
  bool xGameStarted = false;
  bool xGamePause = false;
  Timer moveTimer = Timer(Duration.zero, () {});

  void restartGame(bool xRestart) {
    xGameStarted = xRestart;
    snakeHeading = SnakeHeading.right;
    snake = [SnakeBody(xHead: true, currentPos: SnakePosition(dx: 0, dy: 0))];

    Future.delayed(const Duration(milliseconds: 10)).then((value) {
      dropFood();
      if (xGameStarted) {
        moveSnake();
      }
    });
    update();
  }

  void dropFood() {
    bool xValid = false;
    while (!xValid) {
      Random random = Random();
      int x = random.nextInt(totalRow);
      int y = random.nextInt(totalRow);
      SnakePosition randomPos = SnakePosition(dx: x, dy: y);
      for (var element in snake) {
        if (randomPos.dx == element.currentPos.dx &&
            randomPos.dy == element.currentPos.dy) {
          xValid = false;
          break;
        } else {
          xValid = true;
        }
      }
      if (xValid) {
        snakeFood = randomPos;
      }
    }

    update();
  }

  void checkSnake() {
    SnakePosition firstPos = snake.first.currentPos;
    for (var i = 1; i < snake.length; i++) {
      if (firstPos.dx == snake[i].currentPos.dx &&
          firstPos.dy == snake[i].currentPos.dy) {
        showMsgDialog('Failed!!!');
        break;
      }
    }
  }

  void showMsgDialog(String text) {
    moveTimer.cancel();
    showDialog(
        barrierDismissible: false,
        context: Get.context!,
        builder: (context) => AlertDialog(
              contentPadding: EdgeInsets.zero,
              backgroundColor: Colors.blueGrey,
              content: SizedBox(
                width: Get.width,
                height: Get.width / 3,
                child: Stack(
                  alignment: const Alignment(1.1, -1.4),
                  children: [
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            text,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                shadows: [
                                  Shadow(
                                      color: Colors.black, offset: Offset(2, 2))
                                ]),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          InkWell(
                              onTap: () {
                                restartGame(true);

                                Get.back();
                              },
                              child: Container(
                                // width: 100,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text(
                                  'Restart',
                                  style: TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      shadows: [
                                        Shadow(
                                            color: Colors.black,
                                            offset: Offset(2, 2))
                                      ]),
                                ),
                              ))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        restartGame(false);
                        Get.back();
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.green,
                          border:
                              Border.all(color: Colors.black.withOpacity(0.7)),
                        ),
                        child: const Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              Icons.close,
                              size: 40,
                              color: Colors.black,
                            ),
                            Icon(
                              Icons.close,
                              size: 35,
                              color: Colors.yellow,
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ));
  }

  void moveSnake() {
    moveTimer = Timer.periodic(const Duration(milliseconds: 350), (timer) {
      switch (snakeHeading) {
        case SnakeHeading.up:
          if (snake.first.currentPos.dy > 0) {
            adjustSnake(
                xGotFood: (snakeFood.dx == (snake.first.currentPos.dx) &&
                    snakeFood.dy == (snake.first.currentPos.dy - 1)));
            snake.first.currentPos.dy--;

            checkSnake();
            update();
          } else {
            showMsgDialog('Failed!!!');
          }
          break;

        case SnakeHeading.left:
          if (snake.first.currentPos.dx > 0) {
            adjustSnake(
                xGotFood: (snakeFood.dx == (snake.first.currentPos.dx - 1) &&
                    snakeFood.dy == (snake.first.currentPos.dy)));
            snake.first.currentPos.dx--;
            checkSnake();
            update();
          } else {
            showMsgDialog('Failed!!!');
          }
          break;
        case SnakeHeading.down:
          if (snake.first.currentPos.dy < (totalRow - 1)) {
            adjustSnake(
                xGotFood: (snakeFood.dx == (snake.first.currentPos.dx) &&
                    snakeFood.dy == (snake.first.currentPos.dy + 1)));
            snake.first.currentPos.dy++;
            checkSnake();
            update();
          } else {
            showMsgDialog('Failed!!!');
          }
          break;
        case SnakeHeading.right:
          if (snake.first.currentPos.dx < (totalRow - 1)) {
            adjustSnake(
                xGotFood: (snakeFood.dx == (snake.first.currentPos.dx + 1) &&
                    snakeFood.dy == (snake.first.currentPos.dy)));
            snake.first.currentPos.dx++;
            checkSnake();
            update();
          } else {
            showMsgDialog('Failed!!!');
          }
          break;
      }
    });
  }

  void adjustSnake({bool xGotFood = false}) {
    {
      if (xGotFood) {
        snake.add(
            SnakeBody(xHead: false, currentPos: SnakePosition(dx: 0, dy: 0)));
      }
      for (var i = snake.length - 1; i > 0; i--) {
        snake[i].currentPos = SnakePosition(
            dx: snake[i - 1].currentPos.dx, dy: snake[i - 1].currentPos.dy);
      }
      if (snake.length != totalRow * totalRow) {
        if (xGotFood) {
          Future.delayed(const Duration(milliseconds: 10))
              .then((value) => dropFood());
        }
      } else {
        showMsgDialog('Success!!!');
      }
    }
  }

  bool xGotFood() => false;

  @override
  void onInit() {
    dropFood();
    super.onInit();
  }
}
