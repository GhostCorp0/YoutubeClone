import 'package:flutter/cupertino.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:video_player/video_player.dart';
import 'package:youtube_clone/features/upload/short_video/model/short_video_model.dart';

class ShortVideoTile extends StatefulWidget {
  final ShortVideoModel shortVideo;

  const ShortVideoTile({super.key, required this.shortVideo});

  @override
  State<ShortVideoTile> createState() => _ShortVideoTileState();
}

class _ShortVideoTileState extends State<ShortVideoTile> {
  VideoPlayerController? shortVideoController;

  @override
  void initState() {
    super.initState();
    shortVideoController =
    VideoPlayerController.networkUrl(
      Uri.parse(widget.shortVideo.shortVideo),
    )
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.only(top: 20),
        child: shortVideoController!.value.isInitialized ? Column(
          children: [
            GestureDetector(
              onTap: () {
                if (!shortVideoController!.value.isPlaying) {
                  shortVideoController!.play();
                } else {
                  shortVideoController!.pause();
                }
              },
              child: AspectRatio(aspectRatio: 11 / 16,
                child: VideoPlayer(shortVideoController!),),
            ),
            Padding(
              padding: EdgeInsets.only(right: 10, left: 10, top: 6), child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.shortVideo.caption, style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold
                )),
                Text(timeago.format(
                  widget.shortVideo.datePublished
                ))
              ],
            ),)
          ],
        ):const SizedBox());
  }
}
