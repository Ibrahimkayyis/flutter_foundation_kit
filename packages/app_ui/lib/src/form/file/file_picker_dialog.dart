part of 'file_picker_field.dart';

class _FilePickerData {
  NTIFile? file;
  _FilePickerData(this.file);
}

class NTIFilePickerDialog extends StatelessWidget {
  final NTIFile? initialValue;
  final AutovalidateMode autovalidateMode;
  final String? title;
  final String? dialogTitle;
  final List<NTIFileExtension> extensionList;
  final String? hintText;
  final String? Function(NTIFile? file)? validator;
  final Widget Function(VoidCallback onTap)? emptyWidget;
  final Widget Function(
    NTIFile file,
    VoidCallback onTap,
    VoidCallback onRemove,
  )?
  pickedFileWidget;
  const NTIFilePickerDialog._({
    this.initialValue,
    required this.dialogTitle,
    required this.autovalidateMode,
    this.title,
    required this.extensionList,
    this.hintText,
    this.validator,
    this.emptyWidget,
    this.pickedFileWidget,
  });

  static Future<NTIFile?> show(
    BuildContext context, {
    NTIFile? initialValue,
    required AutovalidateMode autovalidateMode,
    String? title,
    required List<NTIFileExtension> extensionList,
    String? hintText,
    String? dialogTitle,
    String? Function(NTIFile? file)? validator,
    required Widget Function(VoidCallback onTap)? emptyWidget,
    required Widget Function(
      NTIFile file,
      VoidCallback onTap,
      VoidCallback onRemove,
    )?
    pickedFileWidget,
  }) async {
    final result = await showDialog(
      useRootNavigator: false,
      context: context,
      builder:
          (context) => NTIFilePickerDialog._(
            dialogTitle: dialogTitle,
            autovalidateMode: autovalidateMode,
            emptyWidget: emptyWidget,
            hintText: hintText,
            initialValue: initialValue,
            pickedFileWidget: pickedFileWidget,
            title: title,
            validator: validator,
            extensionList: extensionList,
          ),
    );
    if (result is NTIFile) return result;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    return NTIDialogContainer(
      hasExitIcon: true,
      title: dialogTitle,
      onBackPressed: () => Navigator.of(context).maybePop(),
      hasDefaultHeader: dialogTitle != null,
      builder:
          (header) => SingleChildScrollView(
            child: NTIFormBuilder(
              onSubmit: (submitResult) {
                Navigator.of(context).maybePop(submitResult.value.file);
              },
              intialData: _FilePickerData(initialValue),
              build: (initialValue, value, submit, validate, setError, errors) {
                return Column(
                  children: [
                    if (header != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 24),
                        child: header,
                      ),
                    if (title != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text(
                          title!,
                          style: text.base.copyWith(
                            fontWeight: FontWeight.bold,
                            color: context.colorTheme.basic10,
                          ),
                        ),
                      ),
                    NTIFilePickerFormField(
                      title: title,
                      onSaved: (result) {
                        value.file = result;
                      },
                      onPickFile: () async {
                        final file = await NTIFilePicker.pickFile(
                          extensionList,
                        );
                        if (file == null) return null;
                        return NTILocalFile(file: file);
                      },
                      autovalidateMode: autovalidateMode,
                      extensionList: extensionList,
                      hintText: hintText,
                      emptyWidget:
                          (onTap) => InkWell(
                            onTap: onTap,
                            child: _EmptyDialog(hintText),
                          ),
                      initialValue: initialValue.file,
                      validator: validator,
                    ),
                    24.verticalSpace,
                    AppDefaultButton(
                      text: "Lanjut",
                      onPressed: submit,
                      isFillParent: true,
                      buttonType: ButtonType.secondary,
                    ),
                  ],
                );
              },
            ),
          ),
    );
  }
}

class _EmptyDialog extends StatelessWidget {
  final String? hintText;
  const _EmptyDialog(this.hintText);

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    return LayoutBuilder(
      builder: (context, constraint) {
        final width = constraint.maxWidth;
        const radius = Radius.circular(10);
        return DottedBorder(
          dashPattern: const [4],
          radius: radius,
          color: color.basic7,
          borderType: BorderType.RRect,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(radius),
            child: Container(
              width: width,
              height: width * .45,
              color: color.basic3,
              alignment: Alignment.center,
              child: Text(
                hintText ?? "Ketuk untuk unggah",
                style: context.text.base.copyWith(color: color.basic8),
              ),
            ),
          ),
        );
      },
    );
  }
}
