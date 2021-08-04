import 'package:audiobooks/app/global/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  @override
  Widget build(BuildContext context) {
    controller.onInit();
    return BasePage(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: Text(
          'Explore',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      child: Column(),
    );
  }
}
