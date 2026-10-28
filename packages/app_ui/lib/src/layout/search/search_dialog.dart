import 'dart:async';

import 'package:flutter/material.dart';
import 'package:app_ui/src/ext/index.dart';
import 'package:app_ui/src/icon/nti_icon/icon.dart';
import 'package:app_ui/src/layout/error/error_widget.dart';
import 'package:app_ui/src/layout/loading/loading.dart';
import 'package:app_ui/src/layout/navigation/appbar.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:app_types/types.dart';

part 'data.dart';

class NTISearchDialog<T> extends StatefulWidget {
  final FutureOr<List<IASearchItem<T>>> Function(String key) items;
  final Widget Function(BuildContext context, Widget text, T item) itemBuilder;
  final EdgeInsets? padding;
  final String? hintText;
  final String? initialSearch;
  final BaseException Function(Object exception)? errorMessageBuilder;
  const NTISearchDialog({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.padding,
    this.hintText,
    this.initialSearch,
    this.errorMessageBuilder,
  });

  static Future<void> open<T>(
    BuildContext context, {
    required FutureOr<List<IASearchItem<T>>> Function(String key) items,
    EdgeInsets? padding,
    String? hintText,
    String? initialSearch,
    required Widget Function(BuildContext context, Widget text, T item)
    itemBuilder,
    String Function(Object exception)? errorMessageBuilder,
  }) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => NTISearchDialog(
              itemBuilder: itemBuilder,
              initialSearch: initialSearch,
              padding: padding,
              items: items,
              hintText: hintText,
            ),
      ),
    );
  }

  @override
  State<NTISearchDialog<T>> createState() => NTISearchDialogState();
}

class NTISearchDialogState<T> extends State<NTISearchDialog<T>> {
  final TextEditingController _textEditingController = TextEditingController();

  final _currentState = ValueNotifier<_SearchDialogState<T>>(
    _SearchDialogSuccess(data: []),
  );
  final _debouncer = Debouncer(milliseconds: 500);
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
      final initialSearch = widget.initialSearch;
      if (initialSearch != null) {
        _textEditingController.text =
            initialSearch.trim().isNotEmpty ? initialSearch : "";
        _onSearch(initialSearch);
      }
    });
  }

  void _onSearch(String text) async {
    if (text.isEmpty) {
      _currentState.value = _SearchDialogSuccess();
      return;
    }
    _currentState.value = _SearchDialogLoading();
    final loweredCaseText = text.toLowerCase();
    try {
      final searchResult = await widget.items(text);
      final highlitedResult =
          searchResult
              .where((element) => element.key.contains(loweredCaseText))
              .map((e) {
                final segemented = _getHighlightedSegments(
                  result: e.label,
                  searchTerm: loweredCaseText,
                );
                return _SearchResult(menuItem: e, segments: segemented);
              })
              .toList();
      _currentState.value = _SearchDialogSuccess(data: highlitedResult);
    } catch (e) {
      late BaseException? exception;
      exception = widget.errorMessageBuilder?.call(e);
      exception ??= e is BaseException ? e : BaseException(e.toString());
      _currentState.value = _SearchDialogError<T>(error: exception);
    }
  }

  List<_SearchResultTextItem> _getHighlightedSegments({
    required String result,
    required String searchTerm,
  }) {
    List<_SearchResultTextItem> segments = [];
    int start = 0;
    while (start < result.length) {
      final startIndex = result.toLowerCase().indexOf(searchTerm, start);
      if (startIndex == -1) {
        segments.add(_SearchResultTextItem(result.substring(start), false));
        break;
      } else {
        if (startIndex > start) {
          segments.add(
            _SearchResultTextItem(result.substring(start, startIndex), false),
          );
        }
        final endIndex = startIndex + searchTerm.length;
        segments.add(
          _SearchResultTextItem(result.substring(startIndex, endIndex), true),
        );
        start = endIndex;
      }
    }
    return segments;
  }

  @override
  void dispose() {
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final color = context.colorTheme;
    return Scaffold(
      appBar: NTIAppBar(
        context: context,
        title: TextField(
          focusNode: _focusNode,
          controller: _textEditingController,
          onChanged: (value) {
            _debouncer.run(() {
              _onSearch(value);
            });
          },
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: text.base
                .applyColor(color.basic7Reverse)
                .copyWith(height: 1),
          ),
        ),
        actions: [
          Padding(
            padding: 12.rightPadding,
            child: ValueListenableBuilder(
              valueListenable: _textEditingController,
              builder:
                  (_, value, __) => AppIcon(
                    value.text.isEmpty ? AppIcons.search : AppIcons.close,
                    color: color.basic10Reverse,
                    height: 24,
                  ),
            ),
          ),
        ],
      ),
      body: Container(
        color: color.basic1Reverse,
        width: double.infinity,
        padding: widget.padding ?? 48.horizontalPadding.copyWith(top: 12),
        child: ValueListenableBuilder(
          valueListenable: _currentState,
          builder:
              (context, value, child) => switch (value) {
                _SearchDialogSuccess() => _Success(
                  success: value,
                  itemBuilder: widget.itemBuilder,
                  searchText: _textEditingController.text,
                ),
                _SearchDialogError() => AppErrorWidget.fromException(
                  value.error,
                ),
                _SearchDialogLoading() => const NTICircularLoading(),
              },
        ),
      ),
    );
  }
}

