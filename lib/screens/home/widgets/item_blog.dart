import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dayscribe/models/blog.dart';
import 'package:dayscribe/screens/detail_blog/detail_blog.dart'; // Import layar detail
import 'package:dayscribe/screens/edit_blog/edit_blog_screen.dart';

class ItemBlog extends StatelessWidget {
  final Blog blog;
  final bool isSelected;
  final ValueChanged<bool?>? onChanged;
  final Color backgroundColor;
  final bool isDeleting;

  const ItemBlog({
    Key? key,
    required this.blog,
    this.isSelected = false,
    this.onChanged,
    required this.backgroundColor,
    this.isDeleting = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (isDeleting)
          Checkbox(
            value: isSelected,
            onChanged: onChanged,
          ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              // Navigasi ke layar detail blog saat item ditekan
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlogDetailScreen(blog: blog),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 30),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: backgroundColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          blog.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      if (blog.isPinned)
                        const Icon(Icons.push_pin, color: Colors.red),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    DateFormat('dd MMM yyyy hh:mm a').format(blog.createdAt),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    blog.desc,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditBlogScreen(blog: blog),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
