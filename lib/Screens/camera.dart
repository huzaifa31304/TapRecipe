import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tap_recipe/Screens/homepage.dart';
import 'package:tflite/tflite.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import '../main.dart';



class Camera_Page extends StatefulWidget {
  const Camera_Page({super.key});

  @override
  State<Camera_Page> createState() => _Camera_PageState();
}

class _Camera_PageState extends State<Camera_Page> {

  Interpreter? _interpreter;

  bool isWorking = false;
  String result="";
  CameraController ?cameraController;
  CameraImage ?imgCamera;

  Future loadModel() async {
    Tflite.close();
    String res;
    res=(await Tflite.loadModel(
      model: 'resources/images/model_unquant2.tflite',
      labels: 'resources/images/labels2.txt',))!;
    print("model loading status: $res");

  }


  
  initCamera(){
    cameraController = CameraController(cameras![0],ResolutionPreset.max);
    cameraController?.initialize().then((value)
    {
      if(!mounted)
      {
        return;
      }

      setState(()
      {
        cameraController?.startImageStream((imageFromStream)=>
        {
          if(!isWorking)
          {
            isWorking=true,
            imgCamera= imageFromStream,
            runModelOnStreamFrames(),
          }
        });
      });
    });
  }


  runModelOnStreamFrames() async{
    if(imgCamera != null) {
      var recognitions = await Tflite.runModelOnFrame(
        bytesList: imgCamera!.planes.map((plane)
            {
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
      result = "";
      recognitions!.forEach((response)
      {
        result += response["label"] + "  " + (response['confidence']as double).toStringAsFixed(2) + '\n\n';
      });

      setState(() {
        result;
      });
      isWorking = false;
    }
  }


  @override
  void initState() {
    super.initState();
    initCamera();
    loadModel();
  }


  @override
  void dispose() async{
    super.dispose();
    _interpreter?.close();
    cameraController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon
                (
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: (){Navigator.of(context).pop(
                  MaterialPageRoute(
                    builder: (context) => Home(),
                  ));},
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Ingredient Detection",
                  style: GoogleFonts.dancingScript(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.white,
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("resources/images/C_back.jpg"),
              )
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    // Center(
                    //   child: Container(
                    //     height: 350,
                    //     width: 350,
                    //     child: Image.asset("resources/images/cheflogo2"),
                    //   ),
                    // ),
                    Center(
                      child: MaterialButton(
                        onPressed: (){
                          initCamera();
                        },
                        child: Container(
                          margin: EdgeInsets.only(top:31 ),
                          height: 350,
                          width: 350,
                          child: imgCamera == null
                              ? Container(
                            height: 350,
                            width: 300,
                            child: Icon(
                                Icons.camera,
                                color: Colors.black,
                                size: 45
                            ),
                          )
                              : AspectRatio(
                            aspectRatio: cameraController!.value.aspectRatio,
                            child: CameraPreview(cameraController!),
                          ),
                        ),
                      ),
                    )
                  ],
                ),

                Center(
                  child: Container(
                    margin: EdgeInsets.all( 30.0),
                    child: SingleChildScrollView(
                      child: Text(
                        result,
                        style: TextStyle(
                          backgroundColor: Colors.transparent,
                          fontSize: 20,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
