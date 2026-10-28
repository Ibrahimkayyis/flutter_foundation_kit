part of 'rich_text_field.dart';

class NTIRichTextDialog extends StatelessWidget {
  final NTIRichText value;
  final String? title;
  const NTIRichTextDialog({
    super.key,
    required this.value,
    required this.title,
  });

  static Future<void> asFullScreenDialog(
    BuildContext context,
    NTIRichText value, {
    String? title,
  }) {
    return showDialog(
      useSafeArea: false,
      useRootNavigator: false,
      context: context,
      builder: (_) => NTIRichTextDialog(title: title, value: value),
      barrierColor: Colors.transparent,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          title != null
              ? NTIAppBar(context: context, title: Text(title!))
              : null,
      body: Padding(
        padding: const EdgeInsets.all(18),
        child: NTIRichTextPreview(value: value),
      ),
    );
  }
}

class NTIRichTextPreview extends StatefulWidget {
  final NTIRichText value;
  const NTIRichTextPreview({super.key, required this.value});

  @override
  State<NTIRichTextPreview> createState() => _NTIRichTextPreviewState();
}

class _NTIRichTextPreviewState extends State<NTIRichTextPreview> {
  late quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController(
      document: quill.Document.fromJson(widget.value.json),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void didUpdateWidget(covariant NTIRichTextPreview oldWidget) {
    oldWidget.value != widget.value;
    _controller = quill.QuillController(
      readOnly: true,
      document: quill.Document.fromJson(widget.value.json),
      selection: const TextSelection.collapsed(offset: 0),
    );
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return quill.QuillEditor.basic(
      controller: _controller,
      config: quill.QuillEditorConfig(
        enableInteractiveSelection: false,
        autoFocus: false,
        embedBuilders: NTIRichTextEmbededBuilder.builder(),
      ),
    );
  }
}
