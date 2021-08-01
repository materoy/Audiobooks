import 'package:audiobooks/app/modules/search/controllers/search_controller.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SearchBar extends GetView<SearchController> {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: SizeConfig.blockSizeVertical * 6,
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.blockSizeHorizontal * 5,
          vertical: SizeConfig.blockSizeVertical * 2),
      child: TextField(
        onChanged: (value) async {
          if (value != '') {
            controller.searchText = value;
            await controller.searchDatabase();
          }
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0), borderSide: BorderSide.none),
          fillColor: const Color(0xFFE0E0E0),
          filled: true,
          hintText: 'Search Title of the book or Author',
          hintStyle: Theme.of(context).textTheme.caption,
        ),
      ),
    );
  }
}
