import 'package:flutter/material.dart' hide FormState;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_stateful_button/core/cubit/form_cubit.dart';
import 'package:flutter_stateful_button/core/shared/status.dart';
import 'package:flutter_stateful_button/widgets/registration_sheet.dart';

import 'core/cubit/form_state.dart';
import 'core/ui/text_styles.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => FormCubit(
            const FormState(),
          ),
        ),
      ],
      child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            textTheme: TextStyles.primaryTextTheme,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.deepPurple,
            ).copyWith(
              background: Colors.white70,
            ),
          ),
          home: const Scaffold(
            backgroundColor: Colors.white70,
            body: DemoPage(),
          )),
    );
  }
}

class DemoPage extends StatelessWidget {
  const DemoPage({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: BlocListener<FormCubit, FormState>(
          listener: (BuildContext context, FormState state) {
            if (state.hasUnderstoodApp &&
                state.hasAcceptedAgreements &&
                state.buttonState.isFailed) {
              context.read<FormCubit>().triggerChange(
                    value: 'Create account',
                    status: Status.initial,
                  );
            }
          },
          child: const Align(
            alignment: Alignment.bottomCenter,
            child: RegistrationSheet(),
          ),
        ),
      );
}
