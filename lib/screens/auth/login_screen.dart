import 'package:firebase_auth/firebase_auth.dart';
//import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/auth/register_screen.dart';
import 'package:myapp/screens/home/home_screen.dart';

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
        body: Column(
      children: [
        Expanded(
          child: Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(15),
              children: [
                const SizedBox(height: 100),
                Text('Login', style: Theme.of(context).textTheme.displaySmall),
                const Text('Please enter your email and password to login'),
                const SizedBox(height: 30),
                TextFormField(
                    controller: email,
                    decoration: const InputDecoration(hintText: 'Email'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    }),
                const SizedBox(height: 15),
                TextFormField(
                  controller: password,
                  obscureText: true,
                  decoration: const InputDecoration(hintText: 'password'),
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
                      )
              ],
            ),
          ),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()));
          },
          child: const Text('Dont Have an account? REgister Now'),
        ),
        const SizedBox(
          height: 15,
        )
      ],
    ));
  }

  startLogin() async {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2249118975.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1825384386.
    try {
      await auth.signInWithEmailAndPassword(
          email: email.text, password: password.text);
      setState(() {
        loading = false;
      });
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }
}
