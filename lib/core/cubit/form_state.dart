import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stateful_button/core/shared/status.dart';
import 'package:flutter_stateful_button/core/shared/value_wrapper.dart';

class FormState extends Equatable {
  final ValueWrapper<String> buttonState;

  final bool hasAcceptedAgreements;
  final bool hasUnderstoodApp;

  const FormState({
    this.buttonState = const ValueWrapper(value: 'Create account'),
    this.hasAcceptedAgreements = false,
    this.hasUnderstoodApp = false,
  });

  @override
  List<Object?> get props => [
        buttonState,
        hasUnderstoodApp,
        hasAcceptedAgreements,
      ];

  FormState copyWith({
    ValueWrapper<String>? buttonState,
    bool? hasAcceptedAgreements,
    bool? hasUnderstoodApp,
  }) =>
      FormState(
        buttonState: buttonState ?? this.buttonState,
        hasAcceptedAgreements:
            hasAcceptedAgreements ?? this.hasAcceptedAgreements,
        hasUnderstoodApp: hasUnderstoodApp ?? this.hasUnderstoodApp,
      );

  bool get hasCheckedAll => hasUnderstoodApp && hasAcceptedAgreements;

  Color get backgroundColor => switch (buttonState.status) {
        Status.failed => Colors.red,
        Status.success => Colors.green,
        _ => Colors.black,
      };

  Widget get buttonIcon => switch (buttonState.status) {
        Status.success => const Icon(
            Icons.check,
            color: Colors.white,
          ),
        Status.failed => const Icon(
            Icons.warning,
            color: Colors.white,
          ),
        Status.loading => const FittedBox(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
        _ => const SizedBox.shrink(),
      };

  @override
  String toString() {
    return "(buttonState => ${buttonState.value} is ${buttonState.status})";
  }
}
