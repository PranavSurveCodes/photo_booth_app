import 'package:flutter/material.dart';
import 'package:photo_booth/config/app_enums.dart';

class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({super.key, required this.app, required this.onTap});
  final ChooseApp app;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      // elevation: 4,
      child: ListTile(title: Text(app.name), onTap: onTap),
    );
  }
}
