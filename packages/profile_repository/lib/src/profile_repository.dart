import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:profile_repository/profile_repository.dart';

class ProfileRepository {
  final profilesRepository = FirebaseFirestore.instance.collection('profiles');

  Future<Profile> getProfileById(String id) async {
    DocumentSnapshot documentSnapshot = await profilesRepository.doc(id).get();
    return Profile.fromEntity(ProfileEntity.fromSnapshot(documentSnapshot));
  }

  Future<void> editProfile(Profile profile) async {
    await profilesRepository
        .doc(profile.id)
        .update(profile.toEntity().toDocument());
  }
}
