import 'package:flutter_test/flutter_test.dart';
import 'package:app_core/app_core.dart';

class Person {
  final String name;
  final int age;

  const Person({required this.name, required this.age});

  Map<String, dynamic> toJSON() => {'name': name, 'age': age};
}

class FromJSONMapperExample extends JSONMapper<Person> {
  @override
  Person fromJSON(dynamic json) {
    return Person(name: json['name'], age: json['age']);
  }

  @override
  dynamic toJSON(Person data) {
    return data.toJSON();
  }
}

void main() {
  final mapper = FromJSONMapperExample();

  const personJohn = Person(name: 'John', age: 20);
  const personJane = Person(name: 'Jane', age: 21);
  final personJohnJson = personJohn.toJSON();
  final jsonList = [personJohnJson, personJane.toJSON()];

  test('Test FromJSONMapper', () {
    final result = mapper.fromJSON(personJohnJson);
    expect(result.name, personJohn.name);
    expect(result.age, personJohn.age);
  });

  test('Test FromJSONMapperList', () {
    final result = mapper.fromJSONList(jsonList);
    expect(result.length, jsonList.length);
    expect(result[0].name, personJohn.name);
    expect(result[1].age, personJane.age);
  });

  test('May From JSONList Not Null', () {
    final result = mapper.tryFromJSON(personJohnJson);
    expect(result?.name, personJohn.name);
    expect(result?.age, personJohn.age);
  });

  test('May From JSONList Null', () {
    final result = mapper.tryFromJSON({'name': 1});
    expect(result, isNull);
  });

  test('Test SafeFromJSONMapperList with wrong type', () {
    final result = mapper.safeFromJSONList([
      ...jsonList,
      {'name': 1},
    ]);
    expect(result.length, jsonList.length);
    expect(result[0].name, personJohn.name);
    expect(result[1].age, personJane.age);
  });

  test('Test To JSONList Function', () {
    final result = mapper.toJSONList([personJohn, personJane]);
    expect(result.length, jsonList.length);
    expect(result[0], personJohnJson);
    expect(result[1], personJane.toJSON());
  });
}
