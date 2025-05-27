import 'package:flutter/material.dart';

class DailyUpdates extends StatefulWidget {
  const DailyUpdates({super.key});

  @override
  State<DailyUpdates> createState() => _DailyUpdatesState();
}

class _DailyUpdatesState extends State<DailyUpdates> {
  final List<Map<String, String>> updates = [
    {
      "title": "BANKNIFTY",
      "time": "09:05 AM",
      "description": "Resistance level: 52550\nSupport level: 52200/52000",
      "date": "28-11-2024"
    },
    {
      "title": "test",
      "time": "08:48 AM",
      "description": "banknifty",
      "date": "28-01-2025"
    },
    {
      "title": "BANKNIFTY",
      "time": "10:43 AM",
      "description": "52000 is strong support for Banknifty",
      "date": "26-11-2024"
    },
    {
      "title": "Happy Mahashivratri",
      "time": "04:26 PM",
      "description":
          "Wishing everyone a joyful and blessed Mahashivratri! 🕉️\nMay Lord Shiva shower you with wisdom, prosperity, and success in all your trading endeavors.",
      "date": "Mahashivratri Special"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Daily Market Updates',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 33, 144, 235),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: updates.length,
        itemBuilder: (context, index) {
          var item = updates[index];
          return Container(
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
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item['title']!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: const Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                          Text(
                            item['time']!,
                            style: TextStyle(
                              fontSize: 14,
                              color: const Color.fromARGB(255, 58, 58, 58),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item['description']!,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.5,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.blue.shade600,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item['date']!,
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color.fromARGB(255, 64, 64, 65),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
