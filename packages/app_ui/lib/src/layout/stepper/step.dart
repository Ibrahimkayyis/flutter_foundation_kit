part of 'stepper.dart';

class NTIStep {
  /// Creates a step for a [NTIStepper].
  ///
  /// The [title], [content], and [state] arguments must not be null.
  const NTIStep({
    this.title,
    this.activeIcon,
    this.inactiveIcon,
    required this.content,
    this.state = NTIStepState.indexed,
    this.isActive = false,
    this.label,
  });

  static NTIStep empty() {
    return NTIStep(content: (_, __) => const SizedBox());
  }

  /// The title of the step that typically describes it.
  final Widget? title;

  /// The icon of the step that appears inside circle step when step is == currentStep.
  ///
  /// If null, the icon is not shown.
  final Widget? activeIcon;

  /// The icon of the step that appears inside circle step when step != currentStep.
  ///
  /// If null, the icon is not shown.
  final Widget? inactiveIcon;

  /// The content of the step that appears below the [title] and [subtitle].
  ///
  /// Below the content, every step has a 'continue' and 'cancel' button.
  final Widget Function(
    BuildContext context,
    NTIStepperControlsDetails controlsDetails,
  )
  content;

  /// The state of the step which determines the styling of its components
  /// and whether steps are interactive.
  final NTIStepState state;

  /// Whether or not the step is active. The flag only influences styling.
  final bool isActive;

  /// Only [StepperType.horizontal], Optional widget that appears under the [title].
  /// By default, uses the `bodyText1` theme.
  final Widget? label;
}
