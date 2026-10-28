import 'package:dotted_border/dotted_border.dart';
import 'package:file/file.dart';
import 'package:file/local.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:app_ui/src/buttons/button.dart';
import 'package:app_ui/src/form/index.dart';
import 'package:app_ui/src/icon/index.dart';
import 'package:app_ui/src/layout/index.dart';
import 'package:app_ui/src/style/styles.dart';
import 'package:app_types/types.dart';
import 'package:url_launcher/url_launcher.dart';

part 'empty.dart';
part 'file_picked.dart';
part 'file_picker_dialog.dart';
part 'multi_file_picker_dialog.dart';
part 'util.dart';

class NTIFilePickerFormField extends StatelessWidget {
  final FormFieldSetter<NTIFile>? onSaved;
  final NTIFile? initialValue;
  final AutovalidateMode autovalidateMode;
  final String? title;
  final bool readOnly;
  final List<NTIFileExtension> extensionList;
  final String? hintText;
  final String? dialogTitle;
  final String? dialogLabel;
  final Future<NTIFile?> Function()? onPickFile;
  final String? Function(NTIFile? file)? validator;
  final Widget Function(VoidCallback onTap)? emptyWidget;
  final Widget Function(
    NTIFile file,
    VoidCallback onTap,
    VoidCallback onRemove,
  )?
  pickedFileWidget;

  const NTIFilePickerFormField({
    super.key,
    this.onSaved,
    this.initialValue,
    this.readOnly = false,
    this.emptyWidget,
    this.validator,
    this.dialogLabel,
    this.dialogTitle,
    this.autovalidateMode = AutovalidateMode.disabled,
    this.title,
    this.hintText,
    this.pickedFileWidget,
    this.extensionList = const [NTIFileExtension.pdf, NTIFileExtension.png],
    this.onPickFile,
  });

  void _setSelectedFile(NTIFile file, FormFieldState<NTIFile> field) {
    field.didChange(file);
  }

  void _removeSelectedFile(FormFieldState<NTIFile> field) {
    field.didChange(null);
  }

  void _pickFile(FormFieldState<NTIFile> field, BuildContext context) async {
    final picker = onPickFile;
    if (picker != null) {
      final file = await picker();
      if (file == null) return;
      _setSelectedFile(file, field);
      return;
    }
    final file = await NTIFilePickerDialog.show(
      context,
      autovalidateMode: autovalidateMode,
      extensionList: extensionList,
      emptyWidget: emptyWidget,
      dialogTitle: dialogTitle,
      initialValue: field.value,
      title: dialogLabel,
      pickedFileWidget: pickedFileWidget,
    );
    if (file == null) return;
    _setSelectedFile(file, field);
  }

  void _showBottomSheet(
    FormFieldState<NTIFile> field,
    BuildContext context,
  ) async {
    final color = context.colorTheme;
    final file = field.value;
    if (file == null) return;
    final result = await showModalBottomSheet(
      context: context,
      shape: NTIBottomSheet.basicBorder(),
      builder: (context) {
        return _BottomSheet(
          title: title,
          color: color,
          file: file,
          readOnly: readOnly,
        );
      },
    );
    if (result is! int) return;
    switch (result) {
      case 1:
        _removeSelectedFile(field);
      case 2:
        file.open();
      case 3:
        final newFile = await NTIFilePicker.pickFile(extensionList);
        if (newFile == null) return null;
        _setSelectedFile(NTILocalFile(file: newFile), field);
      case 4:
        if (file is! NTINetworkFile) return;
        launchUrl(Uri.parse(file.url));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FormField<NTIFile>(
      onSaved: onSaved,
      autovalidateMode: autovalidateMode,
      validator: (value) => validator?.call(value),
      initialValue: initialValue,
      builder: (FormFieldState<NTIFile> field) {
        final selectedFile = field.value;
        final bool hasError = field.hasError;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedFile != null)
              pickedFileWidget?.call(
                    selectedFile,
                    () => _pickFile(field, context),
                    () => _removeSelectedFile(field),
                  ) ??
                  InkWell(
                    onTap: () => _showBottomSheet(field, context),
                    child: _FilePicked(title: title, pickedFile: selectedFile),
                  ),
            if (selectedFile == null)
              emptyWidget?.call(() => _pickFile(field, context)) ??
                  InkWell(
                    onTap: () => _pickFile(field, context),
                    child: _EmptyFileWidget(hintText: hintText),
                  ),
            if (hasError)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  field.errorText!,
                  style: context.text.xs.copyWith(
                    color: context.colorTheme.accent12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({
    required this.title,
    required this.color,
    required this.readOnly,
    required this.file,
  });

  final String? title;
  final ColorTheme color;
  final bool readOnly;
  final NTIFile file;

  @override
  Widget build(BuildContext context) {
    final router = Navigator.of(context);
    return NTIBottomSheetListTile(
      title: title,
      items: [
        if (!readOnly)
          NTIBottomSheetListItem(
            title: "Hapus",
            titleTextStyle: TextStyle(color: color.systemDanger),
            onClick: () => router.maybePop(1),
          ),
        NTIBottomSheetListItem(
          title: "Lihat File",
          onClick: () => router.maybePop(2),
        ),
        if (!readOnly)
          NTIBottomSheetListItem(
            title: "Ganti File (Upload File)",
            onClick: () => router.maybePop(3),
          ),
        if (file is NTINetworkFile)
          NTIBottomSheetListItem(
            title: "Unduh",
            onClick: () => router.maybePop(4),
          ),
      ],
    );
  }
}
