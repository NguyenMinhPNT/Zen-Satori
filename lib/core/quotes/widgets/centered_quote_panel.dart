import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';
import '../quote_entry.dart';

class CenteredQuotePanel extends StatelessWidget {
  const CenteredQuotePanel({super.key, required this.quote});

  final QuoteEntry? quote;

  @override
  Widget build(BuildContext context) {
    final colors = AppTheme.of(context);
    final quoteStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontStyle: FontStyle.italic,
      color: colors.inkSoft,
      height: 1.45,
      fontWeight: FontWeight.w400,
    );
    final authorStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: colors.ink.withValues(alpha: 0.78),
      height: 1.3,
      fontWeight: FontWeight.w500,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            child: quote == null
                ? const SizedBox.expand(key: ValueKey('quote-empty'))
                : Column(
                    key: ValueKey(quote!.id),
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '"${quote!.text}"',
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                        style: quoteStyle,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        quote!.author,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: authorStyle,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
