import 'package:flutter/material.dart';
import 'package:app_ui/src/style/styles.dart';

part 'controls_details.dart';
part 'step.dart';
part 'step_state.dart';
part 'stepper_guard.dart';

const TextStyle _stepStyle = TextStyle(fontSize: 12.0, color: Colors.white);
const Color _errorLight = Colors.red;
const Color _disabledLight = Colors.black38;
const double _stepSize = 24.0;
const double _triangleHeight =
    _stepSize * 0.866025; // Triangle height. sqrt(3.0) / 2.0
typedef CustomStepperPageBuilder =
    Widget Function(
      Widget currentContent,
      Widget stepper,
      BuildContext context,
      NTIStepperControlsDetails controlsDetails,
    );

class NTIStepper extends StatefulWidget {
  /// Creates a stepper from a list of steps.
  ///
  /// This widget is not meant to be rebuilt with a different list of steps
  /// unless a key is provided in order to distinguish the old stepper from the
  /// new one.
  ///
  /// The [steps] and [currentStep] arguments must not be null.
  const NTIStepper({
    super.key,
    required this.steps,
    this.physics,
    required this.currentStep,
    this.onStepTapped,
    this.onStepNext,
    this.onStepBack,
    this.hideStepDefaultNumber = false,
    required this.builder,
    this.lastPage,
  });

  /// The steps of the stepper whose titles, icons always get shown.
  ///
  /// The length of [steps] must not change.
  final List<NTIStep> steps;

  /// Wheter you want to show number indicator inside the stepper
  ///
  ///
  final bool hideStepDefaultNumber;

  /// How the stepper's scroll view should respond to user input.
  ///
  /// For example, determines how the scroll view continues to
  /// animate after the user stops dragging the scroll view.
  ///
  /// If the stepper is contained within another scrollable it
  /// can be helpful to set this property to [ClampingScrollPhysics].
  final ScrollPhysics? physics;

  /// The index into [steps] of the current step whose content is displayed.
  final int currentStep;

  /// The callback called when a step is tapped, with its index passed as
  /// an argument.
  final ValueChanged<int>? onStepTapped;

  /// The callback called when the 'continue' button is tapped.
  ///
  /// If null, the 'continue' button will be disabled.
  final VoidCallback? onStepNext;

  /// The callback called when the 'cancel' button is tapped.
  ///
  /// If null, the 'cancel' button will be disabled.
  final VoidCallback? onStepBack;

  /// The callback for creating custom builder.
  ///
  /// If null, the default stepper from  will be used.
  ///
  /// This callback which takes in 4 parameters.
  /// a context,
  /// currentContent which is a content with current index,
  /// stepper which is stepper widget
  /// and a [NTIStepperControlsDetails] object, which contains step information and two functions: [onStepNext] and [onStepBack].
  /// These can be used to control the stepper. For example, reading the
  /// [NTIStepperControlsDetails.currentStep] value within the callback can change the text
  /// of the continue or cancel button depending on which step users are at.
  ///
  ///   /// Creates a stepper with custom builder.
  ///
  /// ```dart
  /// Widget build(BuildContext context) {
  ///   return NTIStepper(
  ///      customBuilder: (currentContent, stepper, context, controlsDetails) {
  ///        final isLastStep = _activeStepIndex == stepList().length - 1;
  ///        final control = controlsDetails;
  ///
  ///        return Column(
  ///          children: [
  ///            const Text('Stepper Widget Example'),
  ///            stepper,
  ///            const SizedBox(height: 30),
  ///            currentContent,
  ///            Row(
  ///              children: [
  ///                Expanded(
  ///                  child: ElevatedButton(
  ///                    onPressed: control.onStepNext,
  ///                    child: (isLastStep)
  ///                        ? const Text('Submit')
  ///                        : const Text('Next'),
  ///                  ),
  ///                ),
  ///                const SizedBox(
  ///                  width: 10,
  ///                ),
  ///                if (_activeStepIndex > 0)
  ///                  Expanded(
  ///                    child: ElevatedButton(
  ///                      onPressed: control.onStepBack,
  ///                      child: const Text('Back'),
  ///                    ),
  ///                  )
  ///              ],
  ///            ),
  ///          ],
  ///        );
  ///      },
  ///     steps: const <NTIStep>[
  ///       NTIStep(
  ///         title: Text('A'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///       NTIStep(
  ///         title: Text('B'),
  ///         content: SizedBox(
  ///           width: 100.0,
  ///           height: 100.0,
  ///         ),
  ///       ),
  ///     ],
  ///   );
  /// }
  /// ```
  final CustomStepperPageBuilder builder;

