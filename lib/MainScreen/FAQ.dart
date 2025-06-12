import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Faq extends StatefulWidget {
  const Faq({super.key});

  @override
  State<Faq> createState() => _FaqState();
}

class _FaqState extends State<Faq> {
  final List<Map<String, String>> faqData = [
    {
      "question": "Which time frames work best?",
      "answer": "The best time frames depend on your trading strategy."
    },
    {
      "question": "How do I install it?",
      "answer":
          "You can install it by downloading from the Play Store or App Store."
    },
    {
      "question": "Is a trial available?",
      "answer": "Yes, we offer a 3-day free trial."
    },
    {
      "question": "Does it work in all markets?",
      "answer": "Yes, it is compatible with all major financial markets."
    },
    {
      "question": "How are signals generated?",
      "answer": "Signals are generated based on AI and market analysis."
    },
    {
      "question": "What are the risks?",
      "answer": "Trading involves risks, and you should invest wisely."
    },
  ];
  //final CollectionReference _faqRef =
  //    FirebaseFirestore.instance.collection('FAQ');
  //final PagingController<int, DocumentSnapshot> _pagingController =
  //    PagingController(firstPageKey: 0);

  //static const int _pageSize = 5;

  @override
  void initState() {
    super.initState();
    //_pagingController.addPageRequestListener(_fetchPage);
  }

/*
  Future<void> _fetchPage(int pageKey) async {
    try {
      Query query = _faqRef.orderBy('date', descending: true);

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
  }
*/
  @override
  void dispose() {
    //_pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text(
          'Frequently Asked Questions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: const Color(0xFF2196F3),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            decoration: const BoxDecoration(
              color: Color(0xFF2196F3),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: const Text(
              'Find answers to the most common questions about our application',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: faqData.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
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
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          dividerColor: Colors.transparent,
                          colorScheme: ColorScheme.fromSwatch().copyWith(
                            secondary: const Color(0xFF2196F3),
                          ),
                        ),
                        child: ExpansionTile(
                          iconColor: const Color(0xFF2196F3),
                          collapsedIconColor: const Color(0xFF757575),
                          childrenPadding:
                              const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          expandedCrossAxisAlignment: CrossAxisAlignment.start,
                          title: Text(
                            faqData[index]["question"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF333333),
                            ),
                          ),
                          children: [
                            const Divider(height: 20, thickness: 1),
                            Text(
                              faqData[index]["answer"]!,
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF666666),
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      /*
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: PagedListView<int, DocumentSnapshot>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            itemBuilder: (context, item, index) {
              final data = item.data() as Map<String, dynamic>;
              return _buildFaqCard(data);
            },
            firstPageProgressIndicatorBuilder: (_) =>
                _buildShimmerPlaceholder(),
            newPageProgressIndicatorBuilder: (_) =>
                Center(child: _buildWaveDotsLoader()),
            noItemsFoundIndicatorBuilder: (_) => const Center(
              child: Text(
                'No FAQs available',
                style: TextStyle(color: Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
          ),
        ),
      ),
      */
    );
  }

  Widget _buildFaqCard(Map<String, dynamic> data) {
    final String question = data['question'] ?? 'No question available';
    final String answer = data['answer'] ?? 'No answer available';
    final String date = data['date'] ?? 'Unknown Date';
    final String time = data['time'] ?? 'Unknown Time';

    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ExpansionTile(
          collapsedIconColor: const Color(0xFF757575),
          iconColor: const Color(0xFF2196F3),
          title: Text(
            question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF333333),
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                answer,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF666666),
                  height: 1.5,
                ),
              ),
            ),
            const Divider(color: Color(0xFFEEEEEE)),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "$date, $time",
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xFF9E9E9E),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerPlaceholder() {
    return Column(
      children: List.generate(
        6,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: ShimmerPro.generated(
            light: ShimmerProLight.lighter,
            scaffoldBackgroundColor: const Color(0xFFF5F7FA),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerPro.text(
                    light: ShimmerProLight.lighter,
                    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
                    width: 250,
                    maxLine: 1,
                    borderRadius: 4,
                  ),
                  const SizedBox(height: 12),
                  ShimmerPro.text(
                    light: ShimmerProLight.lighter,
                    scaffoldBackgroundColor: const Color(0xFFF5F7FA),
                    width: 300,
                    maxLine: 2,
                    borderRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWaveDotsLoader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LoadingAnimationWidget.dotsTriangle(
        color: const Color(0xFF2196F3),
        size: 40,
      ),
    );
  }
}
