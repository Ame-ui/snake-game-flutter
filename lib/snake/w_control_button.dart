import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  const ControlButton(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.bgColor});
  final IconData icon;
  final Function()? onTap;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 45,
          color: Colors.black,
        ),
      ),
    );
  }
}
