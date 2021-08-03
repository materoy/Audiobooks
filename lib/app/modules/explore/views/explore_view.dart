import 'package:audiobooks/app/global/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/explore_controller.dart';

class ExploreView extends GetView<ExploreController> {
  @override
  Widget build(BuildContext context) {
    return BasePage(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
      ),
      child: Column(),
    );
  }
}
