part of 'file.dart';

enum AppFileType {
  pdf(extensions: [AppFileExtension.pdf]),
  image(
    extensions: [
      AppFileExtension.gif,
      AppFileExtension.jpeg,
      AppFileExtension.jpg,
      AppFileExtension.png,
      AppFileExtension.bmp,
      AppFileExtension.webp,
    ],
  ),
  other(extensions: []);

  static const _values = AppFileType.values;

  static AppFileType fromFilename(String filename) {
    final fileExt = path.extension(filename).replaceFirst('.', '').toLowerCase();
    for (final element in _values) {
      final extensionsString = element.extensions.map((e) => e.value);
      if (extensionsString.contains(fileExt)) return element;
    }
    return AppFileType.other;
  }

  final List<AppFileExtension> extensions;

  const AppFileType({required this.extensions});

  bool get canBeOpen => this != AppFileType.other;
}

enum AppFileExtension {
  pdf('pdf'),

  // Images
  jpg('jpg'),
  png('png'),
  gif('gif'),
  bmp('bmp'),
  webp('webp'),
  jpeg('jpeg');

  final String value;
  const AppFileExtension(this.value);
}


typedef NTIFileType = AppFileType;
typedef NTIFileExtension = AppFileExtension;
