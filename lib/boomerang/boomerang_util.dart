// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:path/path.dart' as p;
// // import 'package:ffmpeg_kit_flutter_new_gpl/ffmpeg_kit.dart';
// import 'package:ffmpeg_kit_flutter_full/ffmpeg_kit.dart';

// Future<String?> makeBoomerang(String inputPath) async {
//   final tempDir = await getTemporaryDirectory();
//   final reversedPath = p.join(tempDir.path, 'reversed.mp4');
//   final concatListPath = p.join(tempDir.path, 'concat_list.txt');
//   final outputPath = p.join(tempDir.path, 'boomerang_final.mp4');

//   // Step 1: Reverse the original video
//   await FFmpegKit.execute(
//     "-i '$inputPath' -vf reverse -af areverse '$reversedPath'",
//   );

//   // Step 2: Create concat list
//   final concatFile = File(concatListPath);
//   await concatFile.writeAsString("file '$inputPath'\nfile '$reversedPath'\n");

//   // Step 3: Concatenate forward + reverse
//   await FFmpegKit.execute(
//     "-f concat -safe 0 -i '$concatListPath' -c copy '$outputPath'",
//   );

//   return File(outputPath).existsSync() ? outputPath : null;
// }
