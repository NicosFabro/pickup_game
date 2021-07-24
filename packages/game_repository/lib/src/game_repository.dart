import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:game_repository/game_repository.dart';

class GameRepository {
  final gamesCollection = FirebaseFirestore.instance.collection('games');

  Stream<List<Game>> getGames() {
    return gamesCollection.snapshots().map((snapshot) => snapshot.docs
        .map((doc) => Game.fromEntity(GameEntity.fromSnapshot(doc)))
        .toList());
  }

  Future<Game> getGameById(String id) async {
    DocumentSnapshot documentSnapshot = await gamesCollection.doc(id).get();
    return Game.fromEntity(GameEntity.fromSnapshot(documentSnapshot));
  }

  Future<void> addNewGame(Game game) async {
    var result = await gamesCollection.add(game.toEntity().toDocument());
    await gamesCollection
        .doc(result.id)
        .update(game.copyWith(id: result.id).toEntity().toDocument());
  }

  Future<void> editGame(Game game) async {
    await gamesCollection.doc(game.id).update(game.toEntity().toDocument());
  }
}
