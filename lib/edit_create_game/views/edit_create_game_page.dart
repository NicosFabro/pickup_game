import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Packages
import 'package:pickup_game_ui/pickup_game_ui.dart';
import 'package:field_repository/field_repository.dart';
import 'package:game_repository/game_repository.dart';

// Fields
import 'package:pickup_game/fields/bloc/fields_bloc.dart';
import 'package:pickup_game/fields/widgets/field_card.dart';

// Games
import 'package:pickup_game/games/bloc/games_bloc.dart';

// l10n
import 'package:pickup_game/l10n/l10n.dart';

class EditCreateGamePage extends StatelessWidget {
  const EditCreateGamePage({Key? key, this.editGame}) : super(key: key);

  final Game? editGame;

  static Route route({Game? editGame}) => AppPageRoute(
        builder: (_) => EditCreateGamePage(editGame: editGame),
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FieldsBloc>(
          create: (contxet) => FieldsBloc(
            fieldRepository: context.read<FieldRepository>(),
          )..add(FieldsFetchRequested()),
        ),
        BlocProvider<GamesBloc>(
          create: (context) => GamesBloc(
            gameRepository: context.read<GameRepository>(),
          ),
        ),
      ],
      child: CreateGameView(editGame: editGame),
    );
  }
}

class CreateGameView extends StatefulWidget {
  const CreateGameView({Key? key, this.editGame}) : super(key: key);

  final Game? editGame;

  @override
  _CreateGameViewState createState() => _CreateGameViewState();
}

class _CreateGameViewState extends State<CreateGameView> {
  String fieldId = '';

  final gameTypes = GameType.values.map(describeEnum).toList();
  String gameType = describeEnum(GameType.TeamVsTeam);

  final footballTypes = FootballType.values.map(describeEnum).toList();
  String footballType = describeEnum(FootballType.Football5);

  DateTime? date;
  TimeOfDay? startHour;
  TimeOfDay? endHour;

  DateTime? dateStart;
  DateTime? dateEnd;

  final TextEditingController _playerNameController = TextEditingController();
  final Map<String, String> players = {};
  LinkedHashMap<String, String> playersSorted = LinkedHashMap();

  Color? currentColor;

