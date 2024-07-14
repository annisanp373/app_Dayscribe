import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/blog.dart';

class EditBlogScreen extends StatefulWidget {
  final Blog blog;

  const EditBlogScreen({required this.blog, Key? key}) : super(key: key);

  @override
  State<EditBlogScreen> createState() => _EditBlogScreenState();
}

class _EditBlogScreenState extends State<EditBlogScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;
  late bool isPinned;
  final formKey = GlobalKey<FormState>();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.blog.title);
    descriptionController = TextEditingController(text: widget.blog.desc);
    isPinned = widget.blog.isPinned;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 225, 254),
        title: const Text('Edit Blog'),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                editBlog();
              }
            },
            icon: const Icon(Icons.done),
          ),
        ],
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: formKey,
              child: ListView(
                padding: const EdgeInsets.all(15),
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: titleController,
                          decoration: const InputDecoration(hintText: 'Title'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your title';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      IconButton(
                        icon: Icon(
                          isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            isPinned = !isPinned;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  TextFormField(
                    controller: descriptionController,
                    maxLines: 10,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter your description';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
    );
  }

  editBlog() async {
    final db = FirebaseFirestore.instance.collection("dayscribe");
    Blog updatedBlog = Blog(
      id: widget.blog.id,
      userId: widget.blog.userId,
      title: titleController.text,
      desc: descriptionController.text,
      createdAt: widget.blog.createdAt,
      isPinned: isPinned,
    );

    try {
      await db.doc(widget.blog.id).update(updatedBlog.toMap());
      setState(() {
        loading = false;
      });
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }
}
