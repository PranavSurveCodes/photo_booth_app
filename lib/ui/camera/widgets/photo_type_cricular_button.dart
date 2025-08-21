import 'package:flutter/material.dart';
import 'package:photo_booth/domain/models/photo_type.dart';

class PhotoTypeCricularButton extends StatelessWidget {
  const PhotoTypeCricularButton({
    super.key,
    required this.onTap,
    required this.isSelected,
    required this.photoType,
  });
  final VoidCallback onTap;
  final bool isSelected;
  final PhotoType photoType;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.purpleAccent : Colors.transparent,
                width: 4,
              ),
              boxShadow: [
                if (isSelected)
                  BoxShadow(
                    color: Colors.purple.withAlpha((0.3 * 255).toInt()),
                    blurRadius: 15,
                    spreadRadius: 5,
                  ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                photoType.url,
                fit: BoxFit.cover,
                width: 120,
                height: 120,

                errorBuilder:
                    (context, error, stackTrace) => const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.grey,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            photoType.lable,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: isSelected ? Colors.purple : Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
