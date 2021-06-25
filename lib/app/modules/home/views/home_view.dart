import 'dart:async';
import 'dart:io';

import 'package:audiobooks/app/utils/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';

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
        // IconButton(
        //     onPressed: () async {
        //       await _pickDirectory(context);
        //       var allContents =
        //           await Directory(selectedDirectory!.path).list().toList();

        //       print(allContents.length);
        //     },
        //     icon: const Icon(Icons.playlist_add_check)),
        IconButton(
            onPressed: () async {
              var allContents = await Directory('/storage/emulated/0/Download')
                  .list()
                  .toList();

              var retriever = MetadataRetriever();
              await retriever.setFile(File(allContents[1].path));
              Metadata metadata = await retriever.metadata;

              var database = DBase();
              // database.query(query: 'DROP TABLE Audiobooks');
              // database.initDatabase();

              // database.insert(values: {
              //   "path": allContents[1].path,
              //   "trackName": metadata.trackName,
              //   "trackArtistNames": metadata.trackArtistNames!.join("|"),
              //   "albumName": metadata.albumName,
              //   "albumArtistName": metadata.albumArtistName,
              //   "trackNumber": metadata.trackNumber,
              //   "albumLength": metadata.albumLength,
              //   "year": metadata.year,
              //   "genre": metadata.genre,
              //   "authorName": metadata.authorName,
              //   "writerName": metadata.writerName,
              //   "discNumber": metadata.discNumber,
              //   "mimeType": metadata.mimeType,
              //   "trackDuration": metadata.trackDuration,
              //   "bitrate": metadata.bitrate,
              // });

              database.query().then((value) => print);
              // print(metadata.toMap());
            },
            icon: Icon(Icons.scanner))
      ],
    );
  }
}
