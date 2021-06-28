import 'package:audiobooks/app/data/models/track_.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TrackCard extends StatefulWidget {
  const TrackCard({Key? key, required this.track}) : super(key: key);
  final Track track;

  @override
  _TrackCardState createState() => _TrackCardState();
}

class _TrackCardState extends State<TrackCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      height: SizeConfig.blockSizeVertical * 17,
      width: SizeConfig.blockSizeHorizontal * 80,
      decoration: BoxDecoration(
          color: const Color(0xFFC4C4C4),
          borderRadius: BorderRadius.circular(20.0)),
      margin: EdgeInsets.symmetric(
          vertical: SizeConfig.blockSizeVertical * 2,
          horizontal: SizeConfig.blockSizeHorizontal * 3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: SizeConfig.blockSizeHorizontal * 25,
            decoration: BoxDecoration(
                color: Colors.brown[50],
                borderRadius: BorderRadius.circular(13)),
          ),
          const Spacer(),
          SizedBox(
            width: SizeConfig.blockSizeHorizontal * 35,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(widget.track.name, textAlign: TextAlign.center)],
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Column(
              children: [
                Row(
                  children: [ProgressIndicator(), PlayPauseButton()],
                ),
              ],
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class ProgressIndicator extends StatefulWidget {
  const ProgressIndicator({Key? key}) : super(key: key);

  @override
  _ProgressIndicatorState createState() => _ProgressIndicatorState();
}

class _ProgressIndicatorState extends State<ProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return const CircleAvatar(
      radius: 18.0,
      child: CircleAvatar(
        backgroundColor: Colors.grey,
      ),
    );
  }
}

class PlayPauseButton extends StatefulWidget {
  const PlayPauseButton({Key? key}) : super(key: key);

  @override
  _PlayPauseButtonState createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration:
          const BoxDecoration(shape: BoxShape.circle, color: Colors.grey),
      child: const Center(child: Icon(CupertinoIcons.play)),
    );
  }
}
