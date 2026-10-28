import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:app_ui/src/style/color/color_theme.dart';

class EmbededTable extends CustomBlockEmbed {
  final String table;

  EmbededTable(this.table) : super(table, table);
}

class EmbededTableBuilder extends EmbedBuilder {
  @override
  String get key => "table";

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final data = embedContext.node.value.data;

    if (data == null || data is! String) return const SizedBox();

    final document = html_parser.parse(data);
    final tableElement = document.querySelector('table');
    if (tableElement == null) return const SizedBox();

    final trElements = tableElement.querySelectorAll('tr');
    final rows = <TableRow>[];

    for (final tr in trElements) {
      final cells = <Widget>[];
      final thElements = tr.children.where((e) => e.localName == 'th' || e.localName == 'td');
      for (final cell in thElements) {
        final isHeader = cell.localName == 'th';
        cells.add(
          Container(
            padding: const EdgeInsets.all(6),
            child: Text(
              cell.text.trim(),
              style: TextStyle(
                fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }
      if (cells.isNotEmpty) {
        rows.add(TableRow(children: cells));
      }
    }

    if (rows.isEmpty) return const SizedBox();

    return Scrollbar(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Table(
          border: TableBorder.all(
            color: context.colorTheme.basic5Reverse,
            width: .5,
          ),
          defaultColumnWidth: const IntrinsicColumnWidth(),
          children: rows,
        ),
      ),
    );
  }
}
