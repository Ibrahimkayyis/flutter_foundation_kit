part of 'embeded_image.dart';

class NTIImageEmbeded extends CustomBlockEmbed {
  final NTIImage image;

  NTIImageEmbeded(this.image)
    : super(NTIImage.className, jsonEncode(image.toJSON()));

  static Future<NTIImageEmbeded> fromFile(File file) async {
    final bytes = await file.readAsBytes();
    return NTIImageEmbeded(
      NTIMemoryImage(image: file.path, bytes: bytes, filepath: file.path),
    );
  }

  @override
  int get hashCode => image.hashCode ^ super.hashCode;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NTIImageEmbeded &&
            runtimeType == other.runtimeType &&
            image == other.image;
  }

  @override
  String toString() => 'IAImageEmbeded(image: $image)';
}

(List<NTIImage> images, int initialIndex) _findLinesByKey(
  QuillController controller,
  String? currentImageFilename,
) {
  final delta = controller.document.toDelta().toList();
  int? initialIndex;
  final List<NTIImage> images = [];
  var index = 0;
  for (final op in delta) {
    final json = op.toJson();
    json.remove("insert");
    final attributes = op.data;
    if (attributes != null &&
        attributes is Map<String, dynamic> &&
        attributes.containsKey('image')) {
      final image = attributes["image"];

      final data = NTIImage.fromJSON(
        image is String ? jsonDecode(image) : image,
      );
      images.add(data);
      if (initialIndex == null &&
          currentImageFilename != null &&
          data.name == currentImageFilename) {
        initialIndex = index;
      }
      index++;
    }
  }

  return (images, initialIndex ?? 0);
}
