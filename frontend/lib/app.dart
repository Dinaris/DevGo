import 'package:dev_go/screens/login_screen.dart';
import 'package:dev_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'cubits/login_cubit.dart';
import 'repositories/authentication_repository.dart';

class TokenGoApp extends StatelessWidget {
  const TokenGoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final AuthenticationRepository authRepository = AuthenticationRepository();

    return MaterialApp(
      theme: theme(),
      home: BlocProvider<LoginCubit>(
        create: (context) =>
            LoginCubit(authenticationRepository: authRepository),
        child: ResponsiveWrapper.builder(
          LoginScreen(),
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
