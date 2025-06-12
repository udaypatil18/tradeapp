import 'package:capittalgrowth/MainScreen/daily_updates.dart';
import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ReusableWidget/Profile_dialog.dart';

import 'BuyProduct.dart';
import 'FAQ.dart';
import 'HelpDesk.dart';
import 'Daily_Performance.dart';
import 'Training_Material.dart';
import 'Training_Session.dart';
import 'Watch_Videos.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chatbotscreen.dart';


class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {

  void callAdmin(String phoneNumber) async {
    final Uri callUri = Uri(scheme: 'tel', path: phoneNumber);
    print('Attempting to call $phoneNumber');

    if (await canLaunchUrl(callUri)) {
      print('Launching $callUri');
      await launchUrl(callUri);
    } else {
      print('Could not launch $callUri');
      throw 'Could not launch $callUri';
    }
  }


  AppUpdateInfo? _updateInfo;
  bool hasValidSubscription = false;
  bool isLoading = true;
  final Color primaryColor = const Color.fromARGB(255, 33, 144, 235);
  final Color backgroundColor = Colors.white;
  final Color cardColor = const Color.fromARGB(255, 245, 247, 250);

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadSubscriptionStatus();
    _checkForUpdate();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _checkForUpdate() async {
    try {
      _updateInfo = await InAppUpdate.checkForUpdate();
      if (_updateInfo?.updateAvailability ==
          UpdateAvailability.updateAvailable) {
        await InAppUpdate.performImmediateUpdate();
      }
    } catch (e) {
      print('Error checking for update: $e');
    }
  }

  Future<void> _loadSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      hasValidSubscription = prefs.getBool("hasValidSubscription") ?? false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: isLoading
          ? Center(
        child: CircularProgressIndicator(
          color: primaryColor,
        ),
      )
          : FadeTransition(
        opacity: _fadeAnimation,
        child: CustomScrollView(
          slivers: [
            _buildAppBar(),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    if (!hasValidSubscription) _buildSubscriptionBanner(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            _buildGridView(),
          ],
        ),
      ),
      // Add the Floating Action Button for the chatbot
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the Chatbot Screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatBotScreen()),
          );
        },
        backgroundColor: primaryColor,
        child: const Icon(Icons.chat_bubble_outline, color: Colors.white),
      ),
    );
  }
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 137,
      floating: false,
      pinned: true,
      backgroundColor: primaryColor,
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(30),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Background pattern

            // Content
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Text(
                                'Welcome back,',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white70,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.waving_hand,
                                color: Colors.amber,
                                size: 16,
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'User',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _showProfileOptions(context),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: const Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
        titlePadding: const EdgeInsets.all(0),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined, color: Colors.white),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        if (!hasValidSubscription)
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BuyProduct(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
              foregroundColor: Colors.black87,
              elevation: 2,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            icon: const Icon(Icons.star, size: 18),
            label: const Text(
              'Upgrade',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
      ],
    );
  }

  Widget _buildSubscriptionBanner() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [primaryColor.withOpacity(0.8), primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lock_open_rounded,
              color: primaryColor,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Unlock Premium Features',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Get access to training sessions, premium indicators, and more!',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildGridView() {
    final dashboardItems = [
      _createDashboardItem(
        title: 'Daily Performance',
        icon: Icons.pie_chart_rounded,
        color: Colors.green,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyPerformance()),
          );
        },
      ),
      _createDashboardItem(
        title: 'Daily\nUpdate',
        icon: Icons.insights_rounded,
        color: primaryColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailyUpdates()),
          );
        },
      ),
      // _createDashboardItem(
      //   title: 'About TwE\nIndicator',
      //   icon: Icons.info_outline_rounded,
      //   color: Colors.orangeAccent,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => AboutIndicator()),
      //     );
      //   },
      // ),
      _createDashboardItem(
        title: 'Watch\nVideos',
        icon: Icons.play_circle_fill_rounded,
        color: Colors.red.shade400,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WatchVideos()),
          );
        },
      ),
      _createDashboardItem(
        title: 'Buy\nProducts',
        icon: Icons.shopping_cart_rounded,
        color: Colors.purple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BuyProduct(),
            ),
          );
        },
      ),
      _createDashboardItem(
        title: 'Training\nSession',
        icon: Icons.video_camera_front_rounded,
        color: Colors.green.shade600,
        onTap: () {
          if (hasValidSubscription) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TrainingSession()),
            );
          } else {
            _showLockMessage(context);
          }
        },
        isLocked: !hasValidSubscription,
      ),
      // _createDashboardItem(
      //   title: 'Chart\nPatterns',
      //   icon: Icons.auto_graph_rounded,
      //   color: Colors.amber.shade600,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => CandlesPattern()),
      //     );
      //   },
      // ),
      _createDashboardItem(
        title: 'Training\nMaterial',
        icon: Icons.menu_book_rounded,
        color: primaryColor,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrainingMaterial()),
          );
        },
      ),
      _createDashboardItem(
        title: 'Help\nDesk',
        icon: Icons.support_agent_rounded,
        color: Colors.teal,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Helpdesk()),
          );
        },
      ),
      _createDashboardItem(
        title: 'FAQ',
        icon: Icons.question_answer_rounded,
        color: Colors.indigo,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Faq()),
          );
        },
      ),
      _createDashboardItem(
        title: 'Contact Us:',
        icon: Icons.phone,
        color: Colors.green,
        onTap: () => callAdmin('8309569385'), // Initiates a call directly
      ),




    ];

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 1.05,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _buildEnhancedDashboardCard(dashboardItems[index], index);
          },
          childCount: dashboardItems.length,
        ),
      ),
    );
  }

  DashboardItem _createDashboardItem({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return DashboardItem(
      title: title,
      icon: icon,
      color: color,
      onTap: onTap,
      isLocked: isLocked,
    );
  }

  Widget _buildEnhancedDashboardCard(DashboardItem item, int index) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final double delay = index * 0.1;
        final Animation<double> delayedAnimation = CurvedAnimation(
          parent: _animationController,
          curve: Interval(
            delay < 0.9 ? delay : 0.9,
            1.0,
            curve: Curves.easeOut,
          ),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - delayedAnimation.value)),
          child: Opacity(
            opacity: delayedAnimation.value,
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: item.onTap,
                  child: Stack(
                    children: [
                      Positioned(
                        right: -15,
                        top: -15,
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: item.color.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: item.color.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(
                                item.icon,
                                size: 28,
                                color: item.color,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (!item.isLocked)
                                  Container(
                                    height: 4,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: item.color.withOpacity(0.4),
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      if (item.isLocked)
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.lock_rounded,
                                    color: Colors.white,
                                    size: 28,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.amber,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
                                    'Premium',
                                    style: TextStyle(
                                      color: Colors.black87,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProfileOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.0)),
          ),
          padding: const EdgeInsets.only(top: 12),
          child: ProfileOptionsDialog(),
        );
      },
    );
  }

  void _showLockMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade400.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lock, color: Colors.red.shade400),
              ),
              const SizedBox(width: 12),
              const Flexible(
                child: Text(
                  'Premium Feature',
                  style: TextStyle(fontSize: 18),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'This feature is only available to premium users.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.amber.withOpacity(0.5)),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.star,
                      color: Colors.amber.shade600,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    const Flexible(
                      child: Text(
                        'Upgrade your plan to access all training sessions and premium content.',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BuyProduct(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                elevation: 2,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Upgrade Now'),
            ),
          ],
        );
      },
    );
  }
}


class DashboardItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;

  DashboardItem({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isLocked = false,
  });
}
