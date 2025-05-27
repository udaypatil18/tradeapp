import 'package:flutter/material.dart';

class SubscriptionOption extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final bool isMain;

  const SubscriptionOption({
    required this.title,
    required this.price,
    required this.description,
    required this.isMain,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: isMain
          ? const Color.fromARGB(255, 33, 144, 235)
          : const Color.fromARGB(255, 229, 229, 230),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: TextStyle(
                  color: isMain ? Colors.white : Colors.green,
                  fontSize: 15,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
