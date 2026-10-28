part of 'file_picker_field.dart';

class _FilePicked extends StatelessWidget {
  final String? title;
  final NTIFile pickedFile;
  final VoidCallback? onRemove;
  final VoidCallback? onTap;

  const _FilePicked({
    this.title,
    required this.pickedFile,
    this.onRemove,
    super.key,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.colorTheme;
    final text = context.text;
    final fileSize = pickedFile.sizeInString;

    return Row(
      children: [
        const AppIcon(AppIcons.file, height: 20),
        16.horizontalSpace,
        Flexible(
          fit: FlexFit.loose,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                pickedFile.filename,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.sm.medium.copyWith(color: color.primary3),
              ),
              2.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (fileSize != null)
                    Text(
                      fileSize,
                      style: text.sm.medium.copyWith(color: color.primary3),
                    ),
                  if (fileSize != null) 4.horizontalSpace,
                  if (fileSize != null)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: color.basic7Reverse,
                        shape: BoxShape.circle,
                      ),
                    ),
                  4.horizontalSpace,
                  Text(
                    pickedFile.extensionInString,
                    style: text.xs.copyWith(color: color.basic7Reverse),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (onTap != null)
          AppOutlinedButton(text: 'Lihat', onPressed: onTap!),
        if (onRemove != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: InkWell(
              onTap: onRemove,
              child: const AppIcon(AppIcons.close, height: 20),
            ),
          ),
      ],
    );
  }
}
