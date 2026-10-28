import 'package:flutter/foundation.dart';
import 'package:app_types/app_types.dart';

abstract class ToJSONMapper<Data> {
  JSON toJSON(Data data);
}

abstract class FromJSONMapper<Data> {
  Data fromJSON(JSON json);
}

class JSONMapperWrapper<Data> implements FromJSONMapper<Data> {
  final Data Function(JSON json) mapper;

  JSONMapperWrapper({required this.mapper});

  @override
  Data fromJSON(JSON json) => mapper(json);
}

extension FromJSONList<Data> on FromJSONMapper<Data> {
  List<Data> fromJSONList(List<dynamic> list) =>
      list.map((e) => fromJSON(e)).toList();

  Data? tryFromJSON(JSON json) {
    try {
      return fromJSON(json);
    } catch (e, stackTrace) {
      debugPrint("Error parse $e");
      debugPrintStack(stackTrace: stackTrace);
      return null;
    }
  }

  List<Data> safeFromJSONList(List<dynamic> list) =>
      list.map((e) => tryFromJSON(e)).whereType<Data>().toList();
}

extension ToJSONList<Data> on ToJSONMapper<Data> {
  List<dynamic> toJSONList(List<Data> list) =>
      list.map((e) => toJSON(e)).toList();
}

abstract class FromJSONMapperWithParams<Data, Param> {
  Data fromJSON(JSON json, Param param);
}

abstract class JSONMapper<Data>
    implements ToJSONMapper<Data>, FromJSONMapper<Data> {}

abstract class JSONMapperWithParams<Data, Params>
    implements ToJSONMapper<Data>, FromJSONMapperWithParams<Data, Params> {}
