import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_bloc_wrapper/nti_bloc_wrapper.dart';
import 'package:app_ui/nti_ui.dart';
import 'package:app_ui/test_helper.dart';
import 'package:app_types/types.dart';

void main() {
  testWidgets('Listen to cubit', (WidgetTester tester) async {
    final cubit = _GetNameCubit();
    await tester.pumpWidget(
      TestHelper.buildTestableWidget(
        BlocProvider(
          create: (context) => cubit,
          child: Builder(
            builder: (context) {
              final cubit = context.read<_GetNameCubit>();
              return NTILoadingContainer(
                isLoadingStream: cubit.stream.map(
                  (state) =>
                      state is _GetNameCubitLoading ||
                      (state is _GetNameCubitSuccess && state.isRefreshing),
                ),
                child: BlocBuilder<_GetNameCubit, _GetNameCubitState>(
                  builder: (context, state) {
                    return switch (state) {
                      _GetNameCubitLoading() => const Text('Loading'),
                      _GetNameCubitSuccess() => const Text('Success'),
                      _GetNameCubitError() => const Text('Error'),
                    };
                  },
                ),
              );
            },
          ),
        ),
      ),
    );

    cubit.loading();

    // Rebuild the widget after the state has changed
    await tester.pump();

    // Verify that the loading overlay is displayed
    expect(cubit.state, isA<_GetNameCubitLoading>());
    expect(find.byType(NTILoadingOverlay), findsOneWidget);
    expect(find.text('Loading'), findsOneWidget);

    cubit.stopLoad();
    await tester.pump();
    expect(cubit.state, isA<_GetNameCubitSuccess>());
    expect(find.byType(NTILoadingOverlay), findsNothing);
    expect(find.text('Success'), findsOneWidget);
  });
}

class _GetNameCubit extends GetDataCubit<String> {
  @override
  Future<Resource<String>> usecaseCall() {
    return Future.delayed(
      const Duration(seconds: 1),
      () => Resource.success('John Doe', 'GET_NAME_SUCCESS'),
    );
  }

  void loading() {
    emit(const CubitLoadingState<String>());
  }

  void stopLoad() {
    emit(
      const CubitSuccessState<String>(
        data: 'John Doe',
        message: 'GET_NAME_SUCCESS',
        isRefreshing: false,
      ),
    );
  }

  void fakeRefresh() {
    emit(
      const CubitSuccessState<String>(
        data: 'John Doe',
        message: 'GET_NAME_SUCCESS',
        isRefreshing: true,
      ),
    );
  }
}

typedef _GetNameCubitState = CubitState<String>;
typedef _GetNameCubitError = CubitErrorState<String>;
typedef _GetNameCubitLoading = CubitLoadingState<String>;
typedef _GetNameCubitSuccess = CubitSuccessState<String>;
