import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:app_types/app_types.dart';
import 'package:app_bloc_wrapper/app_bloc_wrapper.dart';

class TestData extends Equatable {
  final String id;
  final String name;

  const TestData({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}

abstract class TestRepository {
  Future<Resource<TestData>> getData();
  Future<Resource<TestData>> getDataWithParams(String id);
}

class MockTestRepository extends Mock implements TestRepository {}

class TestGetDataCubit extends GetDataCubit<TestData> {
  final TestRepository _repository;

  TestGetDataCubit(this._repository);

  @override
  Future<Resource<TestData>> usecaseCall() => _repository.getData();
}

class TestGetDataCubitWithParams
    extends GetDataCubitWithParams<TestData, String> {
  final TestRepository _repository;

  TestGetDataCubitWithParams(this._repository);

  @override
  Future<Resource<TestData>> usecaseCall(String params) =>
      _repository.getDataWithParams(params);
}

void main() {
  const successData = TestData(id: '1', name: 'Test User');
  const successMessage = 'SUCCESS';
  const successResource = Success(successData, successMessage);

  const errorException = BaseException('Network error');
  const errorResource = Error<TestData>(errorException);

  const refreshData = TestData(id: '2', name: 'Refreshed User');
  const refreshResource = Success(refreshData, successMessage);

  late MockTestRepository repository;

  setUp(() {
    repository = MockTestRepository();
  });

  group('GetDataCubit Tests', () {
    blocTest<TestGetDataCubit, CubitState<TestData>>(
      'emits [Loading, Success] when loadData succeeds',
      build: () {
        when(() => repository.getData()).thenAnswer((_) async => successResource);
        return TestGetDataCubit(repository);
      },
      act: (cubit) => cubit.loadData(),
      expect: () => [
        isA<CubitLoadingState<TestData>>(),
        isA<CubitSuccessState<TestData>>()
            .having((s) => s.data, 'data', successData)
            .having((s) => s.message, 'message', successMessage)
            .having((s) => s.isRefreshing, 'isRefreshing', false),
      ],
    );

    blocTest<TestGetDataCubit, CubitState<TestData>>(
      'emits [Loading, Error] when loadData fails',
      build: () {
        when(() => repository.getData()).thenAnswer((_) async => errorResource);
        return TestGetDataCubit(repository);
      },
      act: (cubit) => cubit.loadData(),
      expect: () => [
        isA<CubitLoadingState<TestData>>(),
        isA<CubitErrorState<TestData>>()
            .having((s) => s.exception.message, 'message', 'Network error'),
      ],
    );

    blocTest<TestGetDataCubit, CubitState<TestData>>(
      'handles refresh (isSilent: false) with toggleRefresh correctly',
      build: () {
        when(() => repository.getData()).thenAnswer((_) async => refreshResource);
        return TestGetDataCubit(repository);
      },
      seed: () => const CubitSuccessState(
        data: successData,
        message: successMessage,
      ),
      act: (cubit) async => await cubit.refresh(isSilent: false),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<CubitSuccessState<TestData>>()
            .having((s) => s.isRefreshing, 'isRefreshing', true),
        isA<CubitSuccessState<TestData>>()
            .having((s) => s.isRefreshing, 'isRefreshing', false)
            .having((s) => s.data, 'data', refreshData),
      ],
    );

    blocTest<TestGetDataCubit, CubitState<TestData>>(
      'handles refresh (isSilent: true) by emitting new data directly',
      build: () {
        when(() => repository.getData()).thenAnswer((_) async => refreshResource);
        return TestGetDataCubit(repository);
      },
      seed: () => const CubitSuccessState(
        data: successData,
        message: successMessage,
      ),
      act: (cubit) async => await cubit.refresh(isSilent: true),
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<CubitSuccessState<TestData>>()
            .having((s) => s.isRefreshing, 'isRefreshing', false)
            .having((s) => s.data, 'data', refreshData),
      ],
    );
  });

  group('GetDataCubitWithParams Tests', () {
    blocTest<TestGetDataCubitWithParams, CubitWithParamsState<TestData, String>>(
      'emits [Loading, Success] with params when loadData succeeds',
      build: () {
        when(() => repository.getDataWithParams('123'))
            .thenAnswer((_) async => successResource);
        return TestGetDataCubitWithParams(repository);
      },
      act: (cubit) => cubit.loadData('123'),
      expect: () => [
        isA<CubitLoadingState<GetDataCubitWithParamsData<TestData, String>>>(),
        isA<CubitSuccessState<GetDataCubitWithParamsData<TestData, String>>>()
            .having((s) => s.data.data, 'data', successData)
            .having((s) => s.data.params, 'params', '123'),
      ],
    );
  });
}
