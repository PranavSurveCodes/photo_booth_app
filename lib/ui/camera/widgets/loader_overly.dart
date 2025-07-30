import 'package:flutter/material.dart';

class LoaderOverlay extends StatelessWidget {
  const LoaderOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Optional: semi-transparent background
        ModalBarrier(dismissible: false, color: Colors.black.withOpacity(0.5)),
        const Center(child: CircularProgressIndicator()),
      ],
    );
  }
}
