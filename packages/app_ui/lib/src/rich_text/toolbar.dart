part of 'rich_text_field.dart';

const toolbar = {};

quill.QuillIconTheme _themBuilder(BuildContext context) {
  final color = context.colorTheme;
  return quill.QuillIconTheme(
    iconButtonSelectedData: quill.IconButtonData(
      color: color.primary4,
      iconSize: 14.r,
    ),
    iconButtonUnselectedData: quill.IconButtonData(
      color: color.basic2,
      iconSize: 10.r,
    ),
  );
}

class _Toolbar extends StatefulWidget {
  const _Toolbar({
    required this.color,
    required quill.QuillController controller,
    required this.params,
  }) : _controller = controller;

  final ColorTheme color;
  final NTIRichTextFieldParams params;
  final quill.QuillController _controller;

  @override
  State<_Toolbar> createState() => _ToolbarState();
}

class _ToolbarState extends State<_Toolbar> {
  bool _showMore = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.color.basic1Reverse,
        boxShadow: [
          BoxShadow(
            color: widget.color.basic1Reverse.withAlpha((.98 * 255).round()),
          ),
        ],
        border: Border(
          top: BorderSide(color: widget.color.basic5Reverse, width: .5),
        ),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.paddingOf(context).bottom,
        top: 16,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              if (widget.params.showImagePicker)
                NTIQuillImageButton(
                  icon: Icons.image,
                  controller: widget._controller,
                  iconTheme: _themBuilder(context),
                ),
              _CustomButton(
                tooltip: "Bold",
                controller: widget._controller,
                attribute: quill.Attribute.bold,
                icon: Icons.format_bold,
              ),
              _CustomButton(
                icon: Icons.format_italic,
                attribute: quill.Attribute.italic,
                tooltip: 'Italic',
                controller: widget._controller,
              ),
              _CustomButton(
                attribute: quill.Attribute.underline,
                icon: Icons.format_underline,
                tooltip: 'Underline',
                controller: widget._controller,
              ),
              _CustomButton(
                attribute: quill.Attribute.ul,
                icon: Icons.format_list_bulleted,
                tooltip: 'List',
                controller: widget._controller,
              ),
              quill.QuillToolbarLinkStyleButton(
                controller: widget._controller,
                options: quill.QuillToolbarLinkStyleButtonOptions(
                  iconTheme: _themBuilder(context),
                  iconData: Icons.link,
                  tooltip: 'Link',
                ),
              ),
              quill.QuillToolbarCustomButton(
                controller: widget._controller,
                options: quill.QuillToolbarCustomButtonOptions(
                  icon: Icon(
                    !_showMore
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                  ),
                  iconTheme: _themBuilder(context),
                  onPressed: () {
                    setState(() {
                      _showMore = !_showMore;
                    });
                  },
                ),
              ),
            ],
          ),
          if (_showMore)
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.center,
              children: [
                quill.QuillToolbarHistoryButton(
                  isUndo: true,
                  options: quill.QuillToolbarHistoryButtonOptions(
                    iconData: Icons.undo_outlined,
                    tooltip: 'Undo',
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                ),
                quill.QuillToolbarHistoryButton(
                  isUndo: false,
                  options: quill.QuillToolbarHistoryButtonOptions(
                    iconData: Icons.redo_outlined,
                    tooltip: 'Redo',
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                _CustomButton(
                  attribute: quill.Attribute.subscript,
                  icon: Icons.subscript,
                  tooltip: 'Subscript',
                  controller: widget._controller,
                ),
                _CustomButton(
                  attribute: quill.Attribute.superscript,
                  icon: Icons.superscript,
                  tooltip: 'Superscript',
                  controller: widget._controller,
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                _CustomButton(
                  attribute: quill.Attribute.small,
                  icon: Icons.format_size,
                  tooltip: 'Small',
                  controller: widget._controller,
                ),
                _CustomButton(
                  attribute: quill.Attribute.strikeThrough,
                  icon: Icons.format_strikethrough,
                  tooltip: 'Strike Through',
                  controller: widget._controller,
                ),
                _CustomButton(
                  attribute: quill.Attribute.inlineCode,
                  icon: Icons.code,
                  tooltip: 'Code',
                  controller: widget._controller,
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                quill.QuillToolbarColorButton(
                  controller: widget._controller,
                  isBackground: false,
                  options: quill.QuillToolbarColorButtonOptions(
                    iconData: Icons.color_lens,
                    tooltip: "Color",
                    iconTheme: _themBuilder(context),
                  ),
                ),
                quill.QuillToolbarColorButton(
                  options: quill.QuillToolbarColorButtonOptions(
                    iconData: Icons.format_color_fill,
                    tooltip: "Fill Color",
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                  isBackground: true,
                ),
                quill.QuillToolbarClearFormatButton(
                  options: quill.QuillToolbarClearFormatButtonOptions(
                    iconData: Icons.format_clear,
                    tooltip: "Clear",
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                // quill.QuillToolbarSelectAlignmentButtons(
                //   controller: widget._controller,
                //   tooltips: {},
                //   iconSize: _buttonSize,
                //   showLeftAlignment: true,
                //   showCenterAlignment: true,
                //   showRightAlignment: true,
                //   showJustifyAlignment: true,
                //   iconTheme: _themBuilder(context),
                // ),
                quill.QuillToolbarSelectHeaderStyleButtons(
                  options: quill.QuillToolbarSelectHeaderStyleButtonsOptions(
                    tooltip: "Header",
                    axis: Axis.horizontal,
                    iconButtonFactor: 2,
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                quill.QuillToolbarToggleStyleButton(
                  attribute: quill.Attribute.ol,
                  controller: widget._controller,
                  options: quill.QuillToolbarToggleStyleButtonOptions(
                    tooltip: "List Number",
                    iconData: Icons.format_list_numbered,
                    iconTheme: _themBuilder(context),
                  ),
                ),

                quill.QuillToolbarToggleStyleButton(
                  attribute: quill.Attribute.unchecked,
                  controller: widget._controller,
                  options: quill.QuillToolbarToggleStyleButtonOptions(
                    tooltip: "List Bullet",
                    iconData: Icons.check_box,
                    iconTheme: _themBuilder(context),
                  ),
                ),
                const quill.QuillToolbarDivider(Axis.horizontal),
                quill.QuillToolbarToggleStyleButton(
                  controller: widget._controller,
                  attribute: quill.Attribute.blockQuote,
                  options: quill.QuillToolbarToggleStyleButtonOptions(
                    tooltip: "Block Quote",
                    iconData: Icons.format_quote,
                    iconTheme: _themBuilder(context),
                  ),
                ),
                quill.QuillToolbarIndentButton(
                  controller: widget._controller,
                  isIncrease: true,
                  options: quill.QuillToolbarIndentButtonOptions(
                    iconData: Icons.format_indent_increase,
                    tooltip: "Indent Increase",
                    iconTheme: _themBuilder(context),
                  ),
                ),
                quill.QuillToolbarIndentButton(
                  options: quill.QuillToolbarIndentButtonOptions(
                    iconData: Icons.format_indent_decrease,
                    tooltip: "Indent Decrease",
                    iconTheme: _themBuilder(context),
                  ),
                  controller: widget._controller,
                  isIncrease: false,
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class _CustomButton extends StatelessWidget {
  const _CustomButton({
    required quill.QuillController controller,
    required this.attribute,
    required this.icon,
    required this.tooltip,
  }) : _controller = controller;

  final quill.QuillController _controller;
  final quill.Attribute<dynamic> attribute;
  final IconData icon;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return quill.QuillToolbarToggleStyleButton(
      attribute: attribute,
      options: quill.QuillToolbarToggleStyleButtonOptions(
        tooltip: tooltip,
        iconTheme: _themBuilder(context),
      ),
      controller: _controller,
    );
  }
}