class _Success<T> extends StatelessWidget {
  final _SearchDialogSuccess<T> success;
  final String searchText;
  final Widget Function(BuildContext context, Widget text, T item) itemBuilder;
  const _Success({
    required this.success,
    required this.itemBuilder,
    required this.searchText,
  });

  @override
  Widget build(BuildContext context) {
    final value = success.data;
    final text = context.text;
    final color = context.colorTheme;
    return value.isNotEmpty
        ? ListView.separated(
          shrinkWrap: true,
          padding: 24.verticalPadding,
          itemCount: value.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder:
              (context, index) => itemBuilder(
                context,
                _SearchResultItem(value[index]),
                value[index].menuItem.data,
              ),
        )
        : (searchText.isEmpty
            ? const SizedBox(height: 72)
            : Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 48),
                RichText(
                  text: TextSpan(
                    style: text.sm.applyColor(color.basic10Reverse),
                    children: [
                      const TextSpan(
                        text: "Tidak ada fitur dengan kata kunci ",
                      ),
                      TextSpan(text: searchText, style: text.sm.w700),
                    ],
                  ),
                ),
                const SizedBox(height: 48),
              ],
            ));
  }
}

class _SearchResultItem extends StatelessWidget {
  const _SearchResultItem(this.result);

  final _SearchResult result;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: DefaultTextStyle.of(context).style,
        children:
            result.segments.map((segment) {
              return TextSpan(
                text: segment.text,
                style: context.text.base.copyWith(
                  fontWeight:
                      segment.isBold ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
      ),
    );
  }
}

sealed class _SearchDialogState<T> {}

class _SearchDialogLoading<T> extends _SearchDialogState<T> {}

class _SearchDialogSuccess<T> extends _SearchDialogState<T> {
  final List<_SearchResult<T>> data;

  _SearchDialogSuccess({this.data = const []});
}

class _SearchDialogError<T> extends _SearchDialogState<T> {
  final BaseException error;

  _SearchDialogError({required this.error});
}

class Debouncer {
  final Duration duration;
  Timer? _timer;

  factory Debouncer.byDuration(Duration duration) {
    return Debouncer._(duration);
  }

  Debouncer._(this.duration);

  Debouncer({required int milliseconds})
    : duration = Duration(milliseconds: milliseconds);

  void run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(duration, action);
  }

  bool get isActive => _timer?.isActive ?? false;

  void dispose() {
    _timer?.cancel();
  }
}
