import 'package:flutter/material.dart';

class TabLabel extends StatelessWidget {
  const TabLabel(
      {Key? key,
      required this.label,
      required this.onPressed,
      required this.selected})
      : super(key: key);
  final String label;
  final VoidCallback onPressed;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: selected ? 1.0 : .5,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9.0, vertical: 7.0),
          decoration: BoxDecoration(
              color: selected ? Colors.blue : Colors.transparent,
              border: Border.all(
                color: Colors.blue,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(15.0)),
          child: Text(
            label,
            style: TextStyle(color: selected ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}
