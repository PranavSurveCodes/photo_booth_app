import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_booth/ui/home/widgets/collage_frame.dart';
import '../models/collage_templates.dart'; // adjust path if needed
import 'package:flutter/rendering.dart';
import 'dart:typed_data'; // For ByteData and Uint8List
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:ui' as ui;
import 'package:camera/camera.dart';
import 'package:photo_booth/ui/camera/camera_capture_screen.dart';

enum CollageType { twoByTwo, threeByThree }

class CollageScreen extends StatefulWidget {
  const CollageScreen({Key? key}) : super(key: key);

  @override
  State<CollageScreen> createState() => _CollageScreenState();
}

class _CollageScreenState extends State<CollageScreen> {
  int? selectedTemplateIndex;
  CollageType? selectedCollageType;
  late int totalSlots;
  final ImagePicker _picker = ImagePicker();
  late List<XFile?> images;
  int currentTakingIndex = 0;
  final GlobalKey _collageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    selectedCollageType = null;
    selectedTemplateIndex = null;
    images = [];
    totalSlots = 0;
  }

  Future<void> _pickImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        images[index] = pickedFile;
      });
    } else {
      // Reset collage state when user cancels
      setState(() {
        selectedTemplateIndex = null;
        images = [];
      });
      debugPrint("Image picking cancelled, resetting collage");
    }
  }

  Future<void> _saveOrShareCollage({bool share = false}) async {
    try {
      RenderRepaintBoundary boundary =
          _collageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/collage.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      if (share) {
        await Share.shareXFiles([XFile(filePath)], text: 'Check out my collage!');
      } else {
        print("Collage saved at: $filePath");
      }
    } catch (e) {
      print("Error saving/sharing collage: $e");
    }
  }

  void selectCollageType(CollageType type) {
    setState(() {
      selectedCollageType = type;
      selectedTemplateIndex = null;
      totalSlots = (type == CollageType.twoByTwo) ? 4 : 9;
      images = List<XFile?>.filled(totalSlots, null);
      currentTakingIndex = 0;
    });
  }

  void deletePicture(int index) {
    setState(() {
      if (index >= 0 && index < images.length) {
        images[index] = null;
        currentTakingIndex = index;
      }
    });
  }

  Widget buildCollage(CollageTemplate template, {bool isPreview = false}) {
    final displayImages = images.length == template.slots.length
        ? images
        : List<XFile?>.filled(template.slots.length, null);

    return AspectRatio(
      aspectRatio: 1,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final h = constraints.maxHeight;
          return Stack(
            children: [
              for (int i = 0; i < template.slots.length; i++)
                Positioned(
                  left: template.slots[i].x * w,
                  top: template.slots[i].y * h,
                  width: template.slots[i].width * w,
                  height: template.slots[i].height * h,
                  child: GestureDetector(
                    onTap: isPreview ? null : () => {},
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        color: Colors.grey.shade200,
                      ),
                      child: displayImages[i] != null
                          ? Stack(
                              fit: StackFit.expand,
                              children: [
                                Image.file(
                                  File(displayImages[i]!.path),
                                  fit: BoxFit.cover,
                                ),
                                if (!isPreview)
                                  Positioned(
                                    top: 4,
                                    right: 4,
                                    child: GestureDetector(
                                      onTap: () => deletePicture(i),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        padding: const EdgeInsets.all(4),
                                        child: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            )
                          : Center(
                              child: Icon(
                                isPreview ? Icons.photo_library : Icons.camera_alt,
                                size: isPreview ? 20 : 32,
                                color: Colors.grey.shade700,
                              ),
                            ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool allSlotsFilled = images.isNotEmpty && images.every((img) => img != null);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          'Collage Screen',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFDA22FF), Color(0xFF9733EE)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
          child: Column(
            children: [
              // 🔹 Template Buttons
              if (!allSlotsFilled)
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: List.generate(templates.length, (index) {
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withOpacity(0.9),
                        foregroundColor: Colors.deepPurple,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        elevation: 4,
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedTemplateIndex = index;
                          selectedCollageType = null;
                          totalSlots = templates[index].slots.length;
                          images = List.generate(totalSlots, (_) => null);
                          currentTakingIndex = 0;
                        });
                      },
                      child: Text('Template ${index + 1}'),
                    );
                  }),
                ),

              const SizedBox(height: 20),

              // 🔹 Collage Preview Area
              Expanded(
                child: RepaintBoundary(
                  key: _collageKey,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: selectedCollageType != null
                          ? CollageFrame(
                              rows: (selectedCollageType == CollageType.twoByTwo) ? 2 : 3,
                              cols: (selectedCollageType == CollageType.twoByTwo) ? 2 : 3,
                              images: images,
                              onDelete: deletePicture,
                              onTap: (index) async {
                                setState(() => currentTakingIndex = index);
                                // Open CameraCaptureScreen for single shot
                                final cameras = await availableCameras();
                                if (cameras.isEmpty) return;
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => CameraCaptureScreen(
                                      totalShots: 1,
                                      interval: const Duration(seconds: 1),
                                      onPicturesTaken: (captured) {
                                        if (captured.isNotEmpty) {
                                          setState(() {
                                            images[currentTakingIndex] = captured.first;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                );
                              },
                              isPreview: allSlotsFilled,
                            )
                          : (selectedTemplateIndex != null
                              ? buildCollage(templates[selectedTemplateIndex!],
                                  isPreview: allSlotsFilled)
                              : Center(
                                  child: Text(
                                    'Select a collage type or template',
                                    style: TextStyle(
                                      color: Colors.grey.shade600,
                                      fontSize: 16,
                                    ),
                                  ),
                                )),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Capture Button
              if ((selectedCollageType != null || selectedTemplateIndex != null) &&
                  images.any((img) => img == null))
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 14,
                    ),
                  ),
                  onPressed: () async {
                    if (totalSlots == 0) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CameraCaptureScreen(
                          totalShots: totalSlots,
                          interval: const Duration(seconds: 3),
                          onPicturesTaken: (captured) {
                            setState(() {
                              for (int i = 0;
                                  i < totalSlots && i < captured.length;
                                  i++) {
                                images[i] = captured[i];
                              }
                            });
                          },
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.camera_alt, size: 22),
                  label: const Text(
                    'Start Collage Capture',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),

              const SizedBox(height: 16),
              // 🔹 Only Share Button
            if (images.isNotEmpty && images.every((img) => img != null))
              Center(
              child: SizedBox(
                width: 220, // increase or decrease as you like
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFDA22FF),
                    side: const BorderSide(color: Color(0xFFDA22FF), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: () => _saveOrShareCollage(share: true),
                  icon: const Icon(Icons.share, size: 24),
                  label: const Text(
                    "Share",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    ),
  );
}
}
