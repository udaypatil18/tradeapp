import 'package:flutter/material.dart';
import 'package:shimmer_pro/shimmer_pro.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../ReusableWidget/PDFPreviewScreen.dart';

class TrainingMaterial extends StatefulWidget {
  const TrainingMaterial({super.key});

  @override
  State<TrainingMaterial> createState() => _TrainingMaterialState();
}

class _TrainingMaterialState extends State<TrainingMaterial> {
  final List<Map<String, String>> trainingMaterials = [
    {
      'title': 'Advanced Trading Strategies',
      'time': '02:30 PM',
      'date': '15-03-2024',
      'pdf_link': 'https://example.com/trading-strategies.pdf',
      'description':
          'Comprehensive guide to advanced trading techniques and market analysis.',
    },
    {
      'title': 'Market Analysis Techniques',
      'time': '11:45 AM',
      'date': '10-03-2024',
      'pdf_link': 'https://example.com/market-analysis.pdf',
      'description':
          'In-depth exploration of market analysis methods and indicators.',
    },
    {
      'title': 'Risk Management Guide',
      'time': '09:15 AM',
      'date': '05-03-2024',
      'pdf_link': 'https://example.com/risk-management.pdf',
      'description':
          'Essential strategies for managing risk in trading and investments.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Training Materials',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 144, 235),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trainingMaterials.length,
        itemBuilder: (context, index) {
          var item = trainingMaterials[index];
          return _buildMaterialCard(item);
        },
      ),
    );
  }

  Widget _buildMaterialCard(Map<String, String> item) {
    return GestureDetector(
      onTap: () => _openPdf(item['pdf_link']!, item['title']!),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // PDF Indicator
            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: const Center(
                child: Icon(
                  Icons.picture_as_pdf,
                  color: Colors.blue,
                  size: 80,
                ),
              ),
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Time
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item['time']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Description
                  Text(
                    item['description']!,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Date
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today,
                        size: 14,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        item['date']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
    );
  }

  void _openPdf(String pdfUrl, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PdfPreviewPage(pdfUrl: pdfUrl, title: title),
      ),
    );
  }
}
