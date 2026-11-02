class Note {
  final int? id;
  final String title;
  final String content;
  final String category;
  final String createdAt;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.category,
    required this.createdAt,
  });

  // Konversi objek Note ke Map untuk disimpan ke SQLite / SQFlite
  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{
      'title': title,
      'content': content,
      'category': category,
      'created_at': createdAt,
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  // Konversi Map dari SQLite ke objek Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      category: map['category'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  // Membuat salinan objek dengan modifikasi nilai tertentu (Immutability pattern)
  Note copyWith({
    int? id,
    String? title,
    String? content,
    String? category,
    String? createdAt,
  }) {
    return Note(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
