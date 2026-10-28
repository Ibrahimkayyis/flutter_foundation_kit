part of 'stepper.dart';

/// The state of a [NTIStep] which is used to control the style of the circle and
/// text.
///
/// See also:
///
///  * [NTIStep]
enum NTIStepState {
  /// A step that displays its index in its circle.
  indexed,

  /// A step that displays a pencil icon in its circle.
  editing,

  /// A step that displays a tick icon in its circle.
  complete,

  /// A step that is disabled and does not to react to taps.
  disabled,

  /// A step that is currently having an error. e.g. the user has submitted wrong
  /// input.
  error,
}
