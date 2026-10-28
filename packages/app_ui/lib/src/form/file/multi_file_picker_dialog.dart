part of 'file_picker_field.dart';

class NTIMultiFilePickerField extends StatelessWidget {
  final String? title;
  final FormFieldSetter<List<NTIFile>>? onSaved;
  final List<NTIFile>? initialValue;
  final List<NTIFileExtension> extensionList;
  final String? hintText;
  final String? dialogTitle;
  final String? dialogLabel;
  final bool readOnly;
  final String? Function(List<NTIFile>? file)? validator;
  final Widget Function(VoidCallback onTap)? emptyWidget;
  final Widget Function(
    NTIFile file,
    VoidCallback onTap,
    VoidCallback onRemove,
  )? pickedFileWidget;

  const NTIMultiFilePickerField({
    super.key,
    this.title,
    this.onSaved,
    this.initialValue,
    this.extensionList = const [],
    this.hintText,
    this.dialogTitle,
    this.dialogLabel,
    this.readOnly = false,
    this.validator,
    this.emptyWidget,
    this.pickedFileWidget,
  });

  Future<NTIFile?> _onNew(BuildContext context) async {
    final result = await NTIFilePicker.pickFile(extensionList);
    if (result == null) return null;
    return NTILocalFile(file: result);
  }

  void _onOpen(BuildContext context, NTIFile file) async {
    await file.open();
  }

  @override
  Widget build(BuildContext context) {
    return NTIFormList<NTIFile>(
      onSaved: onSaved,
      initialValues: initialValue ?? [],
      widgetBuiler: (builder, onAdd) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text("Lampiran", style: context.text.base.bold),
            ),
          if (builder.isNotEmpty)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: context.colorTheme.basic11,
                border: Border.all(
                  color: context.colorTheme.basic6Reverse,
                  width: 1,
                ),
              ),
              child: Column(
                children: builder
                    .asMap()
                    .entries
                    .map(
                      (entry) => Padding(
                        padding: EdgeInsets.only(top: entry.key == 0 ? 0 : 12),
                        child: entry.value,
                      ),
                    )
                    .toList(),
              ),
            ),
          if (builder.isNotEmpty) 14.verticalSpace,
          if (!readOnly)
            emptyWidget?.call(onAdd) ??
                AppOutlinedButton(
                  text: "Tambah",
                  onPressed: onAdd,
                  buttonType: ButtonType.secondary,
                ),
        ],
      ),
      itemBuilder: (key, index, value, onAdd, onRemove, _) => _FilePicked(
        key: Key(key),
        pickedFile: value,
        onTap: readOnly ? () => _onOpen(context, value) : null,
        onRemove: !readOnly ? onRemove : null,
      ),
      onNew: (_) => _onNew(context),
    );
  }
}
