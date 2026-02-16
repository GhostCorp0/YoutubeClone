// ignore_for_file: public_member_api_docs, sort_constructors_first, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:youtube_clone/cores/colors.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/screens/loader.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/content/Long_video/parts/post.dart';
import 'package:youtube_clone/features/content/comment/comment_provider.dart';
import 'package:youtube_clone/features/upload/comments/comment_model.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';
import 'package:youtube_clone/features/upload/long_video/video_repository.dart';

import '../../../channel/users_channel/subscribe_repository.dart';
import '../../comment/comment_sheet.dart';
import '../widgets/video_external_buttons.dart';
import '../widgets/video_first_comment.dart';

class Video extends ConsumerStatefulWidget {
  final VideoModel video;
  const Video({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  ConsumerState<Video> createState() => _VideoState();
}

class _VideoState extends ConsumerState<Video> {
  bool isShowIcons = false;
  bool isPlaying = false;
  VideoPlayerController? _controller;

  @override
  void initState() {
    super.initState();
    _initializeVideo();
  }

  void _initializeVideo() {
    try {
      _controller = VideoPlayerController.networkUrl(
        Uri.parse(widget.video.videoUrl),
      )..initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      }).catchError((error) {
        // Handle video initialization error
        debugPrint('Video initialization error: $error');
        if (mounted) {
          setState(() {});
        }
      });
    } catch (e) {
      debugPrint('Error creating video controller: $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  toggleVideoPlayer() {
    if (_controller == null) return;

    if (_controller!.value.isPlaying) {
      // pause the video
      _controller!.pause();
      isPlaying = false;
      setState(() {});
    } else {
      // play the video
      _controller!.play();
      isPlaying = true;
      setState(() {});
    }
  }

  goBackward() {
    if (_controller == null) return;

    Duration position = _controller!.value.position;
    position = position - Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  goForward() {
    if (_controller == null) return;

    Duration position = _controller!.value.position;
    position = position + Duration(seconds: 1);
    _controller!.seekTo(position);
  }

  likeVideo() async {
    await ref.watch(longVideoProvider).likeVideo(
      currentUserId: FirebaseAuth.instance.currentUser!.uid,
      likes: widget.video.likes,
      videoId: widget.video.videoId,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<UserModel> user = ref.watch(
      anyUserDataProvider(widget.video.userId),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(176),
          child: _controller != null && _controller!.value.isInitialized
              ? AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowIcons = !isShowIcons;
                });
              },
              child: Stack(
                children: [
                  VideoPlayer(_controller!),
                  if (isShowIcons)
                    Positioned(
                      left: 170,
                      top: 92,
                      child: GestureDetector(
                        onTap: toggleVideoPlayer,
                        child: SizedBox(
                          height: 50,
                          child: Image.asset(
                            "assets/images/play.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (isShowIcons)
                    Positioned(
                      right: 55,
                      top: 93,
                      child: GestureDetector(
                        onTap: goForward,
                        child: SizedBox(
                          height: 50,
                          child: Image.asset(
                            "assets/images/go_back_final.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  if (isShowIcons)
                    Positioned(
                      left: 48,
                      top: 94,
                      child: GestureDetector(
                        onTap: goBackward,
                        child: SizedBox(
                          height: 50,
                          child: Image.asset(
                            "assets/images/go ahead final.png",
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      height: 7.5,
                      child: VideoProgressIndicator(
                        _controller!,
                        allowScrubbing: true,
                        colors: VideoProgressColors(
                          playedColor: Colors.red,
                          bufferedColor: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
              : Padding(
            padding: EdgeInsets.only(bottom: 100),
            child: Loader(),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 13, top: 4),
              child: Text(
                widget.video.title,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 7,
                top: 5,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 8,
                      right: 4,
                    ),
                    child: Text(
                      widget.video.views == 0
                          ? "No view"
                          : "${widget.video.views} views",
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 4, right: 8),
                    child: Text(
                      timeago.format(widget.video.datePublished),
                      style: const TextStyle(
                        fontSize: 13.4,
                        color: Color(0xff5F5F5F),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            user.when(
              data: (userData) => Padding(
                padding: const EdgeInsets.only(
                  left: 12,
                  top: 9,
                  right: 9,
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(
                        userData.profilePic,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 5,
                      ),
                      child: Text(
                        userData.displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(right: 6, left: 6),
                      child: Text(
                        userData.subscriptions.isEmpty
                            ? "No subscriptions"
                            : "${userData.subscriptions.length} subscriptions",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      height: 35,
                      width: 100,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: FlatButton(
                          text: "Subscribe",
                          onPressed: () async {
                            // subscribe channel
                            await ref
                                .watch(subscribeChannelProvider)
                                .subscribeChannel(
                              userId: userData.userId,
                              currentUserId:
                              FirebaseAuth.instance.currentUser!.uid,
                              subscriptions: userData.subscriptions,
                            );
                          },
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => Padding(
                padding: EdgeInsets.all(12),
                child: Loader(),
              ),
              error: (error, stack) => Padding(
                padding: EdgeInsets.all(12),
                child: Text('Error loading user data'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 9, top: 10.5, right: 9),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 6,
                      ),
                      decoration: const BoxDecoration(
                        color: softBlueGreyBackGround,
                        borderRadius: BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: likeVideo,
                            child: Icon(
                              Icons.thumb_up,
                              color: widget.video.likes.contains(
                                  FirebaseAuth.instance.currentUser!.uid)
                                  ? Colors.blue
                                  : Colors.black,
                              size: 15.5,
                            ),
                          ),
                          const SizedBox(width: 19),
                          const Icon(
                            Icons.thumb_down,
                            size: 15.5,
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 9, right: 9),
                      child: VideoExtraButton(
                        text: "Share",
                        iconData: Icons.share,
                      ),
                    ),
                    const VideoExtraButton(
                      text: "Remix",
                      iconData: Icons.analytics_outlined,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 9,
                        right: 9,
                      ),
                      child: VideoExtraButton(
                        text: "Download",
                        iconData: Icons.download,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // comment Box - FIXED: Added null safety check
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => CommentSheet(
                      video: widget.video,
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8),
                    ),
                  ),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final AsyncValue<List<CommentModel>> comments = ref.watch(
                        commentsProvider(widget.video.videoId),
                      );
                      return comments.when(
                        data: (commentsList) {
                          if (commentsList.isEmpty) {
                            return const SizedBox(
                              height: 20,
                            );
                          }
                          return user.when(
                            data: (userData) => VideoFirstComment(
                              comments: commentsList,
                              user: userData,
                            ),
                            loading: () => SizedBox(height: 20),
                            error: (_, __) => SizedBox(height: 20),
                          );
                        },
                        loading: () => const SizedBox(height: 20),
                        error: (error, stack) => const SizedBox(height: 20),
                      );
                    },
                  ),
                ),
              ),
            ),

            // FIXED: Removed Expanded widget from ListView
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("videos")
                  .where("videoId", isNotEqualTo: widget.video.videoId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return ErrorPage();
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return Loader();
                }

                final videosMap = snapshot.data!.docs;
                final videos = videosMap
                    .map(
                      (video) => VideoModel.fromMap(video.data()),
                )
                    .toList();
                return ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: videos.length,
                  itemBuilder: (context, index) {
                    return Post(
                      video: videos[index],
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}