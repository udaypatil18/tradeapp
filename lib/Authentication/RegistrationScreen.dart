import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginScreen.dart';
import 'otp.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController pinController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  void registerUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);
      try {
        // Register user with email and password
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        String phoneNumber = '+91${numberController.text.trim()}';

        // Verify phone number
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60), // ⏱ set timeout limit
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Auto-verification
            await userCredential.user!.linkWithCredential(credential);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Phone number automatically verified.")),
            );
          },
          verificationFailed: (FirebaseAuthException e) {
            // Handle failure
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Phone verification failed: ${e.message}")),
            );
          },
          codeSent: (String verificationId, int? resendToken) {
            // Navigate to OTP screen
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  verificationId: verificationId,
                  user: userCredential.user!,
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Verification timed out.")),
            );
          },
        );
      } on FirebaseAuthException catch (e) {
        String message = "Registration failed: ${e.message}";
        if (e.code == 'email-already-in-use') {
          message = "This email is already registered.";
        } else if (e.code == 'weak-password') {
          message = "The password is too weak.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Unexpected error: ${e.toString()}")),
        );
      } finally {
        setState(() => isLoading = false);
      }
    }
  }


  Widget customTextField({
    required TextEditingController controller,
    required String label,
    bool isObscure = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        decoration:  InputDecoration(
            hintText: label,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding:
            const EdgeInsets.symmetric(vertical: 18, horizontal: 15),
            border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
            ),),
        validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white60],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 15,
                    offset: Offset(0, 5),
                  )
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Fill the details below to register',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    SizedBox(height: 20),
                    customTextField(controller: nameController, label: 'Name', keyboardType: TextInputType.name),
                    customTextField(controller: emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                    customTextField(controller: passwordController, label: 'Password', isObscure: true),
                    customTextField(controller: numberController, label: 'Phone Number', keyboardType: TextInputType.phone),
                    customTextField(controller: ageController, label: 'Age', keyboardType: TextInputType.number),
                    customTextField(controller: areaController, label: 'Area'),
                    customTextField(controller: pinController, label: 'PIN', keyboardType: TextInputType.number),
                    customTextField(controller: cityController, label: 'City'),
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: registerUser,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Text('Register', style: TextStyle(fontSize: 18,color: Colors.white)),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 4,
                        ),
                      ),
                    ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
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

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
