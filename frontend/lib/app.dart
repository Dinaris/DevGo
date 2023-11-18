import 'package:dev_go/screens/login_screen.dart';
import 'package:dev_go/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'app_router.dart';
import 'cubits/login_cubit.dart';
import 'repositories/authentication_repository.dart';
import 'screens/not_found_screen.dart';
import 'utils/navigation_service.dart';
import 'utils/size_config.dart';

class App extends StatelessWidget {
  App({
    Key? key,
    required this.authRepository,
  }) : super(key: key);

  final AuthenticationRepository authRepository;

  @override
  Widget build(BuildContext context) {
    //final _dioClient = DioClient().init();

    return MultiBlocProvider(
      // Add block providers here
      providers: [
        BlocProvider(
          create: (context) =>
              LoginCubit(authenticationRepository: authRepository),
        ),
      ],
      // Add repositories here
      child: MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => authRepository,
          ),
        ],
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  _AppViewState createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  final _navigatorKey = NavigationService.navigatorKey;
  late final _router;

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    _router = AppRouter();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      builder: (context, child) {
        SizeConfig().init(context);

        child = Overlay(initialEntries: [
          OverlayEntry(
            builder: (context) => LoginScreen(),
          )
        ]);

        // Set screen breakpoints to enable responsive layout
        child = ResponsiveWrapper.builder(
          child,
          maxWidth: 1200,
          minWidth: 480,
          defaultScale: true,
          breakpoints: [
            const ResponsiveBreakpoint.resize(480, name: MOBILE),
            const ResponsiveBreakpoint.autoScale(800, name: TABLET),
          ],
        );

        return child;
      },
      theme: theme(),
      onGenerateRoute: _router.onGenerateRoute,
      onUnknownRoute: (settings) => MaterialPageRoute(
          settings: settings, builder: (_) => const NotFoundScreen()),
      debugShowCheckedModeBanner: false,
    );
  }

  @override
  void dispose() {
    // Dispose blocs/cubits that are created in the router
    _router.dispose();
    super.dispose();
  }
}
