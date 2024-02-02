import 'package:cube/w_swipe_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool xLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SwipeButton(
                  bgColor: Colors.blue,
                  thumbColor: Colors.amber,
                  thumbIcon: const Icon(
                    TablerIcons.arrow_right,
                    color: Colors.black,
                  ),
                  onSwipeComplete: () async {
                    await Future.delayed(const Duration(seconds: 3));
                  },
                  loadingWidget: const CircularProgressIndicator(
                    color: Colors.white,
                  ),
                  height: 60,
                  borderRadius: 100,
                  label: const Text(
                    'Swipe right',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
