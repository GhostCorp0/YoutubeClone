import 'package:flutter/material.dart';
import 'package:youtube_clone/features/search/pages/search_screen.dart';

import 'content/long_video_screen.dart';

List pages = [
  SearchScreen(),
  LongVideoScreen(),
  Center(child:Text("shorts")),
  Center(child:Text("upload")),
  Center(child:Text("Home")),
  Center(child:Text("Home")),
];