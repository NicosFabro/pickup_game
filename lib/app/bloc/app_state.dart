part of 'app_bloc.dart';

enum AppStatus { authenticated, unauthenticated }

class AppState extends Equatable {
  const AppState._({
    required this.status,
    this.user = User.empty,
    this.profile = Profile.empty,
  });

  const AppState.authenticated(User user, {Profile profile = Profile.empty})
      : this._(status: AppStatus.authenticated, user: user, profile: profile);

  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);

  final AppStatus status;
  final User user;
  final Profile profile;

  @override
  List<Object> get props => [status, user, profile];
}
