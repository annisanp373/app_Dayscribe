class Blog {
  String id, userId, title, desc;
  DateTime createdAt;
  bool isPinned;

  Blog({
    required this.id,
    required this.userId,
    required this.title,
    required this.desc,
    required this.createdAt,
    this.isPinned = false,
  });

  factory Blog.fromMap(map) {
    return Blog(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      desc: map['desc'],
      createdAt: DateTime.parse(map['createdAt']),
      isPinned: map['isPinned'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'desc': desc,
      'createdAt': createdAt.toString(),
      'isPinned': isPinned,
    };
  }
}
