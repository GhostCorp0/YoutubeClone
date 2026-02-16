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

  Future<void> filterList(String keywordSelected) async {
    final keyword = keywordSelected.trim().toLowerCase();
    if (keyword.isEmpty) {
      setState(() => foundItems = []);
      return;
    }

    final users = await ref.read(allChannelsProvider);
    final videos = await ref.read(allVideosProvider);

    final foundChannels = users
        .where((user) =>
            user.displayName.toString().toLowerCase().contains(keyword))
        .toList();
    final foundVideos = videos
        .where((video) =>
            video.title.toString().toLowerCase().contains(keyword))
        .toList();

    final List<dynamic> result = [];
    result.addAll(foundChannels);
    result.addAll(foundVideos);
    result.shuffle();

    if (mounted) setState(() => foundItems = result);
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
                  IconButton(onPressed: () {}, icon: Icon(Icons.arrow_back,color: Colors.grey.shade700)),
                  SizedBox(
                    height: 43,
                    width: 279,
                    child: TextFormField(
                      onChanged:(value) async {
                        await filterList(value);
                      },
                      decoration: InputDecoration(
                        hintText: 'Search Youtube...',
                        border: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius:BorderRadius.all(Radius.circular(18)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        filled: true,
                        fillColor: Color(0xfff2f2f2),
                        contentPadding: EdgeInsets.only(left:13,bottom: 12),
                        hintStyle: TextStyle(fontSize: 14,fontWeight:FontWeight.w500)
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 43,
                    width: 55,
                    child: CustomButton(
                      iconData: Icons.search,
                      onTap: () {},
                      haveColor: true,
                    ),
                  ),
                ],
              ),
              Expanded(
                child: foundItems.isEmpty
                    ? const Center(child: Text('Search for channels or videos'))
                    : ListView.builder(
                        itemCount: foundItems.length,
                        itemBuilder: (context, index) {
                          final item = foundItems[index];
                          if (item is VideoModel) {
                            return Post(video: item);
                          }
                          if (item is UserModel) {
                            return SearchChannelTile(user:item);
                          }
                          return const SizedBox.shrink();
                        },
                      ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
