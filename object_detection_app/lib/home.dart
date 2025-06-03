import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite/tflite.dart';
import 'main.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isWorking = false;
  String result = '';
  CameraController? cameraController;
  CameraImage? imgCamera;

  get response => null;

  initCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value) {
      if (!mounted) {
        return;
      }
      setState(() {
        cameraController!.startImageStream(
          (imageFromStream) => {
            if (!isWorking) {isWorking = true, imgCamera = imageFromStream},
          },
        );
      });
    });
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labelsFruits.txt",
    );
  }

  @override
  void initState() {
    super.initState();

    loadModel();
  }

  @override
  Future<void> dispose() async {
    super.dispose();

    await Tflite.close();
    cameraController!.dispose();
  }

  runModelOnStreamFrames() async {
    var recognition = await Tflite.runModelOnFrame(
      bytesList:
          imgCamera!.planes.map((plane) {
            return plane.bytes;
          }).toList(),
      imageHeight: imgCamera!.height,
      imageWidth: imgCamera!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true,
    );

    result = '';
    recognition!.forEach((element) {
      result +=
          response['label'] +
          ' ' +
          (response['confidence'] as double).toStringAsFixed(2) +
          '\n\n';
    });
    setState(() {
      result;
    });

    isWorking = false;
  }
@override
Widget build(BuildContext context) {
  return SafeArea(
    child: Column(
      children: [
        AppBar(
          title: Text('Fruits Detector App GetX'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/back.jpg'),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    ),
  );
}

  
}


