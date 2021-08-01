import 'package:audiobooks/app/data/models/album.dart';
import 'package:audiobooks/app/routes/app_pages.dart';
import 'package:audiobooks/app/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee_text/marquee_text.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({Key? key, required this.album}) : super(key: key);

  final Album album;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PLAYER, arguments: album),
      child: Column(
        children: [
          Container(
            height: SizeConfig.blockSizeVertical * 28.0,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: const Color(0xFFC4C4C4), borderRadius: BorderRadius.circular(15.0)),
            margin: EdgeInsets.symmetric(
                vertical: SizeConfig.blockSizeVertical * 2,
                horizontal: SizeConfig.blockSizeHorizontal * 3),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  clipBehavior: Clip.hardEdge,
                  width: double.infinity,
                  height: SizeConfig.blockSizeVertical * 20.0,
                  decoration: BoxDecoration(
                    color: Colors.brown[50],
                  ),
                  child: album.albumArt != null
                      ? Image.memory(album.albumArt!, fit: BoxFit.cover)
                      : Container(
                          color: Colors.grey,
                          // child: ,
                        ),
                ),

                /// The [album] name
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 10.0),
                  height: SizeConfig.blockSizeVertical * 3.0,
                  child: MarqueeText(
                    text: album.albumName,
                    style: Theme.of(context).textTheme.bodyText2,
                    speed: 7.0,
                  ),
                ),

                if (album.albumAuthor != '')

                  // /// Author names
                  Container(
                    padding: const EdgeInsets.only(top: 1.0, bottom: 1.0, left: 8.0),
                    alignment: Alignment.centerLeft,
                    child: RichText(
                      text: TextSpan(
                          text: album.albumAuthor,
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 10)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                const Spacer(),
              ],
            ),
          ),
          // SizedBox(
          //     height: SizeConfig.blockSizeVertical * 2,
          //     child: ),
        ],
      ),
    );
  }
}
