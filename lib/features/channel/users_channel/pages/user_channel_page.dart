import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/users_channel/provider/channel_provider.dart';

import '../../../../cores/screens/loader.dart';
import '../../../content/Long_video/parts/post.dart';

class UserChannelPage extends StatefulWidget {
  final String userId;

  const UserChannelPage({super.key, required this.userId});

  @override
  State<UserChannelPage> createState() => _UserChannelPageState();
}

class _UserChannelPageState extends State<UserChannelPage> {
  bool haveVideos = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                return ref
                    .watch(anyUserDataProvider(widget.userId))
                    .when(
                      data: (user) => Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Image.asset("assets/images/flutter background.png"),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 12,
                              right: 12,
                              top: 20,
                            ),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 38,
                                  backgroundColor: Colors.grey,
                                  backgroundImage: CachedNetworkImageProvider(
                                    user.profilePic,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 12),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.displayName,
                                        style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        user.username,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      RichText(
                                        text: TextSpan(
                                          style: TextStyle(
                                            color: Colors.blueGrey,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "${user.subscriptions.length} subscriptions ",
                                            ),
                                            TextSpan(
                                              text: "${user.videos} videos ",
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              top: 20,
                              left: 8,
                              right: 8,
                            ),
                            child: FlatButton(
                              text: "SUBSCRIBE",
                              onPressed: () {},
                              color: Colors.black,
                            ),
                          ),
                          user.videos == 0
                              ? Center(
                                  child: Text(
                                    "No Video",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    left: 10,
                                    top: 14,
                                  ),
                                  child: Text(
                                    "${user.displayName} Videos",
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      error: (error, stackTrace) => ErrorPage(),
                      loading: () => Loader(),
                    );
              },
            ),
            // Second Consumer Widget
            Consumer(
              builder: (context, ref, child) {
                return ref
                    .watch(eachChannelVideosProvider(widget.userId))
                    .when(
                      data: (videos) => Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.sizeOf(context).height * 0.2,
                        ),
                        child: SizedBox(
                          height: 80,
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 8.0,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount: videos.length,
                            itemBuilder: (context, index) {
                              if (videos.isNotEmpty) {
                                return Post(video: videos[index]);
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      error: (error, stackTrace) => ErrorPage(),
                      loading: () => Loader(),
                    );
              },
            ),
          ],
        ),
      ),
    );
  }
}
