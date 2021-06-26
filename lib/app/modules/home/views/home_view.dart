import 'package:audiobooks/app/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller
        .checkDirectoryPathsExist()
        .then((value) => print("Does path exist ? $value"));
    return Scaffold(body: Container());
  }
}
