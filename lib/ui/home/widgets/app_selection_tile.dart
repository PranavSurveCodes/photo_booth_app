// import 'package:flutter/material.dart';
// import 'package:photo_booth/config/app_enums.dart';

// class AppSelectionTile extends StatelessWidget {
//   const AppSelectionTile({super.key, required this.app, required this.onTap});
//   final ChooseApp app;
//   final VoidCallback onTap;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       // elevation: 4,
//       child: ListTile(title: Text(app.name), onTap: onTap),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:photo_booth/config/app_enums.dart';

class AppSelectionTile extends StatelessWidget {
  const AppSelectionTile({
    super.key,
    required this.app,
    required this.onTap,
  });
  final ChooseApp app;
  final VoidCallback onTap;

  // Map ChooseApp to appropriate icon
  IconData _getIcon() {
    switch (app) {
      case ChooseApp.ar:
        return Icons.camera_alt;
      case ChooseApp.caricature:
        return Icons.face;
      case ChooseApp.boomerang:
        return Icons.loop;
      case ChooseApp.collage:
        return Icons.grid_view;
    }
    // Removed unreachable default clause (fix warning)
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(32),
        onTap: onTap,
        child: Card(
          // If .withValues() is available (new Flutter SDK), use it:
          // color: Colors.white.withValues(alpha: 0.16),
          // Else, use .withOpacity() (older Flutter SDK):
          color: Colors.white.withOpacity(0.16),
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          child: Container(
            height: 80,
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(width: 24),
                Icon(
                  _getIcon(),
                  color: Colors.white,
                  size: 40,
                ),
                SizedBox(width: 32),
                Text(
                  _displayName(app),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper to get user-friendly display name
  String _displayName(ChooseApp app) {
    switch (app) {
      case ChooseApp.ar:
        return "AR";
      case ChooseApp.caricature:
        return "Caricature";
      case ChooseApp.boomerang:
        return "Boomerang";
      case ChooseApp.collage:
        return "Collage";
    }
  }
}
