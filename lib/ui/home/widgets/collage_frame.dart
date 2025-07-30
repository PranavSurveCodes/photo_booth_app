import 'package:flutter/material.dart';

class CollageOfTwoImage extends StatelessWidget {
  const CollageOfTwoImage({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(child: _CollageFrame()),
          Expanded(child: _CollageFrame()),
        ],
      ),
    );
  }
}

class CollageOfThreeImage extends StatelessWidget {
  const CollageOfThreeImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(child: _CollageFrame()),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _CollageFrame()),
              Expanded(child: _CollageFrame()),
            ],
          ),
        ),
      ],
    );
  }
}

class CollageOfFourImage extends StatelessWidget {
  const CollageOfFourImage({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(child: _CollageFrame()),
              Expanded(child: _CollageFrame()),
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              Expanded(child: _CollageFrame()),
              Expanded(child: _CollageFrame()),
            ],
          ),
        ),
      ],
    );
  }
}

class _CollageFrame extends StatelessWidget {
  const _CollageFrame();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            'https://picsum.photos/200/300', // Replace with your image URL
          ),
          fit: BoxFit.cover,
        ),
        color: Colors.purple.shade50, // Light purple background
        border: Border.all(color: Colors.purple, width: 2), // Purple border
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
