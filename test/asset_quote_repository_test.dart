import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zen_satori/core/quotes/asset_quote_repository.dart';
import 'package:zen_satori/core/quotes/quote_category.dart';

void main() {
  test('AssetQuoteRepository parses quote JSON', () async {
    final repository = AssetQuoteRepository(
      assetBundle: _MapAssetBundle({
        'assets/quotes/en/quotes.json': '''
[
  {"id":"focus-001","category":"focus","text":"Stay with the work.","author":"Anonymous"}
]
''',
      }),
    );

    final quotes = await repository.getQuotes();

    expect(quotes, hasLength(1));
    expect(quotes.single.id, 'focus-001');
    expect(quotes.single.category, QuoteCategory.focus);
    expect(quotes.single.author, 'Anonymous');
  });

  test('AssetQuoteRepository loads locale-specific assets', () async {
    final repository = AssetQuoteRepository(
      assetBundle: _MapAssetBundle({
        'assets/quotes/en/quotes.json': '''
[
  {"id":"focus-001","category":"focus","text":"Stay with the work.","author":"English Author"}
]
''',
        'assets/quotes/vi/quotes.json': '''
[
  {"id":"focus-001","category":"focus","text":"Hay tap trung.","author":"Tac gia Viet"}
]
''',
      }),
    );

    final quotes = await repository.getQuotes(locale: const Locale('vi'));

    expect(quotes.single.text, 'Hay tap trung.');
    expect(quotes.single.author, 'Tac gia Viet');
  });

  test('AssetQuoteRepository filters by category', () async {
    final repository = AssetQuoteRepository(
      assetBundle: _MapAssetBundle({
        'assets/quotes/en/quotes.json': '''
[
  {"id":"focus-001","category":"focus","text":"Stay with the work.","author":"Author A"},
  {"id":"courage-001","category":"courage","text":"Begin anyway.","author":"Author B"}
]
''',
      }),
    );

    final quotes = await repository.getQuotes(category: QuoteCategory.focus);

    expect(quotes, hasLength(1));
    expect(quotes.single.category, QuoteCategory.focus);
  });

  test('AssetQuoteRepository picks a random quote from the filtered pool', () async {
    final repository = AssetQuoteRepository(
      assetBundle: _MapAssetBundle({
        'assets/quotes/en/quotes.json': '''
[
  {"id":"focus-001","category":"focus","text":"Stay with the work.","author":"Author A"},
  {"id":"focus-002","category":"focus","text":"Keep your attention here.","author":"Author B"},
  {"id":"courage-001","category":"courage","text":"Begin anyway.","author":"Author C"}
]
''',
      }),
    );

    final quote = await repository.pickRandom(
      category: QuoteCategory.focus,
      random: _FixedRandom(1),
    );

    expect(quote, isNotNull);
    expect(quote!.id, 'focus-002');
    expect(quote.category, QuoteCategory.focus);
  });
}

class _MapAssetBundle extends CachingAssetBundle {
  _MapAssetBundle(this.assets);

  final Map<String, String> assets;

  @override
  Future<ByteData> load(String key) async {
    final value = assets[key];
    if (value == null) {
      throw FlutterError('Unable to load asset: $key');
    }
    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.sublistView(bytes);
  }
}

class _FixedRandom implements Random {
  const _FixedRandom(this.value);

  final int value;

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  double nextDouble() => throw UnimplementedError();

  @override
  int nextInt(int max) => value % max;
}
