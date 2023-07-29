// import 'dart:io';
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:research_app/pages/video_page.dart';

// class CameraPage extends StatefulWidget {
//   const CameraPage({Key? key}) : super(key: key);

//   @override
//   _CameraPageState createState() => _CameraPageState();
// }

// class _CameraPageState extends State<CameraPage> {

//   bool _isLoading = true;
//   bool _isRecording = false;
//   late CameraController _cameraController;

//   _initCamera() async {
//   final cameras = await availableCameras();
//   final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
//   _cameraController = CameraController(front, ResolutionPreset.max);
//   await _cameraController.initialize();
//   setState(() => _isLoading = false);
// }

// _recordVideo() async {
//   if (_isRecording) {
//     final file = await _cameraController.stopVideoRecording();
//     setState(() => _isRecording = false);

//     final downloadDirectory = await getExternalStorageDirectory();
//     if (downloadDirectory == null) {
//       print('External storage directory not available.');
//       return;
//     }

//     // Create the "Download" folder if it doesn't exist
//     final downloadFolder = Directory('${downloadDirectory.path}/Download');
//     if (!await downloadFolder.exists()) {
//       await downloadFolder.create(recursive: true);
//     }

//     // Generate a unique filename for the video
//     final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
//     final String fileName = 'video_$currentTime.mp4';

//     // Create the destination path in the "Download" folder
//     final String destinationPath = '${downloadFolder.path}/$fileName';

//     // Copy the video file to the "Download" folder
//     final videoFile = File(file.path);
//     await videoFile.copy(destinationPath);

//     final route = MaterialPageRoute(
//       fullscreenDialog: true,
//       builder: (_) => VideoPage(filePath: file.path),
//     );
//     Navigator.push(context, route);
//   } else {
//     await _cameraController.prepareForVideoRecording();
//     await _cameraController.startVideoRecording();
//     setState(() => _isRecording = true);
//   }
// }

// @override
// void initState() {
//   super.initState();
//   _initCamera();
// }
  
//   @override
//   void dispose() {
//     _cameraController.dispose();
//     super.dispose();
//   }
  
//   @override
//   Widget build(BuildContext context) {
//     if (_isLoading) {
//       return Container(
//         color: Colors.white,
//         child: const Center(
//           child: CircularProgressIndicator(),
//         ),
//       );
//     } else {
//       return Center(
//   child: Stack(
//     alignment: Alignment.bottomCenter,
//     children: [
//       CameraPreview(_cameraController),
//       Padding(
//         padding: const EdgeInsets.all(25),
//         child: FloatingActionButton(
//           backgroundColor: Colors.red,
//           child: Icon(_isRecording ? Icons.stop : Icons.circle),
//           onPressed: () => _recordVideo(),
//         ),
//       ),
//     ],
//   ),
// );
//     }
//   }
// }