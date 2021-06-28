import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/media_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    controller.onReady();
    return Scaffold(
        backgroundColor: const Color(0xFF3C404B),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        drawer: Drawer(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.MEDIA_FOLDERS),
                child: const Text('Media folders'),
              ),
              ElevatedButton(
                  onPressed: () => MediaScanner(controller.localDatabase)
                      .queryMediaFolders(),
                  child: const Text('Query media Folders')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getAudiobooks(),
                  child: const Text('Get abooks')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getCollection(),
                  child: const Text('Get collections')),
              ElevatedButton(
                  onPressed: () =>
                      MediaScanner(controller.localDatabase).getUnread(),
                  child: const Text('Get unread')),
              ElevatedButton(
                  onPressed: () => controller.localDatabase.resetDatabase(),
                  child: const Text('Reset Db')),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TabLabel(label: 'Unread', onPressed: () {}, selected: false),
                  TabLabel(
                      label: 'Jump back in', onPressed: () {}, selected: true),
                  TabLabel(
                      label: 'Finished', onPressed: () {}, selected: false),
                ],
              ),
            ],
          ),
        ));
  }
}

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
    );
  }
}
