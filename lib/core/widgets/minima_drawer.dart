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
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        DrawerHeader(
          margin: EdgeInsets.zero,
          padding: EdgeInsets.zero,
          decoration: const BoxDecoration(color: AppTheme.grey10),
          child: Container(
            decoration: const BoxDecoration(
              border: BorderDirectional(
                end: BorderSide(color: AppTheme.black, width: 2.0),
              ),
            ),
            height: 100,
            width: width,
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 32.0, left: 32.0),
                  child: Text(
                    'Minima Notes',
                    style: TextStyle(fontSize: 24, color: AppTheme.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Drawer(
            width: width,
            shape: const BorderDirectional(
              end: BorderSide(color: AppTheme.black, width: 2.0),
            ),
            child: ListView.builder(
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
        ),
      ],
    );
  }
}
