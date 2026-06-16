import 'dart:math';

import 'package:flutter/material.dart';

import 'quote_category.dart';
import 'quote_entry.dart';

abstract class QuoteRepository {
  Future<List<QuoteEntry>> getQuotes({QuoteCategory? category, Locale? locale});

  Future<QuoteEntry?> pickRandom({
    QuoteCategory? category,
    Locale? locale,
    Random? random,
  });
}
