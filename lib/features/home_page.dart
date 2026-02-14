import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:youtube_clone/features/auth/provider/user_provider.dart';

import '../cores/screens/error_page.dart';
import '../cores/screens/loader.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                Image.asset("assets/images/youtube.jpg", height: 36),
                const SizedBox(width: 4),
                Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 12),
                  child: SizedBox(
                    height: 42,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset("assets/icons/cast.png"),
                    ),
                  ),
                ),
                SizedBox(
                  height: 38,
                  child: IconButton(
                    onPressed: () {},
                    icon: Image.asset("assets/icons/notification.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 12, right: 15),
                  child: SizedBox(
                    height: 41.5,
                    child: IconButton(
                      onPressed: () {},
                      icon: Image.asset("assets/icons/search.png"),
                    ),
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    return ref
                        .watch(currentUserProvider)
                        .when(
                          data: (currentUser) => Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: CircleAvatar(
                              radius: 14,
                              backgroundColor: Colors.grey,
                              backgroundImage:CachedNetworkImageProvider(currentUser.profilePic),
                            ),
                          ),
                          error: (error, stackTrace) => const ErrorPage(),
                          loading: () => Loader(),
                        );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