  Future<DateTime> chooseDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: today,
      firstDate: today,
      lastDate: DateTime(DateTime.now().year, DateTime.now().month + 2),
    );

    return date ?? today;
  }

  Future<TimeOfDay> chooseTime() async {
    final now = TimeOfDay.now();
    final time = await showTimePicker(
      context: context,
      initialTime: now,
    );

    return time ?? now;
  }

  void onAddPlayer() {
    if (_playerNameController.text.isEmpty) return;

    setState(() {
      players[_playerNameController.text] = '';
      playersSorted = getSortedPlayers();
    });

    _playerNameController.clear();
  }

  void onRemovePlayer(String player) {
    setState(() {
      players.removeWhere((key, _) => key == player);
      playersSorted.removeWhere((key, _) => key == player);
    });
  }

  void addTeamToPlayer(String player) {
    var team = '';
    if (currentColor == null) {
      return;
    } else if (currentColor == Colors.black) {
      team = 'black';
    } else if (currentColor == Colors.blue) {
      team = 'blue';
    } else if (currentColor == Colors.red) {
      team = 'red';
    } else {
      return;
    }

    setState(() {
      players[player] = team;
      playersSorted = getSortedPlayers();
    });
  }

  bool canSubmit = false;

  void onSave() {
    dateStart = DateTime(
      date!.year,
      date!.month,
      date!.day,
      startHour!.hour,
      startHour!.minute,
    );

    dateEnd = DateTime(
      date!.year,
      date!.month,
      date!.day,
      endHour!.hour,
      endHour!.minute,
    );

    var game = Game(
      id: widget.editGame != null ? widget.editGame!.id : '',
      fieldId: fieldId,
      dateStart: dateStart!,
      dateEnd: dateEnd!,
      gameType: Game.stringToGameType(gameType),
      footballType: Game.stringToFootballType(footballType),
      players: players,
    );

    if (widget.editGame != null) {
      context.read<GamesBloc>().add(GamePushRequested(game: game));
    } else {
      context.read<GamesBloc>().add(GamePostRequested(game: game));
    }

    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _playerNameController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    if (widget.editGame != null) {
      fieldId = widget.editGame!.fieldId;
      gameType = describeEnum(widget.editGame!.gameType);
      footballType = describeEnum(widget.editGame!.footballType);
      date = widget.editGame!.dateStart;
      dateStart = widget.editGame!.dateStart;
      dateEnd = widget.editGame!.dateEnd;
      startHour = TimeOfDay.fromDateTime(widget.editGame!.dateStart);
      endHour = TimeOfDay.fromDateTime(widget.editGame!.dateEnd);

      players
        ..clear()
        ..addAll(widget.editGame!.players);
      playersSorted = getSortedPlayers();
    }
  }

  LinkedHashMap<String, String> getSortedPlayers() {
    var sortedKeys = players.keys.toList()
      ..sort((k1, k2) => players[k1]!.compareTo(players[k2]!));
    var sortedEmpty = sortedKeys.where((p) => players[p] == '').toList()
      ..sort();
    var sortedBlack = sortedKeys.where((p) => players[p] == 'black').toList()
      ..sort();
    var sortedBlue = sortedKeys.where((p) => players[p] == 'blue').toList()
      ..sort();
    var sortedRed = sortedKeys.where((p) => players[p] == 'red').toList()
      ..sort();
    return LinkedHashMap.fromIterable(
      sortedEmpty..addAll(sortedBlack)..addAll(sortedBlue)..addAll(sortedRed),
      key: (k) => k,
      value: (k) => players[k]!,
    );
  }

  @override
  Widget build(BuildContext context) {
    var l10n = AppLocalizations.of(context);

    const gap = SizedBox(height: 16);

    canSubmit = !(fieldId.isEmpty ||
        date == null ||
        startHour == null ||
        endHour == null);

    return Scaffold(
      backgroundColor: PickUpGameColors.whiteBackground,
      appBar: AppBar(
        title: Text(
          widget.editGame == null ? l10n.createNewGameAppBarTitle : 'Edit game',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.chooseField,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              BlocBuilder<FieldsBloc, FieldsState>(
                builder: (context, state) {
                  switch (state.status) {
                    case FieldsStatus.failure:
                      return const Center(
                          child: Text('Error fetching fields.'));
                    case FieldsStatus.loading:
                      return const Center(child: CircularProgressIndicator());
                    case FieldsStatus.success:
                      return SizedBox(
                        height: 158,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: state.fields.length,
                          itemBuilder: (_, i) => GestureDetector(
                            onTap: () => setState(() {
                              fieldId = state.fields[i].id;
                            }),
                            child: Container(
                              margin: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: fieldId == state.fields[i].id
                                      ? Colors.blueAccent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: FieldCard(field: state.fields[i]),
                            ),
                          ),
                        ),
                      );
                  }
                },
              ),
              gap,
              Text(
                l10n.chooseDateHour,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  date = await chooseDate();
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 10),
                    Text(
                      date != null
                          ? DateFormat('dd-MM-yyyy').format(date!)
                          : l10n.selectDate,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  startHour = await chooseTime();
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Icon(Icons.schedule),
                    const SizedBox(width: 10),
                    Text(
                      startHour != null
                          ? startHour!.format(context)
                          : l10n.selectStartHour,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  endHour = await chooseTime();
                  setState(() {});
                },
                child: Row(
                  children: [
                    const Icon(Icons.schedule),
                    const SizedBox(width: 10),
                    Text(
                      endHour != null
                          ? endHour!.format(context)
                          : l10n.selectEndHour,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              gap,
              Text(
                l10n.chooseGameType,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              DropdownButton<String>(
                value: footballType,
                onChanged: (newValue) =>
                    setState(() => footballType = newValue!),
                items: footballTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              DropdownButton<String>(
                value: gameType,
                onChanged: (newValue) => setState(() => gameType = newValue!),
                items: gameTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
              ),
              gap,
              Text(
                l10n.addPlayers,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _playerNameController,
                decoration: InputDecoration(
                  hintText: 'Georgi',
                  suffixIcon: IconButton(
                    onPressed: onAddPlayer,
                    icon: const Icon(Icons.add),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    iconSize: currentColor == Colors.black ? 70 : 50,
                    color: Colors.black,
                    onPressed: () => setState(
                      () => currentColor = Colors.black,
                    ),
                    icon: const Icon(Icons.shield),
                  ),
                  IconButton(
                    iconSize: currentColor == Colors.blue ? 70 : 50,
                    color: Colors.blue,
                    onPressed: () => setState(
                      () => currentColor = Colors.blue,
                    ),
                    icon: const Icon(Icons.shield),
                  ),
                  IconButton(
                    iconSize: currentColor == Colors.red ? 70.0 : 50.0,
                    color: Colors.red,
                    onPressed: () => setState(
                      () => currentColor = Colors.red,
                    ),
                    icon: const Icon(Icons.shield),
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: playersSorted.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  var name = playersSorted.keys.elementAt(i);
                  var team = playersSorted[name]!;

                  return ListTile(
                    title: Text(name),
                    tileColor: team == 'black'
                        ? Colors.black45
                        : team == 'blue'
                            ? Colors.blue[200]
                            : team == 'red'
                                ? Colors.red[200]
                                : Colors.white24,
                    trailing: IconButton(
                      onPressed: () => onRemovePlayer(name),
                      icon: const Icon(Icons.remove, color: Colors.red),
                    ),
                    onTap: () => addTeamToPlayer(name),
                  );
                },
              ),
              gap,
              Center(
                child: SizedBox(
                  width: 300,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: canSubmit ? onSave : null,
                    child: Text(widget.editGame == null ? 'Crear' : 'Guardar'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
