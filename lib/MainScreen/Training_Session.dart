import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../ReusableWidget/FullScreenVideoPlayer.dart';

class TrainingSession extends StatefulWidget {
  const TrainingSession({super.key});

  @override
  State<TrainingSession> createState() => _TrainingSessionState();
}

class _TrainingSessionState extends State<TrainingSession> {
  //final CollectionReference _trainingSessionRef =
  //    FirebaseFirestore.instance.collection('Training Session');

  //final PagingController<int, DocumentSnapshot> _pagingController =
  //    PagingController(firstPageKey: 0);

  static const int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    //_pagingController.addPageRequestListener(_fetchPage);
  }
/*
  Future<void> _fetchPage(int pageKey) async {
    try {
      Query query = _trainingSessionRef.orderBy('date', descending: true);

      if (pageKey > 0 && _pagingController.itemList != null) {
        final lastDocument = _pagingController.itemList!.last;
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query.limit(_pageSize).get();
      final newItems = querySnapshot.docs;

      if (newItems.length < _pageSize) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, pageKey + newItems.length);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }*/

  @override
  void dispose() {
    //_pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text(
          'Training Session',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 144, 235),
        iconTheme: const IconThemeData(color: Colors.white),
      ), /*
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedListView<int, DocumentSnapshot>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            itemBuilder: (context, item, index) {
              final data = item.data() as Map<String, dynamic>;
              return _buildVideoCard(data);
            },
            firstPageProgressIndicatorBuilder: (_) =>
                _buildShimmerPlaceholder(),
            newPageProgressIndicatorBuilder: (_) =>
                Center(child: _buildWaveDotsLoader()),
            noItemsFoundIndicatorBuilder: (_) => const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ),
      ),*/
    );
  }

  DateTime _parseDateTime(String date, String time) {
    final formattedDate = date.split('-').reversed.join('-');
    final dateTimeStr = "$formattedDate $time";
    return DateFormat('yyyy-MM-dd hh:mm a').parse(dateTimeStr);
  }

  Widget _buildVideoCard(Map<String, dynamic> data) {
    final String videoLink = data['video_link'] ?? '';

    return GestureDetector(
      onTap: () {
        final videoId = YoutubePlayer.convertUrlToId(videoLink);
        if (videoId != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FullScreenVideoPlayer(videoId: videoId),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Invalid YouTube URL")),
          );
        }
      },
      child: Card(
        color: const Color.fromARGB(255, 229, 229, 230),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    data["title"] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  Text(
                    data["time"] ?? '',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color.fromARGB(255, 77, 76, 76),
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.grey),
              const SizedBox(height: 8),
              Text(
                data["date"] ?? '',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color.fromARGB(255, 70, 69, 69),
                ),
                textAlign: TextAlign.end,
              ),
              const SizedBox(height: 8),
              FutureBuilder<String>(
                future: _getThumbnail(videoLink),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: 200,
                      child: Center(child: _buildWaveDotsLoader()),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data == null) {
                    return const SizedBox.shrink();
                  }
                  return Container(
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(snapshot.data!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Column(
      children: List.generate(
        3,
        (index) => ShimmerPro.generated(
          light: ShimmerProLight.lighter,
          scaffoldBackgroundColor: const Color(0xFF161B22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPro.text(
                light: ShimmerProLight.lighter,
                scaffoldBackgroundColor: const Color(0xFF161B22),
                width: 300,
                maxLine: 2,
              ),
              const SizedBox(height: 8),
              ShimmerPro.sized(
                light: ShimmerProLight.lighter,
                scaffoldBackgroundColor: const Color(0xFF161B22),
                height: 220,
                width: double.infinity,
                borderRadius: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveDotsLoader() {
    return LoadingAnimationWidget.waveDots(
      color: const Color.fromARGB(255, 0, 0, 0),
      size: 50,
    );
  }

  Future<String> _getThumbnail(String videoUrl) async {
    final videoId = YoutubePlayer.convertUrlToId(videoUrl);
    return "enter the video url"; //'https://img.youtube.com/vi/$videoId/0.jpg';
  }
}
