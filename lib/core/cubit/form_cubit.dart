import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stateful_button/core/cubit/form_state.dart';
import 'package:flutter_stateful_button/core/shared/status.dart';

class FormCubit extends Cubit<FormState> {
  FormCubit(super.initialState);

  void triggerChange({
    String value = 'Create account',
    Status status = Status.initial,
  }) async =>
      switch (status) {
        Status.success => {
            emit(state.copyWith(
                buttonState: state.buttonState.toSuccess(value))),
            Future.delayed(
              const Duration(seconds: 6),
              () => reset(),
            ),
          },
        Status.loading =>
          emit(state.copyWith(buttonState: state.buttonState.toLoading(value))),
        Status.failed => emit(state.copyWith(
            buttonState: state.buttonState.toFailed(value: value))),
        _ =>
          emit(state.copyWith(buttonState: state.buttonState.toInitial(value))),
      };

  void createAccount() async {
    if (state.hasCheckedAll) {
      triggerChange(value: 'Creating...', status: Status.loading);

      await Future.delayed(const Duration(milliseconds: 2200));

      triggerChange(value: 'Account created', status: Status.success);
      HapticFeedback.mediumImpact();
    } else {
      triggerChange(value: 'Please agree', status: Status.failed);
      HapticFeedback.mediumImpact();
    }
  }

  reset() {
    emit(
      const FormState(),
    );
  }

  toggleTermsAndConditionsCheckBox() {
    emit(state.copyWith(hasAcceptedAgreements: !state.hasAcceptedAgreements));
  }

  toggleAppUnderstandingCheckbox() {
    emit(state.copyWith(hasUnderstoodApp: !state.hasUnderstoodApp));
  }
}
