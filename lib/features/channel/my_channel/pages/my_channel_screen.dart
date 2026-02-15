import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/screens/error_page.dart';
import 'package:youtube_clone/cores/widgets/image_button.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/tab_bar.dart';
import 'package:youtube_clone/features/channel/my_channel/parts/top_header.dart';

import '../../../../cores/screens/loader.dart';
import '../parts/buttons.dart';
import '../parts/tab_bar_view.dart';

class MyChannelScreen extends ConsumerWidget {
  const MyChannelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(currentUserProvider)
        .when(
          data: (currentUser) => DefaultTabController(
            length: 7,
            child: Scaffold(
              body: SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Column(
                    children: [
                      TopHeader(user:currentUser),
                      Text("More about this channel"),
                      Buttons(),
                      //Create tab bar
                      PageTabBar(),
                      TabPages(),
                    ],
                  ),
                ),
              ),
            ),
          ),
          error: (error, stackTrace) => ErrorPage(),
          loading: () => Loader(),
        );
  }
}
