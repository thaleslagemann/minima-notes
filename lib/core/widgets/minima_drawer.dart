import 'package:flutter/material.dart';
import 'package:minima_notes/core/theme/theme.dart';
import 'package:minima_notes/models/drawer_tile_model.dart';

class MinimaDrawer extends StatelessWidget {
  MinimaDrawer({super.key, required int index}) : _index = index;

  final int _index;

  final List<DrawerTile> tiles = [
    DrawerTile(0, title: 'Notes', icon: Icons.notes, route: '/notes'),
    DrawerTile(1, title: 'Settings', icon: Icons.settings_outlined, route: '/settings'),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width * 0.75;
    return Drawer(
      width: width,
      backgroundColor: AppTheme.white,
      shape: const BorderDirectional(
        end: BorderSide(color: AppTheme.black, width: 2.0),
      ),
      child: Column(
        children: [
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            decoration: const BoxDecoration(color: AppTheme.black),
            child: SizedBox(
              width: width,
              child: const Padding(
                padding: EdgeInsets.only(top: 16.0, left: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to',
                      style: TextStyle(fontSize: 14, color: AppTheme.greyE0),
                    ),
                    Text(
                      'Minima Notes',
                      style: TextStyle(fontSize: 24, color: AppTheme.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: tiles.length,
              itemBuilder:
                  (context, index) => ListTile(
                    leading: Icon(tiles[index].icon),
                    tileColor: _index == index ? AppTheme.greyD0 : AppTheme.white,
                    title: Text(tiles[index].title ?? ''),
                    onTap: () => Navigator.pushNamed(context, tiles[index].getRoute()),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
