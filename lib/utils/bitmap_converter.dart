import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'dart:ui' as ui;
import 'package:flutter_svg/flutter_svg.dart';

Future<BitmapDescriptor> bitmapDescriptorFromSvgAsset(
  String assetName, [
  Size size = const Size(24, 24),
]) async {
  final pictureInfo = await vg.loadPicture(SvgAssetLoader(assetName), null);

  double devicePixelRatio =
      ui.PlatformDispatcher.instance.views.first.devicePixelRatio;
  int width = (size.width * devicePixelRatio).toInt();
  int height = (size.height * devicePixelRatio).toInt();

  final scaleFactor = min(
    width / pictureInfo.size.width,
    height / pictureInfo.size.height,
  );

  final recorder = ui.PictureRecorder();

  ui.Canvas(recorder)
    ..scale(scaleFactor)
    ..drawPicture(pictureInfo.picture);

  final rasterPicture = recorder.endRecording();

  final image = rasterPicture.toImageSync(width, height);
  final bytes = (await image.toByteData(format: ui.ImageByteFormat.png))!;

  return BitmapDescriptor.fromBytes(bytes.buffer.asUint8List());
}

