import 'dart:convert';
import 'dart:ui';
import 'package:capittalgrowth/MainScreen/DashboardScreen.dart';
import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:crypto/crypto.dart'; // For password hashing
import 'package:intl/intl.dart'; // For formatting date and time
import 'package:loading_animation_widget/loading_animation_widget.dart'; // For staggered dots wave
import '../ReusableWidget/Custom-Text_&_numberField.dart';
import 'LoginScreen.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  /*
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isLoading = false; // To track loading state
  bool _showPassword = false; // For toggling password visibility
  bool _showConfirmPassword = false;

  // Password validation regex: At least 6 characters, including a number
  final passwordRegex = RegExp(r'^(?=.*[0-9])(?=.*[a-zA-Z]).{6,}$');

  // Function to hash the password
  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  // Function to handle registration and Firestore saving
  Future<void> _register() async {
    // Dismiss the keyboard
    FocusScope.of(context).unfocus();

    final String username = usernameController.text.trim();
    final String email = emailController.text.trim();
    final String mobile = mobileController.text.trim();
    final String password = passwordController.text.trim();
    final String confirmPassword = confirmPasswordController.text.trim();

    // Check if username and mobile are empty
    if (username.isEmpty) {
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('Username is required!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    if (mobile.isEmpty) {
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('Mobile number is required!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    // Check if password meets validation rules
    if (!passwordRegex.hasMatch(password)) {
      CherryToast.error(
        title: Text('Invalid Password'),
        displayIcon: true,
        description: Text(
            'Password must be at least 6 characters and contain a number.'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    // Check if passwords match
    if (password != confirmPassword) {
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('Passwords do not match!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    setState(() {
      isLoading = true; // Show loading indicator
    });

    // Check if username exists
    final usernameRef = FirebaseFirestore.instance.collection('User');
    final usernameQuery =
        await usernameRef.where('username', isEqualTo: username).get();

    if (usernameQuery.docs.isNotEmpty) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      // Show error if username already exists
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('Username already exists!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    // Check if mobile number already exists
    final mobileQuery =
        await usernameRef.where('mobile_no', isEqualTo: mobile).get();

    if (mobileQuery.docs.isNotEmpty) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('Mobile number already exists!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      return;
    }

    try {
      // Get current date and time
      final DateTime now = DateTime.now();
      final String formattedDate =
          DateFormat('dd-MM-yyyy').format(now); // DD-MM-YYYY format
      final String formattedTime =
          DateFormat('hh:mm a').format(now); // 12:00 AM/PM format

      // Saving user data to Firestore with hashed password, creation date and time
      await usernameRef.doc('$username+$mobile').set({
        "username": username,
        "email": email,
        "mobile_no": mobile,
        "password": hashPassword(password), // Store hashed password
        "created_date": formattedDate,
        "created_time": formattedTime,
      });

      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Show success toast
      CherryToast.success(
        title: Text('Success'),
        displayIcon: true,
        description: Text('Account created successfully!'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);

      // Navigate to LoginPage and clear all previous pages from the stack
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      setState(() {
        isLoading = false; // Hide loading indicator
      });

      // Show error toast on failure
      CherryToast.error(
        title: Text('Error'),
        displayIcon: true,
        description: Text('An error occurred. Please try again.'),
        animationType: AnimationType.fromTop,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
    }
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Register',
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
                          'Create Account',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 33, 144, 235),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Form Fields with improved styling - removed prefixIcon
                        CustomTextField(
                          label: 'Username',
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Email (Optional)',
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Mobile (10 digits)',
                          obscureText: false,
                          inputType: TextInputType.number,
                          maxLength: 10,
                        ),
                        const SizedBox(height: 15),

                        CustomTextField(
                          label: 'Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                //_showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 20),

                        CustomTextField(
                          label: 'Confirm Password',
                          suffixIcon: IconButton(
                            icon: Icon(
                              Icons.visibility,
                              color: Colors.grey[600],
                            ),
                            onPressed: () {
                              setState(() {
                                //_showConfirmPassword = !_showConfirmPassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Create Account Button with improved styling
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
                              'Create Account',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),

                        // Sign In Link with improved styling
                        Center(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                                (route) => false,
                              );
                            },
                            child: RichText(
                              text: TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 16,
                                ),
                                children: [
                                  TextSpan(
                                    text: 'Log In',
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
                color:
                    Colors.black.withOpacity(0.1), // Slightly dark background
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
