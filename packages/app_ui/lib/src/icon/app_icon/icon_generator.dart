// import 'dart:io';

import 'dart:io';

extension _ListExtension<E> on List<E> {
  List<T> _mapIndexed<T>(T Function(int index, E item) mapper) {
    return List.generate(length, (index) => mapper(index, this[index]));
  }
}

extension _UtilExtensions on String {
  List<String> _multiSplit(Iterable<String> delimeters) =>
      delimeters.isEmpty
          ? [this]
          : split(RegExp(delimeters.map(RegExp.escape).join('|')));
}

String _enumNameFromFileName(String fileName) {
  final fileNameWithoutExt = fileName.split(".")[0];
  return fileNameWithoutExt
      ._multiSplit(["-", "_"])
      ._mapIndexed((i, e) {
        if (i == 0) return e;
        return "${e[0].toUpperCase()}${e.substring(1).toLowerCase()}";
      })
      .join("");
}

String _enumItemFromFileName(String fileName) {
  return "${_enumNameFromFileName(fileName)}(\"\$prefix/$fileName\", ${fileName.contains("dualtone")})";
}

void main() async {
  final file = File('lib/src/icon/nti_icon/icons.dart');
  final dir = Directory('assets/icons');
  final List<FileSystemEntity> entities = await dir.list().toList();
  final sortedFileName =
      entities.map((e) => e.uri.pathSegments.last).toList()..sort();
  final sink = file.openWrite();
  sink.write("""
  part of 'icon.dart';

  const prefix = "assets/icons";

  enum AppIcons {
    ${sortedFileName.map((e) => _enumItemFromFileName(e)).join(",\n")}
    ;

    const AppIcons(this._path, this._isDualTone);
    final String _path;
    final bool _isDualTone;
  }

  """);
}
