import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';
import 'package:youtube_clone/features/auth/model/user_model.dart';
import 'package:youtube_clone/features/channel/users_channel/pages/user_channel_page.dart';

class SearchChannelTile extends StatelessWidget {
  final UserModel user;

  const SearchChannelTile({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder:(context) =>UserChannelPage(userId:user.userId)));
        },
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.grey,
              backgroundImage: CachedNetworkImageProvider(user.profilePic),
            ),
            Padding(
              padding: EdgeInsets.only(left: 35),
              child: Column(
                children: [
                  Text(
                    user.displayName,
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    user.username,
                    style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                  ),
                  Text(
                    user.subscriptions.toString(),
                    style: TextStyle(color: Colors.blueGrey),
                  ),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 40,
                    width: 110,
                    child: FlatButton(
                      text: "Subscribe",
                      onPressed: () {},
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
