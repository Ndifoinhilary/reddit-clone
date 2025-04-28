import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({required this.name, super.key});

  void navigateToEditCommunity(BuildContext context) {
    Routemaster.of(context).push("/edit-community/$name");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mod Tools')),
      body: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.add_moderator),
            title: const Text('Add Moderator'),
            subtitle: const Text('Manage moderators for your community'),
            onTap: () {
              // Navigate to manage posts screen
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text('Edit Community Settings'),
            subtitle: const Text('Change community settings'),
            onTap: () => {navigateToEditCommunity(context)},
          ),
        ],
      ),
    );
  }
}