  /// Last Page that will be rendered
  ///
  final Widget? lastPage;

  @override
  State<NTIStepper> createState() => _NTIStepperState();
}

class _NTIStepperState extends State<NTIStepper> with TickerProviderStateMixin {
  final Map<int, NTIStepState> _oldStates = <int, NTIStepState>{};
  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.steps.length; i += 1) {
      _oldStates[i] = widget.steps[i].state;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (firstTime) {
      NTIStepperScope.maybeOf(context)?._setDetail(_controlsDetails);
      firstTime = false;
    }
  }

  @override
  void didUpdateWidget(NTIStepper oldWidget) {
    super.didUpdateWidget(oldWidget);
    assert(widget.steps.length == oldWidget.steps.length);
    NTIStepperScope.maybeOf(context)?._setDetail(_controlsDetails);
    for (int i = 0; i < oldWidget.steps.length; i += 1) {
      _oldStates[i] = oldWidget.steps[i].state;
    }
  }

  bool _hasLabel() {
    for (final NTIStep step in widget.steps) {
      if (step.label != null) {
        return true;
      }
    }
    return false;
  }

  Color _circleColor(int index) {
    final colorTheme = context.colorTheme;
    Color color;
    if (widget.currentStep == index) {
      color = colorTheme.accent6Reverse;
    } else if (widget.currentStep > index) {
      color = colorTheme.brandAccent10Reverse;
    } else {
      color = colorTheme.basic4Reverse;
    }
    return color;
  }

  Color _borderColor(int index) {
    final colorTheme = context.colorTheme;
    Color color;
    if (widget.currentStep == index || widget.currentStep > index) {
      color = colorTheme.brandAccent10Reverse;
    } else {
      color = colorTheme.basic4Reverse;
    }
    return color;
  }

  Widget _buildCircle(int index, bool oldState) {
    return SizedBox(
      width: 24,
      height: 24,
      child: AnimatedContainer(
        curve: Curves.fastOutSlowIn,
        duration: kThemeAnimationDuration,
        decoration: BoxDecoration(
          color: _circleColor(index),
          shape: BoxShape.circle,
          border: Border.all(color: _borderColor(index), width: 2),
        ),
        child: Center(
          child: _buildCircleChild(
            index,
            oldState && widget.steps[index].state == NTIStepState.error,
          ),
        ),
      ),
    );
  }

  Widget _buildCircleChild(int index, bool oldState) {
    final NTIStepState state =
        oldState ? _oldStates[index]! : widget.steps[index].state;
    final activeIcon = widget.steps[index].activeIcon;
    final inactiveIcon = widget.steps[index].inactiveIcon;

    switch (state) {
      case NTIStepState.indexed:
      case NTIStepState.disabled:
        return widget.hideStepDefaultNumber
            ? const SizedBox()
            : Text('${index + 1}', style: _stepStyle);
      case NTIStepState.editing:
        return activeIcon ?? const SizedBox();
      case NTIStepState.complete:
        return inactiveIcon ?? const SizedBox();
      case NTIStepState.error:
        return const Text('!', style: _stepStyle);
    }
  }

  Widget _buildTriangle(int index, bool oldState) {
    return SizedBox(
      width: _stepSize,
      height: _stepSize,
      child: Center(
        child: SizedBox(
          width: _stepSize,
          height:
              _triangleHeight, // Height of 24dp-long-sided equilateral triangle.
          child: CustomPaint(
            painter: _TrianglePainter(color: _errorLight),
            child: Align(
              alignment: const Alignment(
                0.0,
                0.8,
              ), // 0.8 looks better than the geometrical 0.33.
              child: _buildCircleChild(
                index,
                oldState && widget.steps[index].state != NTIStepState.error,
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool _isLast(int index) {
    return widget.steps.length - 1 == index;
  }

  Widget _buildIcon(int index) {
    if (widget.steps[index].state != _oldStates[index]) {
      return AnimatedCrossFade(
        firstChild: _buildCircle(index, true),
        secondChild: _buildTriangle(index, true),
        firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
        secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
        sizeCurve: Curves.fastOutSlowIn,
        crossFadeState:
            widget.steps[index].state == NTIStepState.error
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
        duration: kThemeAnimationDuration,
      );
    } else {
      if (widget.steps[index].state != NTIStepState.error) {
        return _buildCircle(index, false);
      } else {
        return _buildTriangle(index, false);
      }
    }
  }

  TextStyle _labelStyle(int index) {
    final textTheme = context.text;
    switch (widget.steps[index].state) {
      case NTIStepState.indexed:
      case NTIStepState.editing:
      case NTIStepState.complete:
        return textTheme.sm;
      case NTIStepState.disabled:
        return textTheme.sm.copyWith(color: _disabledLight);
      case NTIStepState.error:
        return textTheme.sm.copyWith(color: _errorLight);
    }
  }

  Widget _buildLabelText(int index) {
    if (widget.steps[index].label != null) {
      return AnimatedDefaultTextStyle(
        style: _labelStyle(index),
        duration: kThemeAnimationDuration,
        child: widget.steps[index].label!,
      );
    }
    return const SizedBox();
  }

  List<Widget> _buildPannels(NTIStepperControlsDetails controller) {
    final List<Widget> stepPanels = <Widget>[];
    for (int i = 0; i < widget.steps.length; i += 1) {
      stepPanels.add(
        Builder(
          builder: (context) {
            if (i > widget.currentStep) return const SizedBox();
            return Visibility(
              maintainState: true,
              visible: i == widget.currentStep,
              child: widget.steps[i].content(context, controller),
            );
          },
        ),
      );
    }
    return stepPanels;
  }

  List<Widget> _buildStepperWidget() {
    return <Widget>[
      for (int i = 0; i < widget.steps.length; i += 1) ...<Widget>[
        InkResponse(
          onTap:
              widget.steps[i].state != NTIStepState.disabled
                  ? () {
                    widget.onStepTapped?.call(i);
                  }
                  : null,
          canRequestFocus: widget.steps[i].state != NTIStepState.disabled,
          child: Row(
            children: <Widget>[
              SizedBox(
                height: _hasLabel() ? 104.0 : 72.0,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (widget.steps[i].label != null)
                      const SizedBox(height: 24.0),
                    Center(child: _buildIcon(i)),
                    if (widget.steps[i].label != null)
                      SizedBox(height: 24.0, child: _buildLabelText(i)),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!_isLast(i))
          Expanded(
            child: Container(
              height: 1.0,
              color:
                  widget.currentStep > i
                      ? context.colorTheme.brandAccent10Reverse
                      : context.colorTheme.basic4Reverse,
            ),
          ),
      ],
    ];
  }

  NTIStepperControlsDetails get _controlsDetails => NTIStepperControlsDetails(
    currentStep: widget.currentStep,
    onStepNext: widget.onStepNext,
    onStepBack: widget.onStepBack,
    stepIndex: widget.currentStep,
  );

  bool get isLastPage => widget.currentStep >= widget.steps.length;

  @override
  Widget build(BuildContext context) {
    final List<Widget> stepPanels = _buildPannels(_controlsDetails);
    final List<Widget> children = _buildStepperWidget();
    return widget.builder(
      isLastPage && widget.lastPage != null
          ? widget.lastPage!
          : Stack(children: stepPanels),
      Row(children: children),
      context,
      _controlsDetails,
    );
  }
}

class _TrianglePainter extends CustomPainter {
  _TrianglePainter({required this.color});

  final Color color;

  @override
  bool hitTest(Offset point) => true; // Hitting the rectangle is fine enough.

  @override
  bool shouldRepaint(_TrianglePainter oldPainter) {
    return oldPainter.color != color;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double base = size.width;
    final double halfBase = size.width / 2.0;
    final double height = size.height;
    final List<Offset> points = <Offset>[
      Offset(0.0, height),
      Offset(base, height),
      Offset(halfBase, 0.0),
    ];

    canvas.drawPath(Path()..addPolygon(points, true), Paint()..color = color);
  }
}
