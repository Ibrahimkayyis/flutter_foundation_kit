import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:app_types/app_types.dart';
import 'package:app_bloc_wrapper/app_bloc_wrapper.dart';
import 'package:app_ui/app_ui.dart';

void main() {
  runApp(const FoundationKitExampleApp());
}

class FoundationKitExampleApp extends StatelessWidget {
  const FoundationKitExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ColorThemeProvider(
      initialTheme: colorExample,
      child: Builder(
        builder: (context) {
          return MaterialApp(
            title: 'Flutter Foundation Kit Demo',
            debugShowCheckedModeBanner: false,
            builder: (context, child) {
              return TyphographyProvider(
                typhographyData: typhoGraphy(context),
                child: AppMessengerProvider(
                  child: child ?? const SizedBox(),
                ),
              );
            },
            home: const ExampleHomeScreen(),
          );
        },
      ),
    );
  }
}

class ExampleHomeScreen extends StatefulWidget {
  const ExampleHomeScreen({super.key});

  @override
  State<ExampleHomeScreen> createState() => _ExampleHomeScreenState();
}

class _ExampleHomeScreenState extends State<ExampleHomeScreen> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedRole = 'Developer';
  bool _agreed = false;
  String _experienceLevel = 'Senior';

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = context.text;
    final colors = context.colorTheme;

    return Scaffold(
      backgroundColor: colors.basic2Reverse,
      appBar: AppBar(
        title: Text(
          'Flutter Foundation Kit',
          style: text.lg.bold.applyColor(colors.basic12),
        ),
        backgroundColor: colors.basic1Reverse,
        elevation: 0.5,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Typography & Theme
            Text(
              '1. Design System & Typography',
              style: text.base.bold.applyColor(colors.primary10),
            ),
            const SizedBox(height: 8),
            Card(
              color: colors.basic1Reverse,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Heading Large (Bold)', style: text.xl.bold),
                    Text('Base Body Text (Normal)', style: text.base.normal),
                    Text('Small Subtitle (Medium)', style: text.sm.medium),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section 2: Form Inputs
            Text(
              '2. Universal Form Inputs',
              style: text.base.bold.applyColor(colors.primary10),
            ),
            const SizedBox(height: 8),
            Card(
              color: colors.basic1Reverse,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    AppTextField(
                      controller: _nameController,
                      title: 'Full Name',
                      hintText: 'Enter your name...',
                      prefixIcon: const AppIcon(AppIcons.user),
                    ),
                    const SizedBox(height: 12),
                    AppDropdown<String>(
                      title: 'Select Role',
                      items: const ['Developer', 'Designer', 'Product Manager'],
                      initialValue: _selectedRole,
                      onChange: (val) {
                        if (val != null) setState(() => _selectedRole = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    AppCheckbox(
                      label: 'I accept terms and conditions',
                      value: _agreed,
                      onChanged: (val) => setState(() => _agreed = val),
                    ),
                    const SizedBox(height: 12),
                    AppRadioButtonField<String>(
                      title: 'Experience Level',
                      options: const [
                        RadioModel(value: 'Junior', label: 'Junior (0-2 yrs)'),
                        RadioModel(value: 'Senior', label: 'Senior (3+ yrs)'),
                      ],
                      initialValue: _experienceLevel,
                      onChanged: (val) {
                        if (val != null) setState(() => _experienceLevel = val);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section 3: Buttons
            Text(
              '3. Button Variants',
              style: text.base.bold.applyColor(colors.primary10),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                AppDefaultButton(
                  text: 'Primary Button',
                  leftIcon: const AppIcon(AppIcons.checkCircle, color: Colors.white),
                  onPressed: () {
                    context.showSuccessSnackbar('Primary Button Clicked!');
                  },
                ),
                AppOutlinedButton(
                  text: 'Outlined Button',
                  onPressed: () {
                    context.showErrorSnackbar('Outlined Button Action!');
                  },
                ),
                AppRoundedButton(
                  text: 'Rounded Button',
                  onPressed: () {
                    context.showSuccessDialog(
                      title: 'Foundation Kit Dialog',
                      message: 'This is an AppMessenger dialog example.',
                    );
                  },
                ),
                AppLinkButton(
                  text: 'Open Bottom Sheet',
                  onPressed: () {
                    AppBottomSheet.launchDraggable(
                      context,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          'Hello from AppBottomSheet!',
                          style: text.base.medium,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Section 4: Cubit / BLoC State Management Demo
            Text(
              '4. State Management with GetDataCubit',
              style: text.base.bold.applyColor(colors.primary10),
            ),
            const SizedBox(height: 8),
            BlocProvider(
              create: (_) => _DemoGreetingCubit()..loadData(),
              child: Card(
                color: colors.basic1Reverse,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<_DemoGreetingCubit, CubitState<String>>(
                    builder: (context, state) {
                      return switch (state) {
                        CubitLoadingState() => const Center(
                            child: CircularProgressIndicator(),
                          ),
                        CubitSuccessState(:final data) => Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(data, style: text.base.medium),
                              AppOutlinedButton(
                                text: 'Refresh',
                                buttonSize: ButtonSize.small,
                                onPressed: () =>
                                    context.read<_DemoGreetingCubit>().refresh(),
                              ),
                            ],
                          ),
                        CubitErrorState(:final exception) => Text(
                            'Error: ${exception.message}',
                            style: text.sm.applyColor(colors.accent12Reverse),
                          ),
                      };
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _DemoGreetingCubit extends GetDataCubit<String> {
  @override
  Future<Resource<String>> usecaseCall() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return Resource.success(
      'Welcome to Flutter Foundation Kit!',
      'GREETING_LOADED',
    );
  }
}
