import 'package:capittalgrowth/Authentication/RegistrationScreen.dart';
import 'package:capittalgrowth/Constant/Link_Constant.dart';
import 'package:capittalgrowth/MainScreen/Dilogue_Screens/ProfileScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileOptionsDialog extends StatelessWidget {
  //final String username;
  //final String mobile;

  //const ProfileOptionsDialog({
  //Key? key,
  //required this.username,
  //required this.mobile,
  //}) : super(key: key);

  // Function to handle logout and navigate to RegistrationPage
  Future<void> _logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all user session data

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Function to show the logout confirmation dialog
  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(
                Icons.logout,
                color: Colors.red,
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                "Logout",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          content: Text(
            "Are you sure you want to log out?",
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Color(0xFF264653),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("Logout"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, -5),
            ),
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar at the top
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
            ),

            // Header with user info and profile icon
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor:
                      const Color.fromARGB(255, 33, 144, 235).withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    size: 30,
                    color: const Color.fromARGB(255, 33, 144, 235),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'username,',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF264653),
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'mobile',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                // Logout button
                IconButton(
                  onPressed: () => _showLogoutConfirmation(context),
                  icon: Icon(Icons.logout, color: Colors.red),
                  tooltip: "Logout",
                ),
              ],
            ),

            SizedBox(height: 24),

            // Section header
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: Text(
                'SETTINGS & PREFERENCES',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
            ),

            // List of profile options in a card
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.person,
                    title: 'My Profile',
                    subtitle: 'View and edit your personal information',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileScreen(
                              //username: username,
                              // mobile: mobile,
                              ),
                        ),
                      );
                    },
                  ),
                  Divider(height: 1, indent: 70),
                  _buildProfileOption(
                    icon: Icons.lock_outline,
                    title: 'Privacy Policy',
                    subtitle: 'How we handle your personal data',
                    onTap: () async {
                      /*
                      final url = Uri.parse(PrivacyPolicy);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      */
                      Text("hello");
                    },
                  ),
                  Divider(height: 1, indent: 70),
                  _buildProfileOption(
                    icon: Icons.attach_money_outlined,
                    title: 'Refund Policy',
                    subtitle: 'Terms and conditions for refunds',
                    onTap: () async {
                      /*
                      final url = Uri.parse(Refund_policy);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }*/

                      Text("hello");
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Additional information section
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
              child: Text(
                'ABOUT',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                  letterSpacing: 1.2,
                ),
              ),
            ),

            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  _buildProfileOption(
                    icon: Icons.business_outlined,
                    title: 'About Us',
                    subtitle: 'Learn more about our company',
                    onTap: () async {
                      /*
                      final url = Uri.parse(AboutUs_Link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      */

                      Text("hello");
                    },
                  ),
                  Divider(height: 1, indent: 70),
                  _buildProfileOption(
                    icon: Icons.info_outline,
                    title: 'Disclaimer',
                    subtitle: 'Important information about our services',
                    onTap: () async {
                      /*
                      final url = Uri.parse(Disclaimer_Link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                      */
                      Text("hello");
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20),

            // Log out button at the bottom
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutConfirmation(context),
                icon: Icon(Icons.logout),
                label: Text("Logout"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey[200],
                  foregroundColor: Colors.red,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to create profile option ListTile
  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: ListTile(
          leading: Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 33, 144, 235).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 33, 144, 235),
              size: 24,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Color(0xFF264653),
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.grey[400],
            size: 20,
          ),
        ),
      ),
    );
  }
}
