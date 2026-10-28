part of 'rich_text.dart';

class CustomHtmlOperation extends DefaultHtmlToOperations {
  final String? baseUrl;
  final Map<String, String>? headers;
  CustomHtmlOperation({this.baseUrl, this.headers}) : super(null);

  @override
  List<Operation> listToOp(dom.Element element, [int indentLevel = 0]) {
    final result = OdooCheckListOperator().operator(element, this, indentLevel);
    if (result != null) return result;
    return super.listToOp(element, indentLevel);
  }

  @override
  List<Operation> tableToOp(
    dom.Element element, [
    bool transformTableAsEmbed = false,
  ]) {
    final Delta delta = Delta();

    delta.insert({"table": element.outerHtml});
    return delta.toList();
  }

  @override
  List<Operation> imgToOp(dom.Element element) {
    final Delta delta = Delta();
    final source = element.getAttribute("src");
    if (source == null) return [];
    late AppImage image;
    if (source.startsWith("data:image")) {
      // This is a base64 image
      final base64String = source.split(',').last;

      // Convert to Uint8List
      final Uint8List bytes = base64Decode(base64String);

      image = AppMemoryImage(image: "image.png", bytes: bytes);
    } else {
      final hasAbsolutePath = Uri.tryParse(source)?.hasAbsolutePath ?? false;

      // This is a network image
      image = AppNetworkImage.build(
        source,
        baseUrl: hasAbsolutePath ? null : baseUrl,
        headers: headers,
      );
    }

    delta.insert({AppImage.className: jsonEncode(image.toJSON())});
    return delta.toList();
  }
}

class OdooCheckListOperator {
  List<Operation>? operator(
    dom.Element element,
    HtmlOperations htmlOperations, [
    int indentLevel = 0,
  ]) {
    if (element.localName != 'ul' && element.id != 'o_checklist') return null;
    final delta = Delta();

    final List<dom.Element> items =
        element.children
            .where(
              (child) =>
                  child.localName == 'li' &&
                  child.getAttribute("id")?.contains("checklist-id") == true,
            )
            .toList();
    for (final item in items) {
      int indent = indentLevel;
      final isChecked = item.getAttribute('class') == "o_checked";
      if (indentLevel > 5) indentLevel = 5;
      for (final node in item.nodes) {
        if (node.nodeType == dom.Node.TEXT_NODE) {
          delta.insert(node.text);
        } else if (node.nodeType == dom.Node.ELEMENT_NODE) {
          final element = node as dom.Element;
          List<Operation> ops = [];
          ops.addAll(htmlOperations.resolveCurrentElement(element, indent));
          for (final op in ops) {
            delta.insert(op.data, op.attributes);
          }
        }
      }
      delta.insert('\n', {'list': isChecked ? 'checked' : 'unchecked'});
    }
    return delta.toList();
  }
}
