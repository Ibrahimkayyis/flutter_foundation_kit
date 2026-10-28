part of 'file_picker_field.dart';

class NTIFilePicker {
  static Future<File?> pickFile(
    List<NTIFileExtension>? allowedExtensions,
  ) async {
    final allowedExtensionsString =
        allowedExtensions?.map((type) => type.value).toList() ?? [];
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensionsString.isEmpty ? FileType.any : FileType.custom,
      allowedExtensions:
          allowedExtensionsString.isEmpty ? null : allowedExtensionsString,
    );

    if (result != null && result.files.isNotEmpty) {
      const file = LocalFileSystem();
      return file.file(result.files.single.path!);
    }

    return null;
  }

  static String getFileName(File file) {
    final fileName = file.path.split('/').last;
    return fileName;
  }

  static Future<List<File>?> pickMultipleFiles(
    List<NTIFileExtension>? allowedExtensions,
  ) async {
    final allowedExtensionsString =
        allowedExtensions?.map((type) => type.value).toList();
    final result = await FilePicker.platform.pickFiles(
      type: allowedExtensionsString != null ? FileType.custom : FileType.any,
      allowMultiple: true,
      allowedExtensions: allowedExtensionsString,
    );

    if (result != null && result.files.isNotEmpty) {
      const localFileSystem = LocalFileSystem();
      final files =
          result.files.map((file) => localFileSystem.file(file.path!)).toList();
      return files;
    }

    return null;
  }

  static void clearTemporaryFile(File file) async {
    await FilePicker.platform.clearTemporaryFiles();
  }
}
