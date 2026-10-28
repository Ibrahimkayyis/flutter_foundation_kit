import 'dart:convert';
import 'dart:math';

import 'package:dart_quill_delta/dart_quill_delta.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_quill_delta_from_html/flutter_quill_delta_from_html.dart';
import 'package:flutter_quill_delta_from_html/parser/default_html_to_ops.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:app_types/app_types.dart';
import 'package:vsc_quill_delta_to_html/vsc_quill_delta_to_html.dart';

part 'html_operation.dart';

String _getPlainTextAsync(List<dynamic> json) {
  String? getStringItem(dynamic item) {
    final content = item["insert"];
    if (content is String) return content;
    final link = content["link"];
    if (link == null) return null;
    return link;
  }

  final StringBuffer descriptionBuffer = StringBuffer();

  for (final item in json) {
    final content = getStringItem(item);
    if (content != null) descriptionBuffer.write(content);
  }

  return descriptionBuffer.toString();
}

class AppRichText extends Equatable {
  final List<dynamic> json;
  final String description;

  static const checkListName = "o_checklist";

  AppRichText({required this.json})
    : description = _getDescription(json, maxDesc: 200);

  static String? _getStringItem(dynamic item) {
    final content = item["insert"];
    if (content is String) return content;
    final link = content["link"];
    if (link == null) return null;
    return link;
  }

  static String _getDescription(
    List<dynamic> json, {
    int maxDesc = 4294967296,
  }) {
    final StringBuffer descriptionBuffer = StringBuffer();

    for (final item in json) {
      final content = _getStringItem(item);
      if (content != null) {
        final text = content;
        for (int i = 0; i < text.length; i++) {
          final char = text[i];
          if (descriptionBuffer.length + 1 <= maxDesc) {
            if (char != '\n') {
              descriptionBuffer.write(char);
            }
          } else {
            break;
          }
        }
        descriptionBuffer.write(" ");
        if (descriptionBuffer.length >= maxDesc) {
          break;
        }
      }
      if (descriptionBuffer.length == maxDesc) break;
    }

    return descriptionBuffer.toString();
  }

  factory AppRichText.empty() {
    return AppRichText(
      json: const [
        {"insert": "\n"},
      ],
    );
  }

  factory AppRichText.fromHtml(
    String html, {
    String? baseUrl,
    Map<String, String>? headers,
  }) {
    final delta = HtmlToDelta(
      htmlToOperations: CustomHtmlOperation(baseUrl: baseUrl, headers: headers),
    ).convert(html, transformTableAsEmbed: true);
    return AppRichText(json: delta.toJson());
  }

  factory AppRichText.build(dynamic isi) {
    if (isi is List<dynamic>) {
      return AppRichText(json: isi);
    }
    if (isi == null || isi is! String) {
      return AppRichText(
        json: const [
          {"insert": "-\n"},
        ],
      );
    }
    try {
      final decodedIsi = jsonDecode(isi);
      return AppRichText(json: decodedIsi);
    } catch (e) {
      return AppRichText(
        json: [
          {"insert": "${isi.replaceAll("\n", "")}\n"},
        ],
      );
    }
  }

  @override
  List<Object?> get props => [json];

  String getDescription(int maxLength) =>
      description.substring(0, min(maxLength, description.length - 1));

  Future<String> getPlainText() async {
    final result = await compute(_getPlainTextAsync, json);
    return result;
  }

  String toHTMLString() {
    final converter = QuillDeltaToHtmlConverter(
      json
          .map((e) => e is Map<String, dynamic> ? e : <String, dynamic>{})
          .toList(),
    );
    converter.renderCustomWith = (customOp, contextOp) {
      switch (customOp.insert.type) {
        case AppImage.className:
          return AppRichTextCustomOp.renderImage(customOp);
        case 'table':
          return AppRichTextCustomOp.renderTable(customOp);
      }
      return "";
    };

    int checkListId = 1;
    converter.afterRender = (groupType, string) {
      if (groupType != GroupType.list) return null;
      final parsedHtml = parse(string);
      final ul = parsedHtml.querySelector('ul');
      ul?.classes.add('o_checklist');
      final liList = parsedHtml.querySelectorAll('li');
      for (var i = 0; i < liList.length; i++) {
        final li = liList[i];
        final text = li.text;
        final isChecked = li.attributes['data-checked'] == 'true';

        li.id = 'checklist-id-${checkListId + i + 1}';
        li.attributes.remove('data-checked');
        if (isChecked) {
          li.classes.add('o_checked');
        }
        li.children.clear();
        li.innerHtml = '';
        li.append(Element.tag('p')..text = text);
      }
      return parsedHtml.body?.innerHtml;
    };
    return converter.convert();
  }
}

class AppRichTextCustomOp {
  static String renderImage(DeltaInsertOp op) {
    final data = op.insert.value;

    final image = AppImage.tryFromJSON(jsonDecode(data));
    if (image == null) return "";
    switch (image) {
      case AppNetworkImage():
        return "<img src='${image.baseUrl.isNotEmpty ? "" : image.baseUrl}${image.path}' />";
      case AppMemoryImage():
        return "<img src='data:image/png;base64,${base64.encode(image.bytes)}' />";
      default:
        return "";
    }
  }

  static String renderTable(DeltaInsertOp op) {
    final data = op.insert.value;

    return data;
  }
}

typedef NTIRichText = AppRichText;
typedef NTIRichTextCustomOp = AppRichTextCustomOp;
