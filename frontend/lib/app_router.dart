import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppRouter {
  // late final Dio _client;

  AppRouter() {
    // _client = DioClient().init();

    // final quicknodeApi = dotenv.get("QUICKNODE_URL");

    // Repositories
    // _walletSetupRepository = WalletSetupRepository();

    // Blocs / Cubits
    // _cryptoWalletCubit =
    //     CryptoWalletCubit(walletSetupRepository: _walletSetupRepository);
    // _walletCubit = WalletCubit(walletSetupRepository: _walletSetupRepository);
    // _appWalletCubit = AppWalletCubit(
    //   appWalletRepository: _appWalletRepository,
    // );
  }

  // Repo
  // late final IAppWalletRepository _appWalletRepository;
  // late final ICryptoRepository _cryptoRepository;

  // Blocs/Cubits
  // late final HomeCubit _homeCubit;
  // late final CryptoWalletCubit _cryptoWalletCubit;
  // late final WalletCubit _walletCubit;
  // late final AppWalletCubit _appWalletCubit;

  // late final AccountCubit _accountCubit;

  Route? onGenerateRoute(RouteSettings settings) {
    // var args;
    //
    // if (settings.arguments != null) {
    //   args = settings.arguments! as ScreenArguments;
    // }

    switch (settings.name) {
      case '/':
        // return MaterialPageRoute(builder: (_) => const SplashScreen());
        return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
      default:
        //return MaterialPageRoute(builder: (_) => const SplashScreen());
        return MaterialPageRoute(builder: (_) => const SizedBox.shrink());
    }
  }

  void dispose() {
    // Add code to dispose blocs/cubits here
    // NOTE: The dispose method is called in the app.dart or where this app_router is instantiated
    // _homeCubit.close();
  }
}
