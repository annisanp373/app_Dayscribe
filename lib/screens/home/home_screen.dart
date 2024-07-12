import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:myapp/screens/add_blog/add_blog_screen.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/blog.dart';
import 'package:myapp/screens/home/widgets/item_blog.dart';

// Make sure you have your LoginScreen defined somewhere
// For example:

// 'package:myapp/screens/home/home_screen.dart'
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
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
// Suggested code may be subject to a license. Learn more: ~LicenseLog:2303266102.
          stream:
              FirebaseFirestore.instance.collection('dayscribe').snapshots(),
// Suggested code may be subject to a license. Learn more: ~LicenseLog:199848937.
// Suggested code may be subject to a license. Learn more: ~LicenseLog:390301483.
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1737704100.
            if (snapshot.hasData && snapshot.data != null) {
              final data = snapshot.data!.docs;
              List<Blog> blogs = [];
              for (var element in data) {
                Blog blog = Blog.fromMap(element.data());
                blogs.add(blog);
              }
              return ListView(
                padding: const EdgeInsets.all(15) ,
                children: [
                  for (var blog in blogs)
                    ItemBlog(blog: blog)
                ],
              );
            }
            return SizedBox();
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
