import 'dart:async';
import 'dart:io';

import 'package:audiobooks/app/helpers/media_scanner.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:easy_folder_picker/FolderPicker.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: DirPicker(),
    ));
  }
}

class DirPicker extends StatefulWidget {
  const DirPicker({Key? key}) : super(key: key);

  @override
  _DirPickerState createState() => _DirPickerState();
}

class _DirPickerState extends State<DirPicker> {
  Directory? selectedDirectory;

  Future<void> _pickDirectory(BuildContext context) async {
    var directory = selectedDirectory;
    directory ??= Directory(FolderPicker.ROOTPATH);
    var newDirectory = await FolderPicker.pick(
        allowFolderCreation: false,
        context: context,
        rootDirectory: directory,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))));
    // setState(() {
    selectedDirectory = newDirectory;
    print(selectedDirectory);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () async {
              await _pickDirectory(context);
              var allContents =
                  await Directory(selectedDirectory!.path).list().toList();

              print(allContents);
            },
            icon: const Icon(Icons.playlist_add_check)),
        IconButton(
            onPressed: () {
              var dir = Directory('/storage/emulated/0/Download');
              var files = <FileSystemEntity>[];
              var completer = Completer<List<FileSystemEntity>>();
              var lister = dir.list(recursive: false);
              lister.listen((file) => files.add(file),
                  // should also register onError
                  onDone: () => completer.complete(files));
              completer.future;
              print(files);
            },
            icon: Icon(Icons.scanner))
      ],
    );
  }
}
