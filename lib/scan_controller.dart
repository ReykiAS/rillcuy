import 'dart:typed_data';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/state_manager.dart';
import 'package:camera/camera.dart';
import 'package:get/get.dart';


class ScanController extends GetxController {

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  CameraImage? _cameraImage;
  final RxList<Uint8List> _imageList = RxList([]);


  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  List<Uint8List> get imageList => _imageList;


  @override
  void dispose() {
    _isInitialized.value = false;
    _cameraController.dispose();
    Tflite.close();
    super.dispose();
  }

  Future<void> _initTensorFlowLite() async{
    String? res = await Tflite.loadModel(
    model: "assets/fisika.tflite",
    labels: "assets/labels.txt",
    numThreads: 1, // defaults to 1
    isAsset: true, // defaults to true, set to false to load resources outside assets
    useGpuDelegate: false // defaults to false, set to true to use GPU delegate
);

  }


  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    _cameraController.initialize().then((value) {
      _isInitialized.value = true;
      _cameraController.startImageStream((image) => _cameraImage = image);

      _isInitialized.refresh();
    })
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void onInit() {
    initCamera();
    _initTensorFlowLite();
    super.onInit();
  }

  Future<void> objectRecognation(CameraImage cameraImage) async {
    /* var recognitions = await Tflite.runModelOnFrame(
      bytesList: cameraImage.planes.map((plane) {return plane.bytes;}).toList(),// required
      imageHeight: cameraImage.height,
      imageWidth: cameraImage.width,
      imageMean: 127.5,   // defaults to 127.5
      imageStd: 127.5,    // defaults to 127.5
      rotation: 90,       // defaults to 90, Android only
      numResults: 2,      // defaults to 5
      threshold: 0.1,     // defaults to 0.1
      asynch: true        // defaults to true
      
  ); */
        var recognitions = await Tflite.detectObjectOnFrame(
        bytesList: cameraImage.planes.map((plane) {return plane.bytes;}).toList(),// required
        model: "YOLO",  
        imageHeight: cameraImage.height,
        imageWidth: cameraImage.width,
        imageMean: 0,         // defaults to 127.5
        imageStd: 255.0,      // defaults to 127.5
        threshold: 0.1,       // defaults to 0.1
        numResultsPerClass: 2,// defaults to 5
        // anchors: [0.57273,0.677385,1.87446,2.06253,3.33843,5.47434,7.88282,3.52778,9.77052,9.16828],     // defaults to [0.57273,0.677385,1.87446,2.06253,3.33843,5.47434,7.88282,3.52778,9.77052,9.16828]
        blockSize: 32,        // defaults to 32
        numBoxesPerBlock: 5,  // defaults to 5
        asynch: true          // defaults to true
      );
    if(recognitions!=null){
      print(recognitions);
    }
   
  

  }
  

  void capture() {
   
  }
}

