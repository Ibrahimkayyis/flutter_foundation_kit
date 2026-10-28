part of 'stepper.dart';

class NTIStepperControlsDetails {
  /// Creates a set of details describing the Stepper.
  const NTIStepperControlsDetails({
    required this.currentStep,
    required this.stepIndex,
    this.onStepBack,
    this.onStepNext,
  });

  /// Index that is active for the surrounding [Stepper] widget. This may be
  /// different from [stepIndex] if the user has just changed steps and we are
  /// currently animating toward that step.
  final int currentStep;

  /// Index of the step for which these controls are being built. This is
  /// not necessarily the active index, if the user has just changed steps and
  /// this step is animating away.
  final int stepIndex;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'Next' button will be disabled.
  final VoidCallback? onStepNext;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'Back' button will be disabled.
  final VoidCallback? onStepBack;
}
