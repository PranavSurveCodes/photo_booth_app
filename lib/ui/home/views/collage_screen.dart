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
  int? selectedTemplate;   // <-- add this
  CollageType? selectedCollageType;
  int? selectedTemplateIndex;
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
    //_initCamera();
  }
  Future<void> _pickImage(int index) async {
  final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

  if (pickedFile != null) {
    setState(() {
      images[index] = pickedFile; // since images is List<XFile?>
    });
  } else {
    // Reset collage state when user cancels
    setState(() {
      selectedTemplate = null;
      images = []; // clear images
    });
    debugPrint("Image picking cancelled, resetting collage");
  }
}

  Future<void> takePicturesForAllSlots() async {
  // make sure images list has enough slots
  if (images.length < totalSlots) {
    images = List<XFile?>.filled(totalSlots, null);
  }
  for (int i = 0; i < totalSlots; i++) {
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);

    if (picture == null) {
      // user canceled, stop the loop
      break;
    }

    setState(() {
      images[i] = picture;
      currentTakingIndex = i;
    });
  }
}

  Future<void> _saveOrShareCollage({bool share = false}) async {
    try {
      // 1. Capture the collage widget as an image
      RenderRepaintBoundary boundary =
          _collageKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      ui.Image image = await boundary.toImage(pixelRatio: 3.0);

      // 2. Convert image to PNG byte data
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 3. Save the image to a temporary file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/collage.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      // 4. Share or just save
      if (share) {
        await Share.shareXFiles([XFile(filePath)], text: 'Check out my collage!');
      } else {
        // If not sharing, you can save it to gallery or do something else
        print("Collage saved at: $filePath");
      }
    } catch (e) {
      print("Error saving/sharing collage: $e");
    }
  }


  void selectCollageType(CollageType type) {
    setState(() {
      selectedCollageType = type;
      selectedTemplateIndex = null; // clear custom template
      totalSlots = (type == CollageType.twoByTwo) ? 4 : 9;
      images = List<XFile?>.filled(totalSlots, null);
      currentTakingIndex = 0;
    });
  }

  Future<void> takePicture([int? index]) async {
    final XFile? picture = await _picker.pickImage(source: ImageSource.camera);
    if (picture != null) {
      setState(() {
        if (index != null) {
          currentTakingIndex = index;
        }
        // ensure correct length
        if (images.length < totalSlots) {
          images = List<XFile?>.from(images)
            ..length = totalSlots;
        }
        images[currentTakingIndex] = picture;

        // ✅ Find first empty slot after current
        int nextIndex = images.indexWhere((img) => img == null);
        currentTakingIndex = (nextIndex != -1) ? nextIndex : currentTakingIndex;
      });
    }
  }

  void deletePicture(int index) {
    setState(() {
      if (index >= 0 && index < images.length) {
        images[index] = null;
        currentTakingIndex = index;
      }
    });
  }

  // IMPORTANT: this method must be INSIDE the State class so 'takePicture' and 'images' are in scope
  Widget buildCollage(CollageTemplate template, {bool isPreview = false}) {
    // make sure we have a displayImages list sized to the template
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
                  // ✅ Place Template 9 between 7 and 8
                  if (index == 8) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            foregroundColor: Colors.deepPurple,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 4,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 12,
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedTemplateIndex = 8;
                              selectedCollageType = null;
                              totalSlots = templates[8].slots.length;
                              images = List.generate(totalSlots, (_) => null);
                              currentTakingIndex = 0;
                            });
                          },
                          child: const Text('Template 9'),
                        ),
                      ],
                    );
                  }

                  // Normal buttons for other templates
                  return ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.9),
                      foregroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      elevation: 4,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
                    boxShadow: [
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
                            onTap: (index) {
                              setState(() {
                                currentTakingIndex = index;
                              });
                              takePicture(index);
                            },
                            isPreview: allSlotsFilled, // ✅ hide delete when final
                          )
                        : (selectedTemplateIndex != null
                            ? buildCollage(templates[selectedTemplateIndex!],
                              isPreview: allSlotsFilled, // ✅ pass preview flag
                            )
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
                  final cameras = await availableCameras();
                  if (cameras.isEmpty) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CameraCaptureScreen(
                        camera: cameras.first,
                        totalShots: totalSlots,
                        interval: const Duration(seconds: 3),
                        onPicturesTaken: (captured) {
                          setState(() {
                            for (int i = 0; i < totalSlots && i < captured.length; i++) {
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