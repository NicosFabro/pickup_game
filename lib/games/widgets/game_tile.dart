import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

// Packages
import 'package:game_repository/game_repository.dart';
import 'package:field_repository/field_repository.dart';

// Fields
import 'package:pickup_game/fields/bloc/fields_bloc.dart';

class GameTile extends StatelessWidget {
  const GameTile({
    Key? key,
    required this.game,
    this.onTap,
  }) : super(key: key);

  final Game game;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FieldsBloc(
        fieldRepository: context.read<FieldRepository>(),
      )..add(FieldFetchRequested(id: game.fieldId)),
      child: BlocBuilder<FieldsBloc, FieldsState>(
        builder: (context, state) {
          final dateFormatted =
              DateFormat('dd-MM-yyyy kk:mm').format(game.dateStart);
          switch (state.status) {
            case FieldsStatus.failure:
              return ListTile(
                title: Text(dateFormatted),
              );
            case FieldsStatus.loading:
              return ListTile(
                leading: const CircularProgressIndicator(),
                title: Text(dateFormatted),
              );
            case FieldsStatus.success:
              final field = state.fields[0];
              return ListTile(
                onTap: onTap,
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(field.logoUrl),
                ),
                title: Text(dateFormatted),
              );
          }
        },
      ),
    );
  }
}
