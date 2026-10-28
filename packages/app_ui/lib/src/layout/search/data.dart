part of 'search_dialog.dart';

class IASearchItem<T> {
  final String key;
  final T data;
  final String label;

  IASearchItem({required this.data, required this.label, String? key})
    : key = key ?? label.toLowerCase();
}

class _SearchResult<T> {
  final IASearchItem<T> menuItem;
  final List<_SearchResultTextItem> segments;

  _SearchResult({required this.menuItem, required this.segments});
}

class _SearchResultTextItem {
  final String text;
  final bool isBold;

  _SearchResultTextItem(this.text, this.isBold);
}
