import 'package:flutter/material.dart';
import 'package:rillcuy/camera/camera_viewer.dart';
import 'package:rillcuy/camera/capture_button.dart';
import 'package:rillcuy/camera/top_image_viewer.dart';




class CameraScreen extends StatelessWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        CameraViewer(),
        CaptureButton(),
        TopImageViewer()
      ],
    );
  }
}