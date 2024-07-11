import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:fractal/fractal.dart';
import 'package:fractal_flutter/index.dart';
import 'package:http/http.dart' as http;
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

// A screen that allows users to take a picture using a given camera.
class TakePictureScreen extends StatefulWidget {
  final void Function(ImageF f) onSelected;

  const TakePictureScreen({
    Key? key,
    required this.onSelected,
  }) : super(key: key);

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
  }

  setCam(int num) async {
    final cameras = await availableCameras();

    final cam = (num == 1) ? cameras.first : cameras.last;
    _controller = CameraController(
      cam,
      ResolutionPreset.medium,
    );

    _controller.initialize().then((value) {
      setState(
        () {
          camNum = num;
        },
      );
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  bool loading = true;

  int camNum = 0;

  FlashMode flash = FlashMode.auto;

  @override
  Widget build(BuildContext context) {
    if (camNum == 0) {
      setCam(1);
      return const Center(child: CircularProgressIndicator());
    }

    return Stack(children: [
      CameraPreview(_controller),
      Positioned(
        bottom: 1,
        right: 1,
        child: IconButton(
          onPressed: () async {
            final f = await FractalImage.pick();
            if (f != null) {
              widget.onSelected(f);
            }
          },
          icon: const Icon(Icons.upload_file),
        ),
      ),
      Positioned(
        bottom: 1,
        left: 1,
        child: IconButton(
          onPressed: () async {
            setCam((camNum == 1) ? 2 : 1);
          },
          icon: const Icon(Icons.flip_camera_ios),
        ),
      ),
      Positioned(
        bottom: 1,
        left: 40,
        child: IconButton(
          onPressed: () async {
            setState(() {
              if ((flash == FlashMode.auto))
                flash = FlashMode.torch;
              else if ((flash == FlashMode.torch)) flash = FlashMode.auto;

              _controller.setFlashMode(flash);
            });
          },
          iconSize: 12,
          icon: Icon(
              (flash == FlashMode.auto) ? Icons.flash_auto : Icons.flash_on),
        ),
      ),
      IconButton(
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            final img = await _controller.takePicture();
            final f = ImageF.bytes(await img.readAsBytes());
            widget.onSelected(f);

            // If the picture was taken, display it on a new screen.
            /*
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => DisplayPictureScreen(
                  // Pass the automatically generated path to
                  // the DisplayPictureScreen widget.
                  imagePath: image.path,
                ),
              ),
            );
            */
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        icon: const Icon(Icons.camera_alt),
      ),
    ]);
  }
}
