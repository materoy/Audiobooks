import 'dart:developer';

import 'package:audiobooks/app/data/models/track_entry.dart';
import 'package:audiobooks/app/modules/home/views/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'collection_card.dart';

class TracksList extends StatelessWidget {
  const TracksList({Key? key, required this.trackEntries}) : super(key: key);
  final List<TrackEntry> trackEntries;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Obx(() => ListView.builder(
          itemCount: trackEntries.length,
          itemBuilder: (context, index) {
            return trackEntries[index].collectionId != null
                ? CollectionCard(trackEntry: trackEntries[index])
                : TrackCard(trackEntry: trackEntries[index]);
          })),
    );
  }
}
