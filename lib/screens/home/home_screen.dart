import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/add_blog/add_blog_screen.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/blog.dart';
import 'package:myapp/screens/home/widgets/item_blog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                onTap: () async {
                  final auth = FirebaseAuth.instance;
                  await auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false);
                },
                child: const Text('Logout'),
              )
            ],
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('dayscribe')
              .where('userId', isEqualTo: user?.uid) // Only fetch notes for the current user
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.docs;
              List<Blog> blogs = [];
              for (var element in data) {
                Blog blog = Blog.fromMap(element.data());
                blogs.add(blog);
              }
              return ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  for (var blog in blogs) ItemBlog(blog: blog)
                ],
              );
            }
            return const SizedBox();
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const AddBlogScreen()));
        },
        child: const Icon(CupertinoIcons.plus),
      ),
    );
  }
}
