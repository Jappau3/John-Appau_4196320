import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_vision/google_ml_vision.dart';

import '../pdf.dart';
import 'button_custom.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // This creates an instance of the Google ML Vision Text Recognizer
  final TextRecognizer textRecognizer = GoogleVision.instance.textRecognizer();
  // This creates an instance of the FlutterTTS library to help us use the text to speech API
  final FlutterTts flutterTts = FlutterTts();
  // This creates an instance of the Image Picker library. This library helps us to choose an image from gallery or take a new picture with the camera.
  final imagePicker = ImagePicker();
  // Variable declarations
  PickedFile? pickedImage;
  File? imageFile;
  
  String? get extractedText => null;
  @override
  Widget build(BuildContext context) {
    // Sets speech rate
    double speechRate = 0.5;
    // Sets speech volume
    double speechVolume = 1;
    // Sets speech pitch
    double speechPitch = 1;

    Color background = const Color(0xFFF2EDFF);
    Color text = const Color.fromARGB(255, 255, 4, 4);

    return Scaffold(
      // This shows the blue App Bar with Audify text
      appBar: AppBar(
        title: Text(
          'TalkPDF',
          style: TextStyle(color: text),
        ),
        centerTitle: true,
        backgroundColor: background,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: text,
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return StatefulBuilder(builder: (context, setState) {
                      return AlertDialog(
                        backgroundColor: background,
                        title: const Text('Settings'),
                        content: SingleChildScrollView(
                          child: ListBody(
                            children: [
                              const Text('Speech Rate'),
                              Slider(
                                  activeColor: text,
                                  value: speechRate,
                                  min: 0,
                                  max: 1,
                                  divisions: 10,
                                  label: speechRate.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      speechRate = value;
                                    });
                                  }),
                              const Text('Speech Volume'),
                              Slider(
                                  activeColor: text,
                                  value: speechVolume,
                                  min: 0,
                                  max: 1,
                                  divisions: 10,
                                  label: speechVolume.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      speechVolume = value;
                                    });
                                  }),
                              const Text('Speech Pitch'),
                              Slider(
                                  activeColor: text,
                                  value: speechPitch,
                                  min: 0,
                                  max: 1,
                                  divisions: 10,
                                  label: speechPitch.toStringAsFixed(1),
                                  onChanged: (value) {
                                    setState(() {
                                      speechPitch = value;
                                    });
                                  })
                            ],
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              'Done',
                              style: TextStyle(color: text),
                            ),
                          )
                        ],
                      );
                    });
                  });
            },
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 50),
        color: background,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //This container shows an icon of a photo when an image is not selected and an actual photo when an image is selected
                Container(
                  child: imageFile == null
                      ? const Icon(
                          Icons.photo,
                          size: 50,
                        )
                      : Image.file(imageFile!, height: 301),
                ),
                const SizedBox(
                  height: 50,
                ),
                GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 30,
                  mainAxisSpacing: 30,
                  shrinkWrap: true,
                  children: [
                    // This button lets you pick an image from the gallery
                    CustomButton(
                      title: 'Pick image',
                      icon: Icons.add_photo_alternate_outlined,
                      onPressed: () {
                        setState(() {
                          pickImage(ImageSource.gallery);
                        });
                      },
                    ),
                    // This button lets you take a picture
                    CustomButton(
                      title: 'Take a picture',
                      icon: Icons.add_a_photo_outlined,
                      onPressed: () {
                        setState(() {
                          pickImage(ImageSource.camera);
                        });
                      },
                    ),
                    // This button makes the text to speech engine read the text found on the image
                    CustomButton(
                      title: 'Start reading',
                      icon: Icons.play_arrow_outlined,
                      onPressed: () async {
                        // The code in this block extracts the text from the selected image and reads it
                        GoogleVisionImage visionImage =
                            GoogleVisionImage.fromFile(imageFile!);
                        VisionText visionText =
                            await textRecognizer.processImage(visionImage);

                        // Convert the extracted text to PDF
                        File? pdfFile =
                            await PDFConverter.convertTextToPDF(extractedText!);

                        // Do something with the generated PDF file (e.g., display or share it)
                        if (pdfFile != null) {
                          // Add your code to handle the generated PDF file
                        }
                        speak(
                            text: visionText.text!,
                            volume: speechVolume,
                            pitch: speechPitch,
                            rate: speechRate);
                      },
                    ),
                    // This button makes the text to speech engine stops reading
                    CustomButton(
                      title: 'Stop reading',
                      icon: Icons.pause_outlined,
                      onPressed: () {
                        flutterTts.stop();
                      },
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // This function handles picking an image or taking a picture and cropping it
  void pickImage(ImageSource source) async {
    // ignore: deprecated_member_use
    pickedImage = await imagePicker.getImage(source: source);
    File? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedImage!.path,
        androidUiSettings: const AndroidUiSettings(
            lockAspectRatio: false,
            toolbarWidgetColor: Color(0xFF5C3882),
            toolbarTitle: 'Crop Photo',
            toolbarColor: Color(0xFFF2EDFF),
            statusBarColor: Color(0xFFF2EDFF),
            activeControlsWidgetColor: Color(0xFFF2EDFF),
            backgroundColor: Color.fromARGB(255, 44, 28, 85),
            hideBottomControls: true));
    setState(() {
      // imageFile = File(pickedImage!.path);
      imageFile = File(croppedFile!.path);
    });
  }

  // This function handles the voice, speed and speaking of the text to speech engine
  Future speak(
      {required String text,
      required double rate,
      required double pitch,
      required double volume}) async {
    await flutterTts.setVoice({"name": "en-gb-x-gba-local", "locale": "en-GB"});
    await flutterTts.setPitch(pitch);
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.speak(text);
  }
}
