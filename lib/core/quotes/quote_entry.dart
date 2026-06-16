import 'package:equatable/equatable.dart';

import 'quote_category.dart';

class QuoteEntry extends Equatable {
  const QuoteEntry({
    required this.id,
    required this.text,
    required this.author,
    required this.category,
    this.tags = const <String>[],
  });

  final String id;
  final String text;
  final String author;
  final QuoteCategory category;
  final List<String> tags;

  factory QuoteEntry.fromJson(Map<String, dynamic> json) {
    return QuoteEntry(
      id: json['id'] as String,
      text: json['text'] as String,
      author: json['author'] as String,
      category: QuoteCategory.fromStorage(json['category'] as String),
      tags: (json['tags'] as List<dynamic>? ?? const <dynamic>[])
          .map((tag) => tag as String)
          .toList(growable: false),
    );
  }

  Map<String, Object> toJson() {
    return {
      'id': id,
      'text': text,
      'author': author,
      'category': category.storageValue,
      if (tags.isNotEmpty) 'tags': tags,
    };
  }

  @override
  List<Object> get props => [id, text, author, category, tags];
}
