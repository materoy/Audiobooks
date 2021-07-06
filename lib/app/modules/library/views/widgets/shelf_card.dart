import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';

class ShelfCard extends StatelessWidget {
  const ShelfCard(
      {Key? key,
      required this.shelfName,
      this.number,
      required this.shelfIcon,
      required this.onPressed})
      : super(key: key);

  final String shelfName;
  final int? number;
  final Icon shelfIcon;
  final Function(String) onPressed;

  IconData? get commonIcons {
    switch (shelfName) {
      case 'Recently added':
        return Icons.book;
      case 'Listening':
        return Icons.book;
      case 'Completed':
        return Icons.book;
      case 'Favorites':
        return Icons.book;
      case 'New shelf':
        return Icons.book;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 15,
            height: SizeConfig.blockSizeHorizontal * 15,
            decoration: BoxDecoration(
                color: const Color(0xFFF5C599),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
                child: commonIcons != null
                    ? Icon(
                        commonIcons,
                        color: const Color(0xFFF1F1F1),
                        size: 35.0,
                      )
                    : shelfIcon),
          ),
          SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
          SizedBox(
            height: SizeConfig.blockSizeVertical * 8,
            width: SizeConfig.blockSizeHorizontal * 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(shelfName),
                if (number != null) Text('$number books'),
                const Divider(
                  color: Color(0xFFAFAFAF),
                  thickness: .7,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
