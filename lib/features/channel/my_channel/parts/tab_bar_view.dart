import 'package:flutter/material.dart';
import 'package:youtube_clone/features/channel/my_channel/pages/home_channel_page.dart';

class TabPages extends StatelessWidget {
  const TabPages({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(
        children: [
          HomeChannelPage(),
          Center(child: Text("Videos")),
          Center(child: Text("Shorts")),
          Center(child: Text("Community")),
          Center(child: Text("Playlists")),
          Center(child: Text("Channels")),
          Center(child: Text("About")),
        ],
      ),
    );
  }
}
