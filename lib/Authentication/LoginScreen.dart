import 'dart:ui';
import 'package:capittalgrowth/MainScreen/DashboardScreen.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../ReusableWidget/Custom-Text_&_numberField.dart';
import 'RegistrationScreen.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /*
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool isPasswordVisible = false;

  // Function to hash the password
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Function to handle login request
  Future<void> _login() async {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();

    // Hash the entered password
    final String hashedPassword = hashPassword(password);

    setState(() {
      isLoading = true; // Show loading animation
    });

    try {
      // Query Firestore for user with matching mobile number
      final userRef = FirebaseFirestore.instance.collection('User');
      final userSnapshot =
          await userRef.where('mobile_no', isEqualTo: mobile).get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first.data();
        final String username = userDoc['username'];
        final String documentId = "$username+$mobile";

        if (userDoc['password'] == hashedPassword) {
          // Store username and mobile in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', username);
          await prefs.setString('mobile', mobile);

          // Navigate to DashboardScreen with username and mobile
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(username: username, mobile: mobile),
            ),
          );
        } else {
          CherryToast.error(
            title: const Text('Error'),
            displayIcon: true,
            description: const Text(
                'Invalid mobile number or password. Please try again.'),
            animationType: AnimationType.fromTop,
            autoDismiss: true,
          ).show(context);
        }
      } else {
        CherryToast.error(
          title: const Text('Error'),
          displayIcon: true,
          description: const Text(
              'Invalid mobile number or password. Please try again.'),
          animationType: AnimationType.fromTop,
          autoDismiss: true,
        ).show(context);
      }
    } catch (e) {
      CherryToast.error(
        title: const Text('Error'),
        displayIcon: true,
        description: Text('An error occurred: ${e.toString()}'),
        animationType: AnimationType.fromTop,
        autoDismiss: true,
      ).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  */
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  // Function to hash the password
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Function to handle login request
  Future<void> _login() async {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();

    // Hash the entered password
    final String hashedPassword = hashPassword(password);

    setState(() {
      isLoading = true; // Show loading animation
    });

    try {
      // Query Firestore for user with matching email
      final userRef = FirebaseFirestore.instance.collection('User');
      final userSnapshot = await userRef.where('email', isEqualTo: email).get();

      if (userSnapshot.docs.isNotEmpty) {
        final userDoc = userSnapshot.docs.first.data();
        final String username = userDoc['username'];

        if (userDoc['password'] == hashedPassword) {
          // Store username and email in SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('isLoggedIn', true);
          await prefs.setString('username', username);
          await prefs.setString('email', email);

          // Navigate to DashboardScreen with username and email
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  DashboardScreen(),
            ),
          );
        } else {
          // Show error message for invalid credentials
          CherryToast.error(
            title: const Text('Error'),
            displayIcon: true,
            description: const Text(
                'Invalid email or password. Please try again.'),
            animationType: AnimationType.fromTop,
            autoDismiss: true,
          ).show(context);
        }
      } else {
        // Show error message for user not found
        CherryToast.error(
          title: const Text('Error'),
          displayIcon: true,
          description: const Text(
              'No account found with this email. Please register first.'),
          animationType: AnimationType.fromTop,
          autoDismiss: true,
        ).show(context);
      }
    } catch (e) {
      // Show error message for unexpected errors
      CherryToast.error(
        title: const Text('Error'),
        displayIcon: true,
        description: Text('An error occurred: ${e.toString()}'),
        animationType: AnimationType.fromTop,
        autoDismiss: true,
      ).show(context);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontStyle: FontStyle.italic,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 33, 144, 235),
      ),
      body: Stack(
        children: [
          Container(
            height: 100,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 33, 144, 235),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 20.0),
            child: Center(
              child: Card(
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 33, 144, 235),
                          ),
                        ),
                        const SizedBox(height: 10),

                        const Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF757575),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Mobile field
                        CustomTextField(
                          label: 'Email',
                          obscureText: false,
                          inputType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        CustomTextField(
                          label: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                // isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),

                        // Forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // Handle forgot password
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Color.fromARGB(255, 33, 144, 235),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Login Button with improved styling
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DashboardScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color.fromARGB(255, 33, 144, 235),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 5,
                            ),
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Sign Up Link with improved styling
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => RegistrationScreen(),
                                ),
                                    (route) => false,
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: "Don't have an account? ",
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Sign Up',
                                    style: const TextStyle(
                                      color: Color.fromARGB(255, 33, 144, 235),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          /*
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5), // Blur effect
              child: Container(
                color: Colors.black.withOpacity(0.1), // Slightly dark background
                child: Center(
                  child: LoadingAnimationWidget.staggeredDotsWave(
                    color: Colors.black,
                    size: 40.0,
                  ),
                ),
              ),
            ),*/
        ],
      ),
    );
  }
}