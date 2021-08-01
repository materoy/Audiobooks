import 'package:audiobooks/app/global/base_page.dart';
import 'package:audiobooks/app/modules/search/views/widgets/search_bar.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';
import 'widgets/search_card.dart';

class SearchView extends GetView<SearchController> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      navigationBar:
          const CupertinoNavigationBar(backgroundColor: Colors.transparent, middle: Text('Search')),
      child: SafeArea(
        child: Material(
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            primary: false,
            children: [
              const SearchBar(),
              // SizedBox(height: SizeConfig.blockSizeVertical * 1, width: SizeConfig.screenWidth),
              // const Text('From local library'),
              Obx(() => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 3 / 4,
                    crossAxisCount: 2,
                  ),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(bottom: SizeConfig.blockSizeVertical * 40),
                  itemCount: controller.foundAlbums.length,
                  itemBuilder: (context, index) {
                    return SearchCard(album: controller.foundAlbums[index]);
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
