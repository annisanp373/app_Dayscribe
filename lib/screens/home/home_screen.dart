import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myapp/models/blog.dart';
import 'package:myapp/screens/add_blog/add_blog_screen.dart';
import 'package:myapp/screens/auth/login_screen.dart';
import 'package:myapp/screens/home/widgets/item_blog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<Blog> _blogs = [];
  late List<Color> _blogColors = [];
  late List<Blog> _filteredBlogs = [];
  final _random = Random();
  TextEditingController _searchController = TextEditingController();
  bool _isDeleting = false;
  List<String> _selectedBlogIds = [];
  bool _isSearchExpanded = false;

  @override
  void initState() {
    super.initState();
    _fetchBlogs();
  }

  void _fetchBlogs() {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection('dayscribe')
        .where('userId', isEqualTo: user?.uid)
        .snapshots()
        .listen((querySnapshot) {
      List<Blog> fetchedBlogs = [];
      List<Color> blogColors = [];
      for (var doc in querySnapshot.docs) {
        Blog blog = Blog.fromMap(doc.data() as Map<String, dynamic>);
        blog.id = doc.id; // Ensure the blog's ID is set
        fetchedBlogs.add(blog);
        blogColors.add(_getRandomColor());
      }
      fetchedBlogs.sort((a, b) {
        if (a.isPinned && !b.isPinned) return -1;
        if (!a.isPinned && b.isPinned) return 1;
        return b.createdAt.compareTo(a.createdAt);
      });
      setState(() {
        _blogs = fetchedBlogs;
        _filteredBlogs = _blogs;
        _blogColors = blogColors;
      });
    }).onError((error) {
      print("Failed to fetch blogs: $error");
    });
  }

  Color _getRandomColor() {
    return Color.fromARGB(
      255,
      _random.nextInt(256),
      _random.nextInt(256),
      _random.nextInt(256),
    ).withOpacity(0.2);
  }

  void _filterBlogs(String query) {
    List<Blog> filteredBlogs = _blogs.where((blog) {
      final titleLower = blog.title.toLowerCase();
      final descLower = blog.desc.toLowerCase();
      final queryLower = query.toLowerCase();

      return titleLower.contains(queryLower) || descLower.contains(queryLower);
    }).toList();

    setState(() {
      _filteredBlogs = filteredBlogs;
    });
  }

  void _deleteSelectedBlogs() {
    final batch = FirebaseFirestore.instance.batch();
    for (var blogId in _selectedBlogIds) {
      final docRef =
          FirebaseFirestore.instance.collection('dayscribe').doc(blogId);
      batch.delete(docRef);
    }
    batch.commit().then((_) {
      print("Note successfully deleted");
      setState(() {
        _blogs.removeWhere((blog) => _selectedBlogIds.contains(blog.id));
        _filteredBlogs
            .removeWhere((blog) => _selectedBlogIds.contains(blog.id));
        _selectedBlogIds.clear();
        _isDeleting = false; // Reset delete mode
      });
    }).catchError((error) {
      print("Failed to delete note: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 225, 254),
        title: Row(
          children: [
            const SizedBox(width: 20), // Tambahkan padding di sini
            const Text(
              'DayScribe',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: AnimatedCrossFade(
                firstChild: SizedBox.shrink(),
                secondChild: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Search",
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      _filterBlogs(value);
                    },
                  ),
                ),
                crossFadeState: _isSearchExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                setState(() {
                  _isSearchExpanded = !_isSearchExpanded;
                  if (!_isSearchExpanded) {
                    _filterBlogs(_searchController.text);
                  }
                });
              },
            ),
            if (_isDeleting)
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  if (_selectedBlogIds.isNotEmpty) {
                    _deleteSelectedBlogs();
                  }
                },
              ),
            IconButton(
              icon: Icon(_isDeleting ? Icons.cancel : Icons.delete),
              onPressed: () {
                setState(() {
                  _isDeleting = !_isDeleting;
                  if (!_isDeleting) {
                    _selectedBlogIds.clear();
                  }
                });
              },
            ),
            PopupMenuButton(
              itemBuilder: (context) => [
                PopupMenuItem(
                  onTap: () async {
                    final auth = FirebaseAuth.instance;
                    await auth.signOut();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                      (route) => false,
                    );
                  },
                  child: const Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _filteredBlogs.isEmpty
          ? const Center(child: Text('How was your day?'))
          : ListView.builder(
              padding: const EdgeInsets.all(15),
              itemCount: _filteredBlogs.length,
              itemBuilder: (context, index) {
                final blog = _filteredBlogs[index];
                final color = _blogColors[index % _blogColors.length];
                return ItemBlog(
                  key: Key(blog.id), // Ensure key is set to blog.id
                  blog: blog,
                  isSelected: _selectedBlogIds.contains(blog.id),
                  onChanged: (isSelected) {
                    setState(() {
                      if (isSelected!) {
                        _selectedBlogIds.add(blog.id);
                      } else {
                        _selectedBlogIds.remove(blog.id);
                      }
                      print('Selected blogs: $_selectedBlogIds');
                    });
                  },
                  backgroundColor: color,
                  isDeleting: _isDeleting,
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddBlogScreen()),
          );
          if (result == true) {
            _fetchBlogs(); // Panggil ulang _fetchBlogs jika hasilnya true
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
