import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/blog.dart';

class AddBlogScreen extends StatefulWidget {
  const AddBlogScreen({super.key});

  @override
  State<AddBlogScreen> createState() => _AddBlogScreenState();
}

class _AddBlogScreenState extends State<AddBlogScreen> {
  final title = TextEditingController();
  final description = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool loading = false;
  bool isPinned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 225, 254),
        title: const Text('Add Notes'),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });
                addBlog();
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
                          controller: title,
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
                    controller: description,
                    maxLines: 10,
                    decoration: const InputDecoration(
                        hintText: 'Description', border: OutlineInputBorder()),
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

  addBlog() async {
    final user = FirebaseAuth.instance.currentUser;
    final db = FirebaseFirestore.instance.collection("dayscribe");
    Blog newBlog = Blog(
      id: db.doc().id,
      userId: user!.uid,
      title: title.text,
      desc: description.text,
      createdAt: DateTime.now(),
      isPinned: isPinned,
    );
    try {
      await db.doc(newBlog.id).set(newBlog.toMap());
      setState(() {
        loading = false;
      });
      Navigator.pop(context, true);
    } on FirebaseException catch (e) {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? '')));
    }
  }
}
