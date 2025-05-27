//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:capittalgrowth/ReusableWidget/extraMore.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../ReusableWidget/MoreDetails.dart';

class AboutIndicator extends StatefulWidget {
  const AboutIndicator({super.key});

  @override
  State<AboutIndicator> createState() => _AboutIndicatorState();
}

class _AboutIndicatorState extends State<AboutIndicator> {
  final List<Map<String, String>> indicatorDetails = [
    {
      'title': 'Confirmation Tools',
      'time': '12:52 PM',
      'description':
          'The Action Indicator works seamlessly with other indicators to confirm signals, reducing noise and improving accuracy.',
      'image': 'assets/Chart.jpg', // Replace with actual image path
      'date': '14-10-2024',
    },
    {
      'title': 'Accuracy and Precision',
      'time': '11:30 AM',
      'description':
          'The Indicator provides highly accurate signals that align with market trends, minimizing false signals and enhancing performance.',
      'date': '14-10-2024',
    },
    {
      'title': 'Volatility Sensitivity',
      'time': '01:12 PM',
      'description':
          'The Action Indicator is sensitive to market volatility, allowing traders to make informed decisions during price fluctuations.',
      'date': '14-10-2024',
    },
  ];
  //final CollectionReference _aboutRsIndicatorRef = FirebaseFirestore.instance
  //.collection('About Trade with Experts Indicator');

  //final PagingController<int, DocumentSnapshot> _pagingController =
  //PagingController(firstPageKey: 0);

  static const int _pageSize = 3;
  bool isDarkTheme = true;
  late Color bgColor;
  late ShimmerProLight shimmerLight;

  @override
  void initState() {
    super.initState();
    _initializeTheme();
    //_pagingController.addPageRequestListener(_fetchPage);
  }

  void _initializeTheme() {
    isDarkTheme = false;
    bgColor = const Color.fromARGB(255, 255, 255, 255);
    shimmerLight = ShimmerProLight.lighter;
  }

  Future<void> _fetchPage(int pageKey) async {
    //try {
    ///Query query = _aboutRsIndicatorRef.orderBy('date', descending: true);

    //if (pageKey > 0 && _pagingController.itemList != null) {
    //  final lastDocument = _pagingController.itemList!.last;
    //  query = query.startAfterDocument(lastDocument);
    //}

    //final querySnapshot = await query.limit(_pageSize).get();
    //final newItems = querySnapshot.docs;

    //if (newItems.length < _pageSize) {
    //  _pagingController.appendLastPage(newItems);
    //} else {
    //  _pagingController.appendPage(newItems, pageKey + newItems.length);
    //}
    //} catch (error) {
    //  _pagingController.error = error;
    //}
  }

  @override
  void dispose() {
    //_pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'About Trade with Experts Indicator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 144, 235),
        iconTheme: const IconThemeData(color: Colors.white),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.withOpacity(0.05),
              Colors.white,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: indicatorDetails.length,
          itemBuilder: (context, index) {
            var item = indicatorDetails[index];
            return GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 33, 144, 235),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title']!,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['time']!,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['description']!,
                            style: const TextStyle(
                              fontSize: 15,
                              height: 1.5,
                              color: Color(0xFF444444),
                            ),
                          ),
                          if (item.containsKey('image')) ...[
                            const SizedBox(height: 16),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                height: 180,
                                width: double.infinity,
                                child: Image.asset(
                                  item['image']!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ],
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.calendar_today_outlined,
                                      size: 14,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      item['date']!,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ConfirmationToolsPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor:
                                      const Color.fromARGB(255, 33, 144, 235),
                                ),
                                child: const Row(
                                  children: [
                                    Text(
                                      'Learn more',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 4),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmationToolsPage(),
                  ),
                );
              },
            );
          },
        ),
      ),
      //Padding(
      //padding: const EdgeInsets.all(16.0),
      //child: //PagedListView<int, DocumentSnapshot>(
      //pagingController: _pagingController,
      //builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
      //itemBuilder: (context, item, index) {
      //final data = item.data() as Map<String, dynamic>;
      //return GestureDetector(
      //onTap: () {
      // Navigator.of(context).push(
      // PageRouteBuilder(
      // pageBuilder: (context, animation, secondaryAnimation) =>
      //  MoreDetails(data: data),
      //transitionsBuilder:
      //   (context, animation, secondaryAnimation, child) {
      // return FadeTransition(opacity: animation, child: child);
      //},
      //),
      //);
      //},
      //child: _buildAboutCard(data),
      //);
      //},
      //firstPageProgressIndicatorBuilder: (_) =>
      //    _buildShimmerPlaceholder(),
      //newPageProgressIndicatorBuilder: (_) =>
      //    Center(child: _buildWaveDotsLoader()),
      //noItemsFoundIndicatorBuilder: (_) => const Center(
      //  child: Text(
      //'No data available',
      //style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
    );

    // ),
    //),
    //),
    //);
  }

  Widget _buildAboutCard(Map<String, dynamic> data) {
    return Card(
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
                  data["title"] ?? 'Untitled',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Text(
                  data["time"] ?? 'Unknown Time',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color.fromARGB(255, 36, 35, 35),
                  ),
                ),
              ],
            ),
            const Divider(color: Colors.grey),
            const SizedBox(height: 8),
            Text(
              data["description"] ?? 'No description',
              style: const TextStyle(
                fontSize: 16,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
            const SizedBox(height: 8),
            if (data["image_url"] != null && data["image_url"].isNotEmpty)
              Center(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.network(
                      data["image_url"],
                      fit: BoxFit.cover,
                      height: 150,
                      width: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) {
                          return child;
                        }
                        return _buildWaveDotsLoader();
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error, color: Colors.red);
                      },
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            Text(
              data["date"] ?? 'Unknown Date',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.end,
            ),
          ],
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
          scaffoldBackgroundColor: const Color(0xFF1E1E2C),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShimmerPro.text(
                light: ShimmerProLight.lighter,
                scaffoldBackgroundColor: const Color(0xFF1E1E2C),
                width: 300,
                maxLine: 2,
              ),
              const SizedBox(height: 8),
              ShimmerPro.sized(
                light: ShimmerProLight.lighter,
                scaffoldBackgroundColor: const Color(0xFF1E1E2C),
                height: 200,
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
    return LoadingAnimationWidget.dotsTriangle(
      color: const Color.fromARGB(255, 0, 0, 0),
      size: 50,
    );
  }
}
