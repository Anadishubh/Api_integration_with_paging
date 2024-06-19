import 'package:apiproject/video_player.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:apiproject/api_fetch.dart';
import 'model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final scrollController = ScrollController();
  List<InstagramPost> posts = [];
  bool isLoading = false;
  final InstagramData instagramData = InstagramData();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    _fetchPosts();
  }

  Future<void> _fetchPosts() async {
    setState(() {
      isLoading = true;
    });
    try {
      List<InstagramPost> fetchedPosts = await instagramData.fetchPosts(10);
      setState(() {
        posts.addAll(fetchedPosts);
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      if (kDebugMode) {
        print('Error fetching posts: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffb42bfd),
        title: Text(
          'Instagram Clone',
          style: GoogleFonts.kanit(
            textStyle:
            const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      backgroundColor: Colors.white70,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: posts.isEmpty && isLoading
            ? const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        )
            : GridView.builder(
          controller: scrollController,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 5.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: posts.length + (isLoading ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == posts.length) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final post = posts[index];
            return Card(
              child: Column(
                children: [
                  if (post.mediaType == 'IMAGE')
                    Image.network(post.mediaUrl),
                  if (post.mediaType == 'VIDEO')
                    SizedBox(
                      width: double.infinity,
                      height: 178,
                      child: VideoPlayerWidget(
                        videoUrl: post.mediaUrl,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _scrollListener() {
    if (!isLoading && scrollController.position.pixels == scrollController.position.maxScrollExtent) {
      _fetchPosts();
    }
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}