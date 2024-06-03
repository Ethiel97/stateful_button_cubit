import 'dart:math';

import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stateful_button/core/cubit/form_cubit.dart';
import 'package:flutter_stateful_button/core/cubit/form_state.dart';
import 'package:flutter_stateful_button/core/shared/value_wrapper.dart';
import 'package:flutter_stateful_button/core/ui/text_styles.dart';

class RegistrationSheet extends StatefulWidget {
  const RegistrationSheet({super.key});

  @override
  State<RegistrationSheet> createState() => _RegistrationSheetState();
}

class _RegistrationSheetState extends State<RegistrationSheet>
    with TickerProviderStateMixin {
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<FormCubit, FormState>(
        listener: (context, state) {
          print('state: $state');
          if ((state.buttonState.isFailed || state.buttonState.isInitial)) {
            animationController.forward();
          }
        },
        child: Material(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(32),
              topRight: Radius.circular(32),
            ),
          ),
          shadowColor: Colors.black26,
          elevation: 5.0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height / 2,
            ),
            padding: const EdgeInsets.symmetric(
              vertical: 32,
              horizontal: 24,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(32),
                topRight: Radius.circular(32),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Create account",
                  style: TextStyles.primary.copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                Text(
                  "You must agree to our terms to create a FlutterGigs account",
                  style: TextStyles.primary.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey.shade800,
                  ),
                ),
                const SizedBox(
                  height: 36,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        value: context.select((FormCubit cubit) =>
                            cubit.state.hasAcceptedAgreements),
                        onChanged: (_) {
                          context
                              .read<FormCubit>()
                              .toggleTermsAndConditionsCheckBox();
                        },
                        title: Text.rich(
                          TextSpan(
                            text: "I have read and agree to \nFlutterGigs' ",
                            style: TextStyles.primary.copyWith(
                              fontSize: 18,
                              color: Colors.blueGrey.shade700,
                            ),
                            children: [
                              TextSpan(
                                text: 'Terms of Service ',
                                style: TextStyles.primary.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const TextSpan(
                                text: 'and ',
                              ),
                              TextSpan(
                                text: 'Privacy policy',
                                style: TextStyles.primary.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        activeColor: Colors.green,
                        value: context.select(
                            (FormCubit cubit) => cubit.state.hasUnderstoodApp),
                        onChanged: (_) {
                          context
                              .read<FormCubit>()
                              .toggleAppUnderstandingCheckbox();
                        },
                        title: Text.rich(
                          style: TextStyles.primary.copyWith(
                            fontSize: 18,
                            color: Colors.blueGrey.shade700,
                          ),
                          const TextSpan(
                            text:
                                "I understand FlutterGigs is neither\na Job agency nor a job bank.",
                          ),
                        ),
                      ),
                      // const Spacer(),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child:
                      BlocSelector<FormCubit, FormState, ValueWrapper<String>>(
                    selector: (state) => state.buttonState,
                    builder: (context, state) => AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) => GestureDetector(
                        onTap: () {
                          context.read<FormCubit>().createAccount();
                        },
                        child: Transform.translate(
                          offset: Offset(
                              sin(animationController.value * pi * 5), 0),
                          child: Material(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(200),
                            ),
                            shadowColor: Colors.black26.withOpacity(.08),
                            elevation: 5,
                            child: AnimatedContainer(
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 36,
                              ),
                              height: 54,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(.1),
                                    offset: const Offset(0, 5),
                                    blurRadius: 10,
                                  ),
                                ],
                                color: context.select((FormCubit cubit) =>
                                    cubit.state.backgroundColor),
                                borderRadius: BorderRadius.circular(200),
                              ),
                              duration: const Duration(milliseconds: 400),
                              child: Row(
                                children: [
                                  context.select((FormCubit cubit) =>
                                      cubit.state.buttonIcon),
                                  const Spacer(),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 200),
                                    child: Text(
                                      state.value ?? '',
                                      key: ValueKey(state.value ?? ''),
                                      style: TextStyles.primary.copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
