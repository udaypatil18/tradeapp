import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:loading_animation_widget/loading_animation_widget.dart';

class BuyProduct extends StatefulWidget {
  @override
  _BuyProductState createState() => _BuyProductState();
}

class _BuyProductState extends State<BuyProduct> {
  final List<Map<String, dynamic>> plans = [
    {
      "title": "1-Months Plan",
      "price": "₹ 3000 +18% gst",
      "desc": "Perfect!",
      "features": [
        "Basic Trading Insights",
        "Limited Market Analysis",
        "Email Support"
      ],
      "recommended": false
    },
    {
      "title": "3-Months Plan",
      "price": "₹ 8000 +18% gst",
      "desc": "Best value!",
      "features": [
        "Advanced Trading Tools",
        "Comprehensive Market Analysis",
        "Priority Email Support",
        "Weekly Market Reports"
      ],
      "recommended": true
    },
    {
      "title": "6-Months Plan",
      "price": "₹ 14,999 +18% gst",
      "desc": "Most popular plan!",
      "features": [
        "Premium Trading Insights",
        "Full Market Analysis",
        "24/7 Priority Support",
        "Daily Market Reports",
        "Personal Trading Consultant"
      ],
      "recommended": false
    },
    {
      "title": "1-Year Plan",
      "price": "₹ 24,999 +18% gst",
      "desc": "Unlimited access!",
      "features": [
        "Unlimited Trading Tools",
        "Complete Market Analysis",
        "Lifetime Premium Support",
        "Exclusive Webinars",
        "Personal Trading Strategist"
      ],
      "recommended": false
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Upgrade to Premium',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Center(
                child: Image.asset(
                  'assets/BasicImage/Men_Trading.png',
                  height: 150,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Upgrade to Premium",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Unlock Unlimited Trading Potential",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: plans.length,
                  itemBuilder: (context, index) {
                    var plan = plans[index];
                    return PlanCard(
                      title: plan['title'] as String,
                      price: plan['price'] as String,
                      description: plan['desc'] as String,
                      features: plan['features'] as List<String>,
                      recommended: plan['recommended'] as bool? ?? false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final bool recommended;

  const PlanCard({
    Key? key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    this.recommended = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
        border: recommended
            ? Border.all(
                color: const Color.fromARGB(255, 33, 144, 235), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 33, 144, 235),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Body
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Price
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                // Features
                ...features
                    .map<Widget>((feature) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: const Color.fromARGB(255, 33, 144, 235),
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  feature,
                                  style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),

                const SizedBox(height: 16),

                // Select Plan Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Implement plan selection logic
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 33, 144, 235),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                      ),
                      child: const Row(
                        children: [
                          Text(
                            'Select Plan',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            Icons.arrow_forward,
                            size: 18,
                            color: Colors.white,
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
    );
  }
}
