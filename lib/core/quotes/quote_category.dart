enum QuoteCategory {
  focus('focus'),
  perseverance('perseverance'),
  mindfulness('mindfulness'),
  zen('zen'),
  courage('courage');

  const QuoteCategory(this.storageValue);

  final String storageValue;

  static QuoteCategory fromStorage(String value) {
    return QuoteCategory.values.firstWhere(
      (category) => category.storageValue == value,
      orElse: () =>
          throw ArgumentError.value(value, 'value', 'Unknown quote category'),
    );
  }
}
