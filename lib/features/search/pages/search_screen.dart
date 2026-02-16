import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:youtube_clone/cores/widgets/custom_button.dart';
import 'package:youtube_clone/features/search/providers/search_providers.dart';
import 'package:youtube_clone/features/search/widgets/search_channel_tile_widget.dart';
import 'package:youtube_clone/features/upload/long_video/video_model.dart';

import '../../auth/model/user_model.dart';
import '../../content/Long_video/parts/post.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  List foundItems = [];

  filterList(String keywordSelected) async {
    List result = [];
    List<UserModel> users = await ref.watch(allChannelsProvider);
    List<VideoModel> videos = await ref.watch(allVideosProvider);
    
    final foundChannels = users.where((user) {
      return user.displayName.toString().toLowerCase().contains(keywordSelected);
    }).toList();

    result.addAll(foundChannels);

    final foundVideos = await videos.where((video) {
      return video.title.toString().toLowerCase().contains(keywordSelected);
    }).toList();

    result.add(foundVideos);

    setState(() {
      result.shuffle();
      foundItems = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back)),
                  SizedBox(
                    height: 45,
                    width: 270,
                    child: TextFormField(
                      onChanged:(value) async {
                        await filterList(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Youtube...',
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 39,
                    width: 65,
                    child: CustomButton(
                      iconData: Icons.search,
                      onTap: () {},
                      haveColor: true,
                    ),
                  ),
                ],
              ),
             Expanded(child: ListView.builder(
               itemCount: foundItems.length,
               itemBuilder:(context,index){
                 List<Widget> itemsWidgets = [];
                 final selectedItem = foundItems[index];

                 if(selectedItem.type == 'video') {
                   itemsWidgets.add(Post(video:selectedItem));
                 }else if(selectedItem.type == 'user') {
                   itemsWidgets.add(const SearchChannelTile());
                 }else if(foundItems.isEmpty){
                   return SizedBox();
                 }

                 return itemsWidgets[0];
               },
             ))
            ],
          ),
        ),
      ),
    );
  }
}
