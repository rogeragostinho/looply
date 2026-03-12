import 'package:flutter/material.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({super.key, required this.title, this.bottom});

  final String title;
  final TabBar? bottom;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title), // widget.title, para Stateful
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize {
    if (bottom != null) {
      // altura do toolbar + altura do TabBar
      return Size.fromHeight(kToolbarHeight + bottom!.preferredSize.height);
    }
    return const Size.fromHeight(kToolbarHeight);
  }
}