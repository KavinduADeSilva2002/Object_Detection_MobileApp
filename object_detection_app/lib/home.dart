import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:tflite_v2/tflite_v2.dart';
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
          child: Column(
            children:[
              Stack(
                children:[
                  Center(
                    child:Container(
                      margin: EdgeInsets.only(top:100.0),
                      height: 220,
                      width: 320,
                      child: Image.asset('assets/frame.jpg'),
                    ),
                  ),
                  Center(child: TextButton(
                    onPressed: () {
                      initCamera();
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 65.0),
                      height: 100,
                      width: 100,
                      child: imgCamera==null? Icon(Icons.photo_camera_front, color: Colors.pink, size: 60.0): 
                      AspectRatio(
                        aspectRatio: cameraController!.value.aspectRatio,
                        child: CameraPreview(cameraController!),
                      )
                      
                  )))
                ],
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.only(top:55.0),
                  child: SingleChildScrollView(
                    child: Text(
                      result,
                      style: TextStyle(
                        backgroundColor: Colors.black87,
                        fontSize: 25.0,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

  
}


