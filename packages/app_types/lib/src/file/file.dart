import 'package:equatable/equatable.dart';
import 'package:file/file.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as path;
import 'package:url_launcher/url_launcher.dart';

part 'file_ext.dart';

sealed class AppFile extends Equatable {
  final String filename;
  final AppFileType extension;
  final DateTime? createdAt;
  final int? sizeInBytes;

  Future<void> open();

  String? get sizeInString {
    if (sizeInBytes == null) return null;
    const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
    var size = sizeInBytes!.toDouble();
    var i = 0;
    while (size >= 1024 && i < suffixes.length - 1) {
      size /= 1024;
      i++;
    }
    return '${size.toStringAsFixed(2)} ${suffixes[i]}';
  }

  String get extensionInString => path.extension(filename);

  AppFile({required this.filename, this.createdAt, this.sizeInBytes})
    : extension = AppFileType.fromFilename(filename);

  @override
  List<Object?> get props => [filename, extension, createdAt, sizeInBytes];
}

class AppNetworkFile extends AppFile {
  final String? id;
  final String url;

  AppNetworkFile({
    required this.url,
    required super.filename,
    super.createdAt,
    super.sizeInBytes,
    this.id,
  });

  @override
  Future<void> open() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  List<Object?> get props => [...super.props, id, url];
}

class AppBase64StringFile extends AppFile {
  final String base64String;

  AppBase64StringFile({required super.filename, required this.base64String});

  @override
  Future<void> open() async {}
}

class AppLocalFile extends AppFile {
  final File file;

  AppLocalFile({required this.file})
    : super(filename: path.basename(file.path));

  @override
  Future<void> open() async {
    await OpenFilex.open(file.path);
  }

  @override
  List<Object?> get props => [file.path, ...super.props];
}


typedef NTIFile = AppFile;
typedef NTINetworkFile = AppNetworkFile;
typedef NTILocalFile = AppLocalFile;
typedef NTIBase64StringFile = AppBase64StringFile;
