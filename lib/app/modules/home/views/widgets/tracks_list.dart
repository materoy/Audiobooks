import 'package:audiobooks/app/data/models/track_.dart';
import 'package:audiobooks/app/modules/home/views/widgets/track_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TracksList extends StatelessWidget {
  const TracksList({Key? key, required this.tracks}) : super(key: key);
  final List<Track> tracks;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Obx(() => ListView.builder(
          itemCount: tracks.length,
          itemBuilder: (context, index) {
            return TrackCard(track: tracks[index]);
          })),
    );
  }
}
