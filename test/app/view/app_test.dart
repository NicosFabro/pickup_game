// Copyright (c) 2021, Very Good Ventures
// https://verygood.ventures
//
// Use of this source code is governed by an MIT-style
// license that can be found in the LICENSE file or at
// https://opensource.org/licenses/MIT.

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';

import 'package:pickup_game/app/view/app.dart';
import 'package:pickup_game/app/bloc/app_bloc.dart';
import 'package:pickup_game/home/views/home_page.dart';
import 'package:pickup_game/login/views/login_page.dart';

import 'package:auth_repository/auth_repository.dart';
import 'package:profile_repository/profile_repository.dart';
import 'package:field_repository/field_repository.dart';
import 'package:game_repository/game_repository.dart';

class MockUser extends Mock implements User {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockProfileRepository extends Mock implements ProfileRepository {}

class MockFieldRepository extends Mock implements FieldRepository {}

class MockGameRepository extends Mock implements GameRepository {}

class MockAppBloc extends MockBloc<AppEvent, AppState> implements AppBloc {}

class FakeAppEvent extends Fake implements AppEvent {}

class FakeAppState extends Fake implements AppState {}

void main() {
  group('App', () {
    late MockGoogleSignIn googleSignIn;

    setUp(() {
      googleSignIn = MockGoogleSignIn();
    });

    test('should return idToken and accessToken when authenticating', () async {
      final signInAccount = await googleSignIn.signIn();
      final signInAuthentication = await signInAccount!.authentication;
      expect(signInAuthentication, isNotNull);
      expect(googleSignIn.currentUser, isNotNull);
      expect(signInAuthentication.accessToken, isNotNull);
      expect(signInAuthentication.idToken, isNotNull);
    });

    test('should return null when google login is cancelled by the user',
        () async {
      googleSignIn.setIsCancelled(true);
      final signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
    });

    test('should return null when cancelled and not null when not cancelled',
        () async {
      googleSignIn.setIsCancelled(true);
      final signInAccount = await googleSignIn.signIn();
      expect(signInAccount, isNull);
      googleSignIn.setIsCancelled(false);
      final signInAccountSecondAttempt = await googleSignIn.signIn();
      expect(signInAccountSecondAttempt, isNotNull);
    });
  });

  group('AppView', () {
    late AuthRepository authRepository;
    late ProfileRepository profileRepository;
    late FieldRepository fieldRepository;
    late GameRepository gameRepository;

    late AppBloc appBloc;

    setUpAll(() {
      registerFallbackValue<AppEvent>(FakeAppEvent());
      registerFallbackValue<AppState>(FakeAppState());
    });

    setUp(() {
      authRepository = MockAuthRepository();
      profileRepository = MockProfileRepository();
      fieldRepository = MockFieldRepository();
      gameRepository = MockGameRepository();

      appBloc = MockAppBloc();
    });

    testWidgets('navigates to LoginPage when unauthenticated', (tester) async {
      when(() => appBloc.state).thenReturn(const AppState.unauthenticated());
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authRepository),
            RepositoryProvider.value(value: profileRepository),
            RepositoryProvider.value(value: fieldRepository),
            RepositoryProvider.value(value: gameRepository),
          ],
          child: BlocProvider.value(value: appBloc, child: const AppView()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(LoginPage), findsOneWidget);
    });

    testWidgets('navigates to HomePage when authenticated', (tester) async {
      final user = MockUser();
      when(() => user.email).thenReturn('test@gmail.com');
      when(() => appBloc.state).thenReturn(AppState.authenticated(user));
      await tester.pumpWidget(
        MultiRepositoryProvider(
          providers: [
            RepositoryProvider.value(value: authRepository),
            RepositoryProvider.value(value: profileRepository),
            RepositoryProvider.value(value: fieldRepository),
            RepositoryProvider.value(value: gameRepository),
          ],
          child: BlocProvider.value(value: appBloc, child: const AppView()),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
