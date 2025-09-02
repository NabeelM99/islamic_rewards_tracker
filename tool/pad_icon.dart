import 'dart:io';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

// Usage: dart run tool/pad_icon.dart <src> <dst> <paddingRatio>
// paddingRatio is fraction of the max(dimensions) to use as margin on each side (e.g., 0.18)
Future<void> main(List<String> args) async {
  if (args.length < 3) {
    stderr.writeln('Usage: dart run tool/pad_icon.dart <src> <dst> <paddingRatio>');
    exit(1);
  }
  final srcPath = args[0];
  final dstPath = args[1];
  final paddingRatio = double.tryParse(args[2]) ?? 0.18;

  final srcBytes = await File(srcPath).readAsBytes();
  final srcImage = img.decodeImage(srcBytes);
  if (srcImage == null) {
    stderr.writeln('Failed to decode source image: $srcPath');
    exit(2);
  }

  final maxSide = math.max(srcImage.width, srcImage.height);
  final pad = (maxSide * paddingRatio).round();
  final targetW = srcImage.width + pad * 2;
  final targetH = srcImage.height + pad * 2;

  final canvas = img.Image(width: targetW, height: targetH);
  // Transparent background so adaptive white background is visible
  img.fill(canvas, img.ColorUint8.rgba(0, 0, 0, 0));

  // Draw centered
  img.compositeImage(
    canvas,
    srcImage,
    dstX: ((targetW - srcImage.width) / 2).round(),
    dstY: ((targetH - srcImage.height) / 2).round(),
  );

  final outBytes = img.encodePng(canvas);
  await File(dstPath).create(recursive: true);
  await File(dstPath).writeAsBytes(outBytes);
  stdout.writeln('Wrote padded icon to $dstPath (padding=${(paddingRatio * 100).toStringAsFixed(1)}%)');
} 