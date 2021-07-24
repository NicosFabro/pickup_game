import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Packages
import 'package:game_repository/game_repository.dart';
import 'package:pickup_game_ui/pickup_game_ui.dart';

// Edit/Create
import 'package:pickup_game/edit_create_game/views/edit_create_game_page.dart';

// Profile
import 'package:pickup_game/profile/views/profile_page.dart';

// Games
import 'package:pickup_game/games/widgets/game_tile.dart';
import 'package:pickup_game/games/bloc/games_bloc.dart';

// l10n
import 'package:pickup_game/l10n/l10n.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static Route route() => MaterialPageRoute(builder: (_) => const HomePage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GamesBloc(
            gameRepository: context.read<GameRepository>(),
          )..add(GamesFetchRequested()),
        ),
      ],
      child: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: PickUpGameColors.whiteBackground,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(EditCreateGamePage.route()),
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: Text(l10n.pickupGameAppBarTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.of(context).push(ProfilePage.route()),
          ),
        ],
      ),
      body: BlocBuilder<GamesBloc, GamesState>(
        builder: (context, state) {
          switch (state.status) {
            case GamesStatus.failure:
              return const Center(child: Text('Error fetching games.'));
            case GamesStatus.loading:
              return const Center(child: CircularProgressIndicator());
            case GamesStatus.success:
              state.games.sort(
                (g1, g2) => g1.dateStart.compareTo(g2.dateStart),
              );
              return ListView.builder(
                itemCount: state.games.length,
                itemBuilder: (_, i) {
                  return GameTile(
                    game: state.games[i],
                    onTap: () {
                      Navigator.of(context).push(
                        EditCreateGamePage.route(editGame: state.games[i]),
                      );
                    },
                  );
                },
              );
          }
        },
      ),
    );
  }
}
