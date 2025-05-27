// pattern_detail_page.dart
import 'package:flutter/material.dart';

class MoreDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  const MoreDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 33, 144, 235),
          iconTheme: const IconThemeData(color: Colors.white)),
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data["title"] ?? '',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: data["image_url"] != null && data["image_url"] != ''
                    ? Image.network(data["image_url"],
                        height: 250, fit: BoxFit.cover)
                    : Image.asset('assets/placeholder.png',
                        height: 250, fit: BoxFit.cover),
              ),
              const SizedBox(height: 16),
              Text(
                data["description"] ?? '',
                style: const TextStyle(
                  fontSize: 16,
                  color: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
