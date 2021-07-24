// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Packages
import 'package:auth_repository/auth_repository.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:field_repository/field_repository.dart';
import 'package:game_repository/game_repository.dart';

// App
import 'package:pickup_game/app/bloc/app_bloc.dart';

// Home
import 'package:pickup_game/home/views/home_page.dart';

// Login
import 'package:pickup_game/login/views/login_page.dart';

// l10n
import 'package:pickup_game/l10n/l10n.dart';

class App extends StatelessWidget {
  const App({
    Key? key,
    required AuthRepository authRepository,
    required ProfileRepository profileRepository,
    required FieldRepository fieldRepository,
    required GameRepository gameRepository,
  })  : _authRepository = authRepository,
        _profileRepository = profileRepository,
        _fieldRepository = fieldRepository,
        _gameRepository = gameRepository,
        super(key: key);

  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;
  final FieldRepository _fieldRepository;
  final GameRepository _gameRepository;

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: _authRepository),
        RepositoryProvider.value(value: _profileRepository),
        RepositoryProvider.value(value: _fieldRepository),
        RepositoryProvider.value(value: _gameRepository),
      ],
      child: BlocProvider<AppBloc>(
        create: (_) => AppBloc(
          authRepository: _authRepository,
          profileRepository: _profileRepository,
        ),
        child: const AppView(),
      ),
    );
  }
}

class AppView extends StatelessWidget {
  const AppView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: context.read<AppBloc>().state.status == AppStatus.authenticated
          ? const HomePage()
          : const LoginPage(),
    );
  }
}
