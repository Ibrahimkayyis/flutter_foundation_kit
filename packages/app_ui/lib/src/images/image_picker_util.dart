import 'dart:io';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

enum NTIImageSource {
  gallery(ImageSource.gallery),
  camera(ImageSource.camera);

  final ImageSource _source;

  const NTIImageSource(this._source);
}

class NTICropConfig {
  final NTICropRatio? ratio;
  final NTICropStyle cropStyle;

  NTICropConfig({this.ratio, this.cropStyle = NTICropStyle.rectanlge});
}

class NTICropRatio {
  final double xRatio;
  final double yRatio;

  NTICropRatio({required this.xRatio, required this.yRatio});
}

enum NTICropStyle {
  rectanlge(CropStyle.rectangle),
  circle(CropStyle.circle);

  final CropStyle style;

  const NTICropStyle(this.style);
}

class NTIImagePickerUtil {
  static Future<File?> pickMedia({
    required NTIImageSource source,
    bool cropImageFirst = true,
    NTICropConfig? config,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickMedia();
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);
    if (!cropImageFirst) return imageFile;

    return cropImage(imageFile: imageFile, config: config);
  }

  static Future<File?> pickImage({
    required NTIImageSource source,
    bool cropImageFirst = true,
    NTICropConfig? config,
  }) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source._source);
    if (pickedFile == null) return null;

    File imageFile = File(pickedFile.path);
    if (!cropImageFirst) return imageFile;

    return await cropImage(imageFile: imageFile, config: config);
  }

  static Future<List<File>> pickImages({
    required NTIImageSource source,
    int? max,
  }) async {
    final picker = ImagePicker();
    if (source == NTIImageSource.camera) {
      final image = await pickImage(source: source);
      if (image == null) return [];
      return [image];
    }
    final pickedFile = await picker.pickMultiImage();
    if (max == null) return pickedFile.map((e) => File(e.path)).toList();
    return pickedFile.take(max).map((e) => File(e.path)).toList();
  }

  static Future<File?> cropImage({
    required File imageFile,
    NTICropConfig? config,
  }) async {
    CroppedFile? croppedImage = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      aspectRatio:
          config?.ratio != null
              ? CropAspectRatio(
                ratioX: config!.ratio!.xRatio,
                ratioY: config.ratio!.yRatio,
              )
              : null,
      uiSettings: [
        AndroidUiSettings(
          cropStyle: config?.cropStyle.style ?? CropStyle.rectangle,
        ),
        IOSUiSettings(
          cropStyle: config?.cropStyle.style ?? CropStyle.rectangle,
        ),
      ],
    );
    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }
}
