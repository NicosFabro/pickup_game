import 'package:equatable/equatable.dart';

import 'package:profile_repository/profile_repository.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.nickname,
    required this.availableTeams,
  });

  final String id;
  final String nickname;
  final List<String> availableTeams;

  Profile copyWith({
    String? id,
    String? nickname,
    List<String>? availableTeams,
  }) {
    return Profile(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      availableTeams: availableTeams ?? this.availableTeams,
    );
  }

  static const empty = Profile(id: '', nickname: '', availableTeams: []);

  bool get isEmpty => this == Profile.empty;

  bool get isNotEmpty => this != Profile.empty;

  ProfileEntity toEntity() => ProfileEntity(id, nickname, availableTeams);

  static Profile fromEntity(ProfileEntity entity) => Profile(
        id: entity.id,
        nickname: entity.nickname,
        availableTeams: entity.availableTeams,
      );

  @override
  List<Object?> get props => [id, nickname, availableTeams];
}
