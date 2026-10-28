part of 'rich_text_field.dart';

class NTIRichTextFullScreen extends StatefulWidget {
  final NTIRichText initial;
  final String? title;
  final String? hint;
  final bool showAppBar;
  final void Function(NTIRichText?)? onSave;
  final NTIRichTextFieldController? controller;
  final NTIRichTextFieldParams params;
  const NTIRichTextFullScreen({
    super.key,
    required this.initial,
    this.title,
    this.hint,
    this.showAppBar = true,
    this.controller,
    required this.params,
    this.onSave,
  });

  static Future<quill.Document?> launch(
    BuildContext context,
    Delta initial, {
    String? title,
    String? hint,
    required NTIRichTextFieldParams params,
  }) async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) {
          return NTIRichTextFullScreen(
            initial: NTIRichText(json: initial.toJson()),
            title: title,
            hint: hint,
            params: params,
          );
        },
      ),
    );
    if (result is quill.Document) return result;
    return null;
  }

  @override
  State<NTIRichTextFullScreen> createState() => _NTIRichTextFullScreenState();
}

class _NTIRichTextFullScreenState extends State<NTIRichTextFullScreen> {
  late final quill.QuillController _controller;

  @override
  void initState() {
    super.initState();
    _controller = quill.QuillController(
      document: quill.Document.fromJson(widget.initial.json),
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final content = FormField(
      onSaved:
          (value) => widget.onSave?.call(
            _controller.document.isEmpty() == false
                ? NTIRichText(json: _controller.document.toDelta().toJson())
                : null,
          ),
      builder:
          (_) => Column(
            children: [
              Container(height: 16, color: context.colorTheme.basic2Reverse),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: context.colorTheme.basic7Reverse.withAlpha(
                          (.15 * 255).round(),
                        ),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: const Offset(
                          0,
                          .5,
                        ), // changes position of shadow
                      ),
                    ],
                    color: context.colorTheme.basic1Reverse,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: quill.QuillEditor.basic(
                      controller: _controller,
                      config: quill.QuillEditorConfig(
                        autoFocus: false,

                        embedBuilders: NTIRichTextEmbededBuilder.builder(),
                      ),
                    ),
                  ),
                ),
              ),
              _Toolbar(
                color: color,
                controller: _controller,
                params: widget.params,
              ),
            ],
          ),
    );
    if (!widget.showAppBar) {
      return content;
    }
    return Scaffold(
      appBar: NTIAppBar(
        context: context,
        leading: Center(
          child: InkWell(
            onTap: () => Navigator.of(context).maybePop(),
            child: AppIcon(AppIcons.close, color: color.basic7),
          ),
        ),
        title: Text(widget.title ?? "Edit"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: InkWell(
              onTap: () {
                Navigator.of(context).maybePop(_controller.document);
              },
              child: AppIcon(AppIcons.check, color: color.accent12Reverse),
            ),
          ),
        ],
      ),
      body: content,
    );
  }
}
