// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

// Packages
import 'package:auth_repository/auth_repository.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:field_repository/field_repository.dart';
import 'package:game_repository/game_repository.dart';

// App
import 'package:pickup_game/app/app.dart';
import 'package:pickup_game/app/bloc_observer.dart';

void main() async {
  Bloc.observer = AppBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (details) {
    log(details.exceptionAsString(), stackTrace: details.stack);
  };

  final authRepository = AuthRepository();
  final profileRepository = ProfileRepository();
  final fieldRepository = FieldRepository();
  final gameRepository = GameRepository();

  await authRepository.user.first;

  runZonedGuarded(
    () => runApp(
      App(
        authRepository: authRepository,
        profileRepository: profileRepository,
        fieldRepository: fieldRepository,
        gameRepository: gameRepository,
      ),
    ),
    (error, stackTrace) => log(error.toString(), stackTrace: stackTrace),
  );
}
