import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'LoginScreen.dart';
import 'otp.dart';
import 'package:capittalgrowth/MainScreen/DashboardScreen.dart';

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
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    setState(() => isLoading = true);

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final phoneNumber = '+91${numberController.text.trim()}';

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await userCredential.user!.linkWithCredential(credential);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Phone number automatically verified.")),
          );
        },
        verificationFailed: (FirebaseAuthException e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Phone verification failed: ${e.message}")),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
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
      String message = switch (e.code) {
        'email-already-in-use' => "This email is already registered.",
        'weak-password' => "The password is too weak.",
        _ => "Registration failed: ${e.message}",
      };
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: ${e.toString()}")),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    // Show loading dialog early
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      GoogleSignInAccount? googleUser = await googleSignIn.signInSilently();
      googleUser ??= await googleSignIn.signIn();

      if (googleUser == null) {
        Navigator.pop(context); // Close the loading dialog
        return;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      if (!context.mounted) return; // Prevents exception if widget is disposed

      Navigator.pop(context); // Close the loading dialog
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => DashboardScreen()),
            (_) => false,
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Sign-in failed: $e"),
            backgroundColor: Colors.red,
          ),
        );
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
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        obscureText: isObscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: label,
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
        validator: (value) => value!.isEmpty ? 'Please enter your $label' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.white60],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
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
                    const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Fill the details below to register',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 20),
                    customTextField(controller: nameController, label: 'Name', keyboardType: TextInputType.name),
                    customTextField(controller: emailController, label: 'Email', keyboardType: TextInputType.emailAddress),
                    customTextField(controller: passwordController, label: 'Password', isObscure: true),
                    customTextField(controller: numberController, label: 'Phone Number', keyboardType: TextInputType.phone),
                    customTextField(controller: ageController, label: 'Age', keyboardType: TextInputType.number),
                    customTextField(controller: areaController, label: 'Area'),
                    customTextField(controller: pinController, label: 'PIN', keyboardType: TextInputType.number),
                    customTextField(controller: cityController, label: 'City'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: registerUser,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        elevation: 3,
                      ),
                      child: const Text('Register', style: TextStyle(fontSize: 18, color: Colors.white)),
                    ),
                    const SizedBox(height: 15),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => const LoginPage()),
                              (_) => false,
                        );
                      },
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(color: Colors.grey[700], fontSize: 16),
                          children: const [
                            TextSpan(
                              text: 'Log In',
                              style: TextStyle(
                                color: Color.fromARGB(255, 33, 144, 235),
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text("OR"),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      icon: Image.asset('assets/google_logo.png', height: 24, width: 24),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Sign in with Google', style: TextStyle(fontSize: 16, color: Colors.black87)),
                      ),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size.fromHeight(48),
                        side: BorderSide(color: Colors.grey.shade200),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        backgroundColor: Colors.white,
                      ),
                      onPressed: () => signInWithGoogle(context),
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
