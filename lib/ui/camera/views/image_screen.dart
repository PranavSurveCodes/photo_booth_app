import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:photo_booth/ui/camera/Camera_controller/camera_controller.dart';
import 'package:printing/printing.dart';
import 'package:photo_booth/ui/camera/widgets/loader_overly.dart';
import 'package:share_plus/share_plus.dart';

class ImageScreen extends StatefulWidget {
  const ImageScreen( {super.key});
  

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
    final GetCameraController _getCameraController =
      Get.find<GetCameraController>();
  late OverlayEntry _loaderOverlayEntry;
 late final String path;


  @override
  void initState() {
     path = Get.arguments as String;
    super.initState();

    _loaderOverlayEntry = OverlayEntry(builder: (context) => LoaderOverlay());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image')),
      body: Builder(
        builder: (context) {
          final Size imageSize = _getCameraController.imageSize.value;
          return AspectRatio(
            aspectRatio: imageSize.width / imageSize.height,
            child: Image.file(File(path), fit: BoxFit.contain),
          );
        },
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () async {
                Overlay.of(context).insert(_loaderOverlayEntry);
                final params = ShareParams(
                  text: 'Great picture',
                  files: [XFile(path)],
                );
                final result = await SharePlus.instance.share(params);
                _loaderOverlayEntry.remove();
                if (result.status == ShareResultStatus.success) {
                  debugPrint('Thank you for sharing the picture!');
                }
              },
              icon: Icon(Icons.ios_share),
            ),
            IconButton(
              onPressed: () async {
                Overlay.of(context).insert(_loaderOverlayEntry);
                await Printing.layoutPdf(
                  onLayout: (PdfPageFormat format) async {
                    final imageBytes = await File(path).readAsBytes();
                    final doc = pw.Document();
                    final image = pw.MemoryImage(imageBytes);
                    doc.addPage(
                      pw.Page(
                        pageFormat: format,
                        build: (pw.Context context) {
                          return pw.Center(
                            child: pw.Image(image, fit: pw.BoxFit.contain),
                          );
                        },
                      ),
                    );
                    return doc.save();
                  },
                );
                _loaderOverlayEntry.remove();
              },
              icon: Icon(Icons.print),
            ),
          ],
        ),
      ),
    );
  }
}
