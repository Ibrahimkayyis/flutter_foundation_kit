part of 'rich_text_field.dart';

class NTIRichTextView extends StatefulWidget {
  final NTIRichText richText;
  final NTIRichTextStyle? customStyle;
  final bool absorb;
  const NTIRichTextView({
    super.key,
    required this.richText,
    this.customStyle,
    this.absorb = true,
  });

  @override
  State<NTIRichTextView> createState() => _NTIRichTextViewState();
}

class _NTIRichTextViewState extends State<NTIRichTextView> {
  late final quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController(
      readOnly: true,
      document: quill.Document.fromJson(widget.richText.json),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  void didUpdateWidget(covariant NTIRichTextView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.richText.json == widget.richText.json) return;
    _controller.document = quill.Document.fromJson(widget.richText.json);
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: widget.absorb,
      child: quill.QuillEditor.basic(
        controller: _controller,
        config: quill.QuillEditorConfig(
          enableInteractiveSelection: false,
          padding: EdgeInsets.zero,
          maxContentWidth: null,
          autoFocus: false,
          onLaunchUrl: (value) {
            launchUrl(Uri.parse(value), mode: LaunchMode.externalApplication);
          },
          customStyles:
              widget.customStyle?._asDefaultStyle() ??
              quill.DefaultStyles(
                paragraph: quill.DefaultTextBlockStyle(
                  context.text.base.copyWith(color: context.colorTheme.basic10),
                  const quill.HorizontalSpacing(0, 0),
                  const quill.VerticalSpacing(0, 0),
                  const quill.VerticalSpacing(0, 0),
                  null,
                ),
              ),
          embedBuilders: NTIRichTextEmbededBuilder.builder(),
        ),
      ),
    );
  }
}

class NTIRichTextStyle {
  final NTIRichTextBoxStyle? paragraph;

  NTIRichTextStyle({this.paragraph});

  quill.DefaultStyles _asDefaultStyle() {
    return quill.DefaultStyles(
      paragraph: paragraph?._asDefaultTextBlockStyle(),
    );
  }
}

class NTIRichTextBoxStyle {
  final TextStyle style;

  NTIRichTextBoxStyle({required this.style});

  quill.DefaultTextBlockStyle _asDefaultTextBlockStyle() {
    return quill.DefaultTextBlockStyle(
      style,
      const quill.HorizontalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      const quill.VerticalSpacing(0, 0),
      null,
    );
  }
}
