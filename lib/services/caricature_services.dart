// caricature_services
import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CaricatureService {
  static  final String _hfToken = dotenv.env['HF_TOKEN']!;
 

 static final  String _baseUrl = dotenv.env['API_URL']!;

  final Dio _dio = Dio(
    BaseOptions(
      headers: {
        "Authorization": "Bearer $_hfToken",
        "Content-Type": "application/json",
      },
    ),
  );

Future<List<String>> uploadImage(File imageFile) async {

  try {
    // Prepare multipart form data
    final formData = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        imageFile.path,
        filename: imageFile.uri.pathSegments.last,
      ),
    });

    // Send POST request
    final response = await _dio.post(
      "$_baseUrl/upload",
      data: formData,
      options: Options(
        headers: {
          "Authorization": "Bearer $_hfToken",
          "Content-Type": "multipart/form-data",
        },
      ),
    );

    if (response.statusCode == 200) {
      // Expected response is like: ["/tmp/gradio/.../filename.jpeg"]
      if (response.data is List) {
        return List<String>.from(response.data);
      } else {
        throw Exception("Unexpected response format: ${response.data}");
      }
    } else {
      throw Exception("Upload failed with status: ${response.statusCode}");
    }
  } catch (e) {
    throw Exception("Error uploading image: $e");
  }
}


  Future<File?> generateCaricature(File imageFile) async {
    try {
      // Prepare file path for Gradio
      final path = await uploadImage(imageFile);

      // 1️⃣ POST to start inference
      final postResponse = await _dio.post(
        "$_baseUrl/call/infer",

        options: Options(
          headers: {
            "Authorization": "Bearer $_hfToken",
            "Content-Type": "application/json",
          },
        ),
        data: {
          "data": [
            {
              "path": path.first, // ✅ Base64 content here
              "url": "https://black-forest-labs-flux-1-kontext-dev.hf.space/gradio_api/file=${path.first}",
              "mime_type": "image/${imageFile.path.split("/").last}",
              "meta": {"_type": "gradio.FileData"},
            },
            "Convert it to fun caricature style art",
            0,
            true,
            5,
            7,
          ],
        },
      );

      final eventId = postResponse.data["event_id"];
      log('event id: ${eventId}');
      if (eventId == null) throw Exception("No event_id in response");

      // 2️⃣ Listen to SSE for output
      final imageUrl = await _listenForResult(eventId);
      if (imageUrl == null) throw Exception("No image URL found");

      // 3️⃣ Download result
      return await _downloadImage(imageUrl);
      return null;
    } catch (e) {
      print("❌ Error generating caricature: $e");
      return null;
    }
  }

  Future<String?> _listenForResult(String eventId) async {
    final dio = Dio();

    try {
      final response = await dio.get(
        'https://black-forest-labs-flux-1-kontext-dev.hf.space/gradio_api/call/infer/$eventId',
        options: Options(
          responseType: ResponseType.stream, // SSE streaming
          headers: {
            'Accept': 'text/event-stream',
            "Authorization": "Bearer $_hfToken",
          },
        ),
      );

      String? finalUrl;

      // Listen to SSE stream
      await for (var chunk in response.data.stream) {
        final line = utf8.decode(chunk).trim();
        if (line.isEmpty) continue;

        log("🔹 SSE Event Line: $line end.");

        if (line.contains("event: complete")) {
          log('I am here');
           
          final jsonStr = line.split('\n').last.substring(5).trim();
          log('sub str: $jsonStr');

          try {
            final decoded = jsonDecode(jsonStr);
            log("📦 Decoded JSON: $decoded");

            finalUrl = decoded[0]['url'];
          } catch (e) {
            print("⚠️ JSON decode error: $e");
          }
        
        }

       
      }

      return finalUrl; // Could be null if not found
    } catch (e) {
      print("❌ Request failed: $e");
      return null;
    }
  }

  /// Download image and save to temporary directory
  Future<File> _downloadImage(String imageUrl) async {
    final dir = await getTemporaryDirectory();
    final filePath =
        "${dir.path}/caricature_${DateTime.now().millisecondsSinceEpoch}.webp";

    final response = await _dio.get(
      imageUrl,
      options: Options(responseType: ResponseType.bytes),
    );

    final file = File(filePath);
    await file.writeAsBytes(response.data);
    return file;
  }
}
