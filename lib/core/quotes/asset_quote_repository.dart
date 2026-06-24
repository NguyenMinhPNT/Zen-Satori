import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'quote_category.dart';
import 'quote_entry.dart';
import 'quote_repository.dart';

class AssetQuoteRepository implements QuoteRepository {
  AssetQuoteRepository({
    AssetBundle? assetBundle,
    Locale? defaultLocale,
    Random? random,
  }) : _assetBundle = assetBundle ?? rootBundle,
       _defaultLocale = defaultLocale ?? const Locale('en'),
       _random = random ?? Random();

  final AssetBundle _assetBundle;
  final Locale _defaultLocale;
  final Random _random;
  final Map<String, Future<List<QuoteEntry>>> _cache =
      <String, Future<List<QuoteEntry>>>{};

  @override
  Future<List<QuoteEntry>> getQuotes({
    QuoteCategory? category,
    Locale? locale,
  }) async {
    final resolvedLocale = locale ?? _defaultLocale;
    final allQuotes = await _loadQuotes(resolvedLocale);
    if (category == null) {
      return allQuotes;
    }
    return allQuotes
        .where((quote) => quote.category == category)
        .toList(growable: false);
  }

  @override
  Future<QuoteEntry?> pickRandom({
    QuoteCategory? category,
    Locale? locale,
    Random? random,
  }) async {
    final quotes = await getQuotes(category: category, locale: locale);
    if (quotes.isEmpty) {
      return null;
    }
    final picker = random ?? _random;
    return quotes[picker.nextInt(quotes.length)];
  }

  Future<List<QuoteEntry>> _loadQuotes(Locale locale) {
    return _cache.putIfAbsent(locale.languageCode, () async {
      final primaryPath = _pathFor(locale);
      try {
        return _decode(await _assetBundle.loadString(primaryPath));
      } catch (error, stackTrace) {
        debugPrint('Quote asset load failed for $primaryPath: $error');
        debugPrintStack(stackTrace: stackTrace);
        if (locale.languageCode != _defaultLocale.languageCode) {
          try {
            return await _loadQuotes(_defaultLocale);
          } catch (fallbackError, fallbackStackTrace) {
            debugPrint(
              'Quote asset fallback failed for ${_pathFor(_defaultLocale)}: '
              '$fallbackError',
            );
            debugPrintStack(stackTrace: fallbackStackTrace);
          }
        }
        return const <QuoteEntry>[];
      }
    });
  }

  List<QuoteEntry> _decode(String rawJson) {
    final decoded = jsonDecode(rawJson) as List<dynamic>;
    return decoded
        .map((entry) => QuoteEntry.fromJson(entry as Map<String, dynamic>))
        .toList(growable: false);
  }

  String _pathFor(Locale locale) {
    return 'assets/quotes/${locale.languageCode}/quotes.json';
  }
}
