part of 'rich_text_field.dart';

class NTIInlineRichTextField extends StatefulWidget {
  final NTIRichText? initial;
  final String? hint;
  final double? maxHeight;
  final NTIRichTextFieldParams params;
  final String? title;
  final NTIRichTextFieldController? controller;
  final String? Function(NTIRichText? value)? validator;
  final void Function(NTIRichText? value)? onSaved;
  final FocusNode? focusNode;
  final bool showBorder;
  const NTIInlineRichTextField({
    super.key,
    this.initial,
    this.hint,
    this.title,
    this.maxHeight,
    this.validator,
    this.showBorder = true,
    this.controller,
    this.focusNode,
    this.params = const NTIRichTextFieldParams(),
    this.onSaved,
  });

  @override
  State<NTIInlineRichTextField> createState() => _NTIInlineRichTextFieldState();
}

class NTIRichTextFieldValueListener extends ValueNotifier<NTIRichText> {
  final NTIRichTextFieldController controller;
  NTIRichTextFieldValueListener(this.controller) : super(controller.richText) {
    controller.addListener(_onChange);
  }

  void _onChange() {
    value = controller.richText;
  }

  @override
  void dispose() {
    controller.removeListener(_onChange);
    super.dispose();
  }
}

class NTIRichTextFieldController extends quill.QuillController {
  NTIRichTextFieldController({NTIRichText? initial})
    : super(
        selection: const TextSelection.collapsed(offset: 0),
        document:
            initial != null
                ? quill.Document.fromJson(initial.json)
                : quill.Document(),
      );

  set richText(NTIRichText? text) {
    document =
        text?.json != null
            ? quill.Document.fromJson(text!.json)
            : quill.Document();
  }

  NTIRichText get richText => NTIRichText(json: document.toDelta().toJson());
}

class _NTIInlineRichTextFieldState extends State<NTIInlineRichTextField> {
  late NTIRichTextFieldController _controller;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        NTIRichTextFieldController(initial: widget.initial);
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final text = context.text;
    return FormField(
      onSaved:
          (_) => widget.onSaved?.call(
            !_controller.document.isEmpty()
                ? NTIRichText(json: _controller.document.toDelta().toJson())
                : null,
          ),
      validator:
          (_) => widget.validator?.call(
            _controller.document.isEmpty() == false
                ? NTIRichText(json: _controller.document.toDelta().toJson())
                : null,
          ),
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: widget.showBorder ? color.basic1 : color.basic4,
                border:
                    widget.showBorder
                        ? Border.all(
                          color: field.hasError ? color.accent12 : color.basic5,
                        )
                        : null,
                borderRadius: BorderRadius.circular(8),
              ),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.title != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 2),
                      child: Text(
                        widget.title!,
                        style: text.xs.copyWith(color: color.basic8),
                      ),
                    ),
                  Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,
                    child: quill.QuillEditor.basic(
                      focusNode: widget.focusNode,
                      scrollController: _scrollController,
                      controller: _controller,
                      config: quill.QuillEditorConfig(
                        enableInteractiveSelection: true,
                        maxHeight: widget.maxHeight,
                        autoFocus: false,
                        placeholder: widget.hint,
                        customStyles: quill.DefaultStyles(
                          placeHolder: quill.DefaultTextBlockStyle(
                            context.text.base.applyColor(
                              context.colorTheme.basic7,
                            ),
                            const quill.HorizontalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            const quill.VerticalSpacing(0, 0),
                            const BoxDecoration(),
                          ),
                        ),
                        embedBuilders: NTIRichTextEmbededBuilder.builder(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (field.errorText != null)
              Padding(
                padding: const EdgeInsets.only(top: 6.0, left: 12),
                child: Text(
                  field.errorText!,
                  style: context.text.xs.applyColor(color.accent12),
                ),
              ),
          ],
        );
      },
    );
  }
}

extension QuillDocumentExt on quill.Document {
  String? findFirstLink() {
    final document = this;
    for (var node in document.toDelta().toList()) {
      if (node.attributes != null &&
          node.attributes?.containsKey('link') == true) {
        return node.data.toString();
      }
    }
    return null;
  }
}
