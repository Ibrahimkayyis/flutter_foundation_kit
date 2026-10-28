import 'dart:math';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_ui/src/buttons/button.dart';
import 'package:app_ui/src/icon/index.dart';
import 'package:app_ui/src/images/image_picker_util.dart';
import 'package:app_ui/src/images/source_picker/image_source_picker.dart';
import 'package:app_ui/src/layout/index.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:photo_view/photo_view.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:app_types/types.dart';

part 'child.dart';
part 'image_source_dialog.dart';
part 'edit.dart';
part 'styles.dart';

part 'multiple/multi_image_picker.dart';
part 'multiple/multi_image_picker_preview.dart';

class NTIImagePickerField extends StatefulWidget {
  final NTIImage? initialImage;
  final NTIImagePickerStyle style;
  final void Function(NTIImage? value)? onChanged;
  final void Function(NTIImage? value)? onSaved;
  final String? Function(NTIImage? value)? validator;
  final String? removeTitle;
  final String? removeDesc;
  final NTIImagePickerController? controller;
  final String? pickerTitle;
  final String? editTitle;
  final bool cropAfterPick;
  final NTICropConfig? cropConfig;
  const NTIImagePickerField({
    super.key,
    this.onChanged,
    this.onSaved,
    this.pickerTitle,
    this.editTitle,
    this.initialImage,
    this.cropAfterPick = true,
    this.controller,
    this.validator,
    this.cropConfig,
    this.removeTitle,
    this.removeDesc,
    this.style = const NTIImagePickerAvatar(),
  });

  @override
  State<NTIImagePickerField> createState() => _NTIImagePickerFieldState();
}

class NTIImagePickerController extends ValueNotifier<NTIImage?> {
  _NTIImagePickerFieldState? _state;
  NTIImagePickerController({NTIImage? initialValue}) : super(initialValue);

  void _setState(_NTIImagePickerFieldState state) {
    _state = state;
  }

  void pickImage() => _state?._pickImage();

  @override
  void dispose() {
    _state = null;
    super.dispose();
  }
}

class _NTIImagePickerFieldState extends State<NTIImagePickerField> {
  late final NTIImagePickerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        widget.controller ??
        NTIImagePickerController(initialValue: widget.initialImage);
    _controller._setState(this);
    _controller.addListener(() {
      widget.onChanged?.call(_controller.value);
    });
  }

  void _onClick() {
    final image = _controller.value;
    if (image == null) {
      _pickImage();
      return;
    }
    _seeImagePreview();
  }

  void _pickImage() async {
    final result = await NTIImageSourceWidget.launch(
      context,
      title: widget.pickerTitle,
      onRemove: () {
        Navigator.of(context).pop();
        _removeImage();
      },
    );
    if (result == null) return;
    final image = await NTIImagePickerUtil.pickImage(
      source: result,
      cropImageFirst: widget.cropAfterPick,
      config: widget.cropConfig,
    );
    if (image == null) return;
    _controller.value = NTIFileImage(
      filepath: image.path,
      name: path.basename(image.path),
    );
  }

  void _removeImage() async {
    final isRemoveConfirmed = await NTIConfirmationDialog.show(
      context,
      title: widget.removeTitle ?? "Hapus Foto",
      confirmText: "Tidak",
      cancelText: "Hapus",
      desc: widget.removeDesc ?? "apa anda yakin akan hapus foto",
    );
    if (isRemoveConfirmed) return;
    _controller.value = null;
  }

  void _seeImagePreview() async {
    await NTIImageEditor.launch(
      context,
      controller: _controller,
      cropConfig: widget.cropConfig,
      cropAfterPick: widget.cropAfterPick,
      pickerTitle: widget.pickerTitle,
      title: widget.editTitle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final style = widget.style;
    return FormField<NTIImage>(
      validator: (_) {
        return widget.validator?.call(_controller.value);
      },
      onSaved: (_) {
        widget.onSaved?.call(_controller.value);
      },
      builder:
          (field) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ValueListenableBuilder(
                valueListenable: _controller,
                builder: (context, value, child) {
                  return style.build(
                    context,
                    value,
                    _onClick,
                    _removeImage,
                    _pickImage,
                  );
                },
              ),
              if (field.hasError)
                Text(
                  field.errorText!,
                  style: context.text.body.copyWith(color: color.systemDanger),
                ),
            ],
          ),
    );
  }
}
