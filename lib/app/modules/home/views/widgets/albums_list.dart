import 'package:audiobooks/app/data/models/album.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'album_card.dart';

class AlbumsList extends StatelessWidget {
  const AlbumsList({Key? key, required this.albums}) : super(key: key);

  final List<Album> albums;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Obx(() => ListView.builder(
          itemCount: albums.length,
          itemBuilder: (context, index) {
            return AlbumCard(album: albums[index]);
          })),
    );
  }
}
