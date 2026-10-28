import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_types/app_types.dart';
import 'package:app_bloc_wrapper/app_bloc_wrapper.dart';

class InitialUser extends Equatable {
  final String id;
  final String name;

  const InitialUser({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

class UserFormData extends Equatable {
  final String name;

  const UserFormData({required this.name});

  @override
  List<Object?> get props => [name];
}

class UserResult extends Equatable {
  final String id;
  final String name;

  const UserResult({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

abstract class UserFormService {
  Future<Resource<InitialUser>> prepareUser();
  Future<Resource<UserResult>> submitUser(UserFormData data);
}

class MockUserFormService extends Mock implements UserFormService {}

class TestUserFormCubit extends FormCubit<InitialUser, UserFormData, UserResult> {
  final UserFormService _service;
  final bool withPrepare;

  TestUserFormCubit(this._service, {this.withPrepare = true});

  @override
  Future<Resource<InitialUser>>? prepareUsecase() {
    if (!withPrepare) return null;
    return _service.prepareUser();
  }

  @override
  Future<Resource<UserResult>> submitUsecase(UserFormData data) =>
      _service.submitUser(data);
}

void main() {
  const initialUser = InitialUser(id: '1', name: 'John Doe');
  const formData = UserFormData(name: 'John Updated');
  const resultData = UserResult(id: '1', name: 'John Updated');
  const submitMessage = 'Saved successfully';

  late MockUserFormService service;

  setUp(() {
    service = MockUserFormService();
  });

  group('FormCubit Tests', () {
    blocTest<TestUserFormCubit, FormCubitState<InitialUser, UserResult>>(
      'emits [Preparing, Ready] when prepare succeeds',
      build: () {
        when(() => service.prepareUser())
            .thenAnswer((_) async => const Success(initialUser, 'Ready'));
        return TestUserFormCubit(service);
      },
      act: (cubit) => cubit.prepare(),
      expect: () => [
        isA<FormCubitPreparing<InitialUser, UserResult>>(),
        isA<FormCubitReady<InitialUser, UserResult>>()
            .having((s) => s.initialData, 'initialData', initialUser),
      ],
    );

    blocTest<TestUserFormCubit, FormCubitState<InitialUser, UserResult>>(
      'emits [Preparing, Ready(null)] when prepareUsecase returns null',
      build: () => TestUserFormCubit(service, withPrepare: false),
      act: (cubit) => cubit.prepare(),
      expect: () => [
        isA<FormCubitPreparing<InitialUser, UserResult>>(),
        isA<FormCubitReady<InitialUser, UserResult>>()
            .having((s) => s.initialData, 'initialData', isNull),
      ],
    );

    blocTest<TestUserFormCubit, FormCubitState<InitialUser, UserResult>>(
      'emits [Preparing, PrepareError] when prepare fails',
      build: () {
        when(() => service.prepareUser()).thenAnswer(
          (_) async => const Error(BaseException('Prepare failed')),
        );
        return TestUserFormCubit(service);
      },
      act: (cubit) => cubit.prepare(),
      expect: () => [
        isA<FormCubitPreparing<InitialUser, UserResult>>(),
        isA<FormCubitPrepareError<InitialUser, UserResult>>()
            .having((s) => s.exception.message, 'message', 'Prepare failed'),
      ],
    );

    blocTest<TestUserFormCubit, FormCubitState<InitialUser, UserResult>>(
      'emits [Submitting, SubmitSuccess] when submit succeeds',
      build: () {
        when(() => service.submitUser(formData)).thenAnswer(
          (_) async => const Success(resultData, submitMessage),
        );
        return TestUserFormCubit(service);
      },
      seed: () => FormCubitReady(initialData: initialUser),
      act: (cubit) => cubit.submit(formData),
      expect: () => [
        isA<FormCubitSubmitting<InitialUser, UserResult>>(),
        isA<FormCubitSubmitSuccess<InitialUser, UserResult>>()
            .having((s) => s.resultData, 'resultData', resultData)
            .having((s) => s.message, 'message', submitMessage),
      ],
    );

    blocTest<TestUserFormCubit, FormCubitState<InitialUser, UserResult>>(
      'emits [Submitting, SubmitError] with flattenError when FormException occurs',
      build: () {
        const formException = FormException('Validation error', {
          'name': ['Name is required'],
        });
        when(() => service.submitUser(formData))
            .thenAnswer((_) async => const Error(formException));
        return TestUserFormCubit(service);
      },
      seed: () => FormCubitReady(initialData: initialUser),
      act: (cubit) => cubit.submit(formData),
      expect: () => [
        isA<FormCubitSubmitting<InitialUser, UserResult>>(),
        isA<FormCubitSubmitError<InitialUser, UserResult>>()
            .having((s) => s.errors['name'], 'name error', 'Name is required'),
      ],
    );
  });
}
