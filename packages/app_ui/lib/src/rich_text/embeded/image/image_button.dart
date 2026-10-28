part of 'embeded_image.dart';

class NTIQuillImageButton extends StatelessWidget {
  const NTIQuillImageButton({
    required this.icon,
    required this.controller,
    this.iconSize = 18,
    this.fillColor,
    this.iconTheme,
    this.dialogTheme,
    this.tooltip,
    this.linkRegExp,
    super.key,
  });

  final IconData icon;
  final double iconSize;

  final Color? fillColor;

  final QuillController controller;

  final QuillIconTheme? iconTheme;

  final QuillDialogTheme? dialogTheme;
  final String? tooltip;
  final RegExp? linkRegExp;

  @override
  Widget build(BuildContext context) {
    return QuillToolbarIconButton(
      isSelected: false,
      icon: Icon(icon, size: iconSize),
      tooltip: tooltip,
      iconTheme: iconTheme,
      onPressed: () => _onPressedHandler(context),
    );
  }

  Future<void> _onPressedHandler(BuildContext context) async {
    final source = await NTIImageSourceWidget.launch(context);
    if (source == null) return;
    final image = await NTIImagePickerUtil.pickImage(source: source);
    if (image == null) return;
    final data = await NTIImageEmbeded.fromFile(image);
    final index = controller.selection.baseOffset;
    final length = controller.selection.extentOffset - index;
    controller.replaceText(index, length, data, null);
  }
}
