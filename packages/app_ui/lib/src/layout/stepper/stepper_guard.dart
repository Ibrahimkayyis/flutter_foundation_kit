part of 'stepper.dart';

class NTIStepperGuard extends StatefulWidget {
  final Future<bool> Function(NTIStepperControlsDetails details)? onBack;
  final Widget child;
  const NTIStepperGuard({super.key, this.onBack, required this.child});

  @override
  State<NTIStepperGuard> createState() => _NTIStepperGuardState();
}

class _NTIStepperGuardState extends State<NTIStepperGuard> {
  NTIStepperControlsDetails? _details;

  @override
  Widget build(BuildContext context) {
    return NTIStepperScope(
      (value) {
        _details = value;
      },
      _details?.stepIndex ?? -1,
      // ignore: deprecated_member_use
      child: WillPopScope(
        onWillPop: () async {
          final detail = _details;
          if (detail == null) return true;
          final customBack = widget.onBack;
          if (customBack != null) return customBack(detail);
          if (detail.currentStep == 0) return true;
          detail.onStepBack?.call();
          return false;
        },
        child: widget.child,
      ),
    );
  }
}

class NTIStepperScope extends InheritedWidget {
  final int index;
  final ValueChanged<NTIStepperControlsDetails> _setDetail;

  const NTIStepperScope(
    this._setDetail,
    this.index, {
    super.key,
    required super.child,
  });

  static NTIStepperScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<NTIStepperScope>();

  @override
  bool updateShouldNotify(NTIStepperScope oldWidget) {
    return false;
  }
}
