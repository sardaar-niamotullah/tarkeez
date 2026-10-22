import 'package:flutter/material.dart';

class RichTextUtils {
  static List<TextSpan> buildStyledText({
    required String text,
    required TextStyle normalStyle,
    required TextStyle highlightedStyle,
  }) {
    final RegExp exp = RegExp(r'\{(.*?)\}');
    final List<TextSpan> spans = [];
    int start = 0;

    for (final match in exp.allMatches(text)) {
      if (match.start > start) {
        spans.add(
          TextSpan(
            text: text.substring(start, match.start),
            style: normalStyle,
          ),
        );
      }

      spans.add(TextSpan(text: match.group(1), style: highlightedStyle));

      start = match.end;
    }

    if (start < text.length) {
      spans.add(TextSpan(text: text.substring(start), style: normalStyle));
    }

    return spans;
  }
}
