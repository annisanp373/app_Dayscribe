import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dayscribe/screens/auth/register_screen.dart';
import 'package:dayscribe/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 241, 225, 254), // Warna latar belakang
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: const EdgeInsets.symmetric(horizontal: 30.0),
            decoration: BoxDecoration(
              color: Colors.white, // Warna kotak formulir
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Text(
                    'Login',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Please enter your email and password to login',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextFormField(
                    controller: email,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: password,
                    obscureText: true,
                    decoration: const InputDecoration(hintText: 'Password'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () {
                            if (formKey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                              });
                              startLogin();
                            }
                          },
                          child: const Text('Login'),
                        ),
                  const SizedBox(height: 15),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterScreen()),
                      );
                    },
                    child: const Text('Don\'t have an account? Register now'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  startLogin() async {
    try {
      await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }
}
