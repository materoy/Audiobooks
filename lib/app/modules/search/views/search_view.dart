import 'package:audiobooks/app/global/base_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/search_controller.dart';

class SearchView extends GetView<SearchController> {
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
