import 'package:flutter/material.dart';
import 'package:note_app/components/drawer_tile.dart';
import 'package:note_app/habits/pages/home_page.dart';
import 'package:note_app/pages/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          // header
          const DrawerHeader(child: Icon(Icons.edit_note, size: 36)),

          // notes tile
          // DrawerTile(
          //   title: "Notes",
          //   leading: const Icon(Icons.home_outlined),
          //   onTap: () => Navigator.pop(context),
          // ),

          // habbit tile
          // DrawerTile(
          //   title: "Habbit Tracker",
          //   leading: const Icon(Icons.track_changes),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => HomePage()),
          //     );
          //   },
          // ),

          // settings tile
          DrawerTile(
            title: "Settings",
            leading: const Icon(Icons.settings_outlined),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}
