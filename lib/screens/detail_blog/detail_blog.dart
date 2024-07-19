import 'package:flutter/material.dart';
import 'package:myapp/models/blog.dart';

class BlogDetailScreen extends StatelessWidget {
  final Blog blog;

  const BlogDetailScreen({Key? key, required this.blog}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 225, 254),
        title: Text('Detail Notes'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blog.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              blog.desc,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Created at: ${blog.createdAt}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            SizedBox(height: 10),
            Text(
              'Pinned: ${blog.isPinned ? "Yes" : "No"}',
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
