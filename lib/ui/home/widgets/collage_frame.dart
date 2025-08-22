import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class CollageFrame extends StatelessWidget {
  final int rows;
  final int cols;
  final List<XFile?> images;
  final void Function(int) onDelete;
  final void Function(int) onTap;
  final bool isPreview; // ✅ NEW flag

  const CollageFrame({
    super.key,
    required this.rows,
    required this.cols,
    required this.images,
    required this.onDelete,
    required this.onTap,
    this.isPreview = false, // ✅ default = false (editable mode)
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: cols,
      ),
      itemCount: rows * cols,
      itemBuilder: (context, index) {
        final image = images.length > index ? images[index] : null;

        return GestureDetector(
          onTap: () {
            // ✅ Just notify parent which slot was tapped
            // (DOES NOT open camera automatically anymore)
            onTap(index);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, style: BorderStyle.solid),
              color: Colors.grey.shade200,
            ),
            child: image != null
                ? Stack(
                    children: [
                      Image.file(
                        File(image.path),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      if (!isPreview)
                        Positioned(
                          right: 4,
                          top: 4,
                          child: IconButton(
                            icon: const Icon(Icons.close, color: Colors.red),
                            onPressed: () => onDelete(index),
                          ),
                        ),
                    ],
                  )
                : (!isPreview
                    ? const Center(
                        child: Icon(Icons.add, color: Colors.grey, size: 40),
                      )
                    : const SizedBox.shrink()), // empty in preview
          ),
        );
      },
    );
  }
}