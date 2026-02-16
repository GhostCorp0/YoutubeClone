import 'package:flutter/material.dart';
import 'package:youtube_clone/cores/widgets/flat_button.dart';

class SearchChannelTile extends StatelessWidget {
  const SearchChannelTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, left: 10),
      child: Row(
        children: [
          CircleAvatar(radius: 40, backgroundColor: Colors.grey),
          Padding(
            padding: EdgeInsets.only(left: 35),
            child: Column(
              children: [
                Text(
                  "Aman Singh",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                ),
                Text(
                  "@aman-singh",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 13),
                ),
                Text(
                  "No Subscriptions",
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
    );
  }
}
