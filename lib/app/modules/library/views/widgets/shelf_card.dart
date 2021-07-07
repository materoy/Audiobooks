import 'package:audiobooks/app/data/models/shelf.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';

class ShelfCard extends StatelessWidget {
  const ShelfCard({
    Key? key,
    required this.shelf,
    required this.onPressed,
  }) : super(key: key);

  final Shelf shelf;
  final VoidCallback onPressed;

  IconData? get commonIcons {
    switch (shelf.shelfName) {
      case 'Recently added':
        return Icons.book;
      case 'Listening':
        return Icons.book;
      case 'Completed':
        return Icons.book;
      case 'Favorites':
        return Icons.book;
      case 'New shelf':
        return Icons.add_task_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        margin:
            EdgeInsets.symmetric(vertical: SizeConfig.blockSizeVertical * 1.5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Container(
                width: SizeConfig.blockSizeHorizontal * 15,
                height: SizeConfig.blockSizeHorizontal * 15,
                decoration: BoxDecoration(
                    color: const Color(0xFFF5DFCA),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                    child: Icon(
                  commonIcons ?? Icons.book_rounded,
                  color: const Color(0xFFFFFFFF),
                  size: 35.0,
                ))),
            SizedBox(width: SizeConfig.blockSizeHorizontal * 5),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 8,
              width: SizeConfig.blockSizeHorizontal * 70,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    shelf.shelfName,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF110000)),
                  ),
                  Text('${shelf.amount} books'),
                  const Divider(
                    color: Color(0xFFAFAFAF),
                    thickness: .7,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
