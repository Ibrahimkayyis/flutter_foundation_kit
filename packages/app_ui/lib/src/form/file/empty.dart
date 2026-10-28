part of 'file_picker_field.dart';

class _EmptyFileWidget extends StatelessWidget {
  final String? hintText;
  const _EmptyFileWidget({
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DottedBorder(
          borderType: BorderType.RRect,
          radius: const Radius.circular(8),
          color: context.colorTheme.basic7,
          strokeWidth: 1,
          dashPattern: const [6, 3],
          child: Container(
            decoration: BoxDecoration(
              color: context.colorTheme.basic2,
            ),
            padding: const EdgeInsets.symmetric(vertical: 48),
            width: double.infinity,
            child: Center(
              child: Text(
                hintText ?? '',
                style: context.text.base.copyWith(
                  color: context.colorTheme.basic8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
