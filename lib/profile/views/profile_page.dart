import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:pickup_game/app/bloc/app_bloc.dart';

import 'package:pickup_game/login/views/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  static Route route() =>
      MaterialPageRoute(builder: (_) => const ProfilePage());

  @override
  Widget build(BuildContext context) {
    return const ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appBloc = context.read<AppBloc>().state;

    final appBarActions = ['Edit', 'Logout'];

    var gap = const SizedBox(height: 8.0);

    void _onAction(String action) {
      switch (action) {
        case 'Edit':
          log('Profile: edit action');
          break;
        case 'Logout':
          Navigator.of(context).pushAndRemoveUntil(
            LoginPage.route(),
            (route) => false,
          );
          context.read<AppBloc>().add(AppLogOutRequested());
          break;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          PopupMenuButton<String>(
            onSelected: _onAction,
            itemBuilder: (context) {
              return appBarActions.map((String action) {
                return PopupMenuItem(value: action, child: Text(action));
              }).toList();
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 38.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(appBloc.user.photo ?? ''),
                  radius: 50.0,
                ),
                gap,
                Text(
                  appBloc.profile.nickname.isEmpty
                      ? appBloc.user.name!
                      : appBloc.profile.nickname,
                  style: Theme.of(context).textTheme.headline6,
                ),
                gap,
                Text(
                  appBloc.user.email ?? '',
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                gap,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: appBloc.profile.availableTeams.map((team) {
                    return Icon(
                      Icons.shield,
                      size: 50.0,
                      color: team == 'black'
                          ? Colors.black
                          : team == 'blue'
                              ? Colors.blue[200]
                              : team == 'red'
                                  ? Colors.red[200]
                                  : Colors.white30,
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
