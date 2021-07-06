import 'package:flutter/material.dart';

class ShelfCard extends StatelessWidget {
  const ShelfCard(
      {Key? key,
      required this.shelfName,
      required this.number,
      required this.shelfIcon,
      required this.onPressed})
      : super(key: key);

  final String shelfName;
  final int number;
  final Icon shelfIcon;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(),
          Column(
            children: [
              Text(shelfName),
              Text('$number books'),
              const Divider(),
            ],
          ),
        ],
      ),
    );
  }
}
