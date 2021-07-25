import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ProfileEntity extends Equatable {
  const ProfileEntity(
    this.id,
    this.nickname,
    this.availableTeams,
  );

  final String id;
  final String nickname;
  final List<String> availableTeams;

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'availableTeams': availableTeams,
      };

  static ProfileEntity fromJson(Map<String, dynamic> json) => ProfileEntity(
        json['id'] as String,
        json['nickname'] as String,
        json['availableTeams'] as List<String>,
      );

  static ProfileEntity fromSnapshot(DocumentSnapshot snap) => ProfileEntity(
        snap.get('id'),
        snap.get('nickname'),
        (snap.get('availableTeams') as List<dynamic>).cast<String>(),
      );

  Map<String, dynamic> toDocument() => {
        'id': id,
        'nickname': nickname,
        'availableTeams': availableTeams,
      };

  @override
  List<Object?> get props => [id, nickname, availableTeams];
}
