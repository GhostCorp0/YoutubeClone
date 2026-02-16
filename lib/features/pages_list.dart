import 'package:flutter/material.dart';
import 'package:youtube_clone/features/auth/pages/logout_page.dart';
import 'package:youtube_clone/features/search/pages/search_screen.dart';
import 'content/long_video_screen.dart';
import 'content/short_video/pages/short_video_page.dart';

List pages = [
  LongVideoScreen(),
  ShortVideoPage(),
  Center(child:Text("upload")),
  SearchScreen(),
  LogoutPage()
];