import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:research_app/pages/homepage.dart';
import 'package:research_app/pages/video_page.dart';

class MemoryGame extends StatefulWidget {
  const MemoryGame({super.key});

  @override
  State<MemoryGame> createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {

String front = "assets/images/flower.png";
int second = 1;

  //Yellow Circle
  GlobalKey<FlipCardState> element1Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element2Card = GlobalKey<FlipCardState>();
  bool checkElement1 = false;
  bool checkElement2 = false;
  String element1 = "1";
  String element2 = "2";
 
  //Two Rectangle
  GlobalKey<FlipCardState> element3Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element4Card = GlobalKey<FlipCardState>();
  bool checkElement3 = false;
  bool checkElement4 = false;
  String element3 = "3";
  String element4 = "4";

  //Triangle
  GlobalKey<FlipCardState> element5Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element6Card = GlobalKey<FlipCardState>();
  bool checkElement5 = false;
  bool checkElement6 = false;
  String element5 = "5";
  String element6 = "6";

  //Polygon
  GlobalKey<FlipCardState> element7Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element8Card = GlobalKey<FlipCardState>();
  bool checkElement7 = false;
  bool checkElement8 = false;
  String element7 = "7";
  String element8 = "8";

  //Rectangle
  GlobalKey<FlipCardState> element9Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element10Card = GlobalKey<FlipCardState>();
  bool checkElement9 = false;
  bool checkElement10 = false;
  String element9 = "9";
  String element10 = "10";

  //Circle Blue
  GlobalKey<FlipCardState> element11Card = GlobalKey<FlipCardState>();
  GlobalKey<FlipCardState> element12Card = GlobalKey<FlipCardState>();
  bool checkElement11 = false;
  bool checkElement12 = false;
  String element11 = "11";
  String element12 = "12";

@override
  void initState() {
    super.initState();
    _initCamera();
    startTimer2();
    pageEnterTime = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showStartMessage();
    });
    //print(pageEnterTime); 
  }


int startTime = 0;
  void startTimer(){
    //showStartMessage();
    Timer.periodic(const Duration(seconds: 1), (timer) { 
      setState(() {
        startTime++;
      });
    });
  }

  DateTime ? pageEnterTime;
  String str = " 0 0 0 0 0 0 0 0 0 0 0 0";
  String str2 = "";
  Map<String,String> timeStore = {};
  Timer ? time;
  double c = 0.0;
  bool tap = false;
  List<dynamic> n = [0,0,0,0,0,0,0,0,0,0,0,0];

  void startTimer2() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
        time = Timer.periodic(const Duration(milliseconds: 100), (timer) {
         setState(() {
           c += 0.1;
          //  print(c.toStringAsFixed(1) +" : "+ n.toString());
          //  str2 = "$str2 ${c.toStringAsFixed(1)} : $n ,";
          //  timeStore [c.toStringAsFixed(1)] = str;
         });
      });
    });
  }



showStartMessage(){
  return showDialog(
    context: context,
     builder: (context) {
       return AlertDialog(
        title: const Text("Memory game"),
        content: const Text("Find the all pair of cards"),
        actions: [
          TextButton(
            onPressed: (){
              startTimer();
              _startRecord();
              Navigator.pop(context);
            }, 
            child: const Text("Start"),
          ),
        ],
       );
     },
  );
}  


  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }


  bool firstFlip = false;
  int firstFlipTime = 0;
  String sequence = "";
  int flip = 0,sucess = 0;
  List<int> sucessFlip = [];
  List<int> sucessTime = [];
  List<int> timeGap = [];
  int prev = 0;
  int count = 0;
  int card1=0,card2=0,card3=0,card4=0,card5=0,card6=0,card7=0,card8=0,card9=0,card10=0,card11=0,card12=0;
  double card1Pressure=0;

  void handleTapDown(TapDownDetails details){
    final force = details as ForcePressDetails;
    setState(() {
      card1Pressure = force.pressure;
    });
  }

 int pos = 0;
 String cardPosition = "";
 Map<int,String> cardRegion = {};

  void calculatePosition(TapUpDetails details,int n) {
    final cardHeight = 450.h;
    final cardWidth = 300.w;
    final offsetX = details.localPosition.dx - cardWidth / 2;
    final offsetY = details.localPosition.dy - cardHeight / 2;

    if (offsetY < -cardHeight / 4) {
      //position = 'Top';
      pos = 0;
    } else if (offsetY > cardHeight / 4) {
      //position = 'Bottom';
      pos = 6;
    } else {
      //position = 'Middle';
      pos = 3;
    }

    if (offsetX < -cardWidth / 4) {
      //position = '${position} Left';
      pos+=1;
    } else if (offsetX > cardWidth / 4) {
      //position = '${position} Right';
      pos+=3;
    } else {
      //position = '${position} Middle';
      pos+=2;
    }

    var temp = cardRegion[n];
    temp ??= "";
    cardPosition = "$temp $pos";
    cardRegion[n] = cardPosition;
    cardPosition = "";
    //print(cardRegion);
  }

  Map<String,int> screenRegion ={};
  void screenDetails(TapUpDetails details,int p,int x){
    final tapPosition = details.localPosition;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final containerWidth = screenWidth / 3;
    final containerHeight = screenHeight / 4;

    final tappedColumn = (tapPosition.dx / containerWidth).floor();
    final tappedRow = (tapPosition.dy / containerHeight).floor();
    var tappedPart = (tappedRow * 3) + tappedColumn;
    tappedPart++;
    String key = c.toStringAsFixed(1);
    if(x==0){
      screenRegion[key]=tappedPart;
    }
    else{
      screenRegion[key]=p;
    }
    //print('Pressed part: $screenRegion');
  }

  Map<String,String> xyCoordinate={};
  void screenXYCoordinate(TapUpDetails details){
    final RenderBox box = context.findRenderObject() as RenderBox;
          final Offset localOffset = box.globalToLocal(details.globalPosition);
          final double x = localOffset.dx;
          final double y = localOffset.dy;
          String key = c.toStringAsFixed(1);
          String posX = x.toString();
          String posY = y.toString();
          xyCoordinate[key]= "X: $posX Y: $posY";
          //print(xyCoordinate);
  }

 Map<String,String> cardNumber = {};
 void pressedCardNumber(String number){
     String key = c.toStringAsFixed(1);
     cardNumber[key]=number;
     //print(cardNumber);
 }

 Map<String,int> sucessCount={};
 int s = 0;
 void sucessCardCount(){
    String key = c.toStringAsFixed(1);
    sucessCount[key]=s;
    //print(sucessCount);
 }

 bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  _initCamera() async {
  final cameras = await availableCameras();
  final front = cameras.firstWhere((camera) => camera.lensDirection == CameraLensDirection.front);
  _cameraController = CameraController(front, ResolutionPreset.max);
  await _cameraController.initialize();
  setState(() => _isLoading = false);
}

_stopRecord() async {
  if (_isRecording) {
    final file = await _cameraController.stopVideoRecording();
    setState(() => _isRecording = false);

    final downloadDirectory = await getExternalStorageDirectory();
    if (downloadDirectory == null) {
      //print('External storage directory not available.');
      return;
    }

    // Create the "Download" folder if it doesn't exist
    final downloadFolder = Directory('${downloadDirectory.path}/Download');
    if (!await downloadFolder.exists()) {
      await downloadFolder.create(recursive: true);
    }

    // Generate a unique filename for the video
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String fileName = 'video_$currentTime.mp4';

    // Create the destination path in the "Download" folder
    final String destinationPath = '${downloadFolder.path}/$fileName';

    // Copy the video file to the "Download" folder
    final videoFile = File(file.path);
    await videoFile.copy(destinationPath);
    
    Get.to(VideoPage(filePath: file.path));
  } 
}

_startRecord() async{
    await _cameraController.prepareForVideoRecording();
    await _cameraController.startVideoRecording();
    setState(() => _isRecording = true);
}
  @override
   Widget build(BuildContext context) { 
    return SafeArea(
      child: Scaffold(
        body: GestureDetector(
            onTapUp: (TapUpDetails details) {
            screenDetails(details,0,0);
            screenXYCoordinate(details);
          },
          child: Container(
            height: double.maxFinite.h,
            width: double.maxFinite.w,
            color: Colors.transparent,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: (){
                        Get.to(const HomePage());
                     },
                     child: const Text("Back",
                     style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(166, 207, 207, 11),
                       ),
                     )
                     ),
                     Text('$startTime',
                     style: TextStyle(
                      fontSize: 50.sp,
                     ),
                     ),
                     Container(
                      height: 100.h,
                      width: 200.w,
                      color: Colors.white,
                      child: (_isLoading) ? const Center(
                        child: CircularProgressIndicator(),
                      ) : CameraPreview(
                        _cameraController,
                      ),
                     ),
                     Container(
                      height: 80.h,
                      width: 80.w,
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        shape: BoxShape.circle
                      ),
                      child: Center(
                        child: (_isRecording)?const Icon(Icons.stop,color: Colors.white,) : const Icon(Icons.fiber_manual_record,color: Colors.white),
                      ),
                     ),
                     TextButton(
                      onPressed: (){
                        _stopRecord();
                     },
                     child: const Text("Submit",
                     style: TextStyle(
                          fontSize: 20,
                          color: Color.fromARGB(166, 207, 207, 11),
                          ),
                     )
                     ),
                  ],
                ),
        
        
                //FlipCard
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,1);
                          screenDetails(details, 1, 1);
                          element3Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("1");
                          sucessCardCount();
                          // tap = true;
                          double x = c;
                          x+=0.1;
                          n[0]=x.toStringAsFixed(1);
                        },
                        child: FlipCard( 
                          key: element3Card,
                          flipOnTouch: false,
                          onFlip: (){
                            element3 = "element3";
                            checkElement3 = !checkElement3;
                            if(firstFlip==false){
                                firstFlipTime = startTime;
                                firstFlip = true;
                            } 
                            setState(() {
                      
                            });
                            if(checkElement3==true){
                              flipElement3();
                            }
                            else{
                              element3 = "3";
                            }
                          },
                          front: customCard(front), 
                          back: customCard('assets/images/TwoRectangle.png'),
                        ),
                      ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,2);
                          screenDetails(details, 2, 1);
                          element1Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("2");
                          sucessCardCount();
                          
                          str2 = str.replaceRange(3, 3 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[1]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element1Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element1 = "element1";
                          checkElement1 = !checkElement1;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement1==true){
                            flipElement1();
                          }
                          else{
                            element1 = "1";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/CircleYellow.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,3);
                          screenDetails(details, 3, 1);
                          element2Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("3");
                          sucessCardCount();

                          str2 = str.replaceRange(5, 5 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[2]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element2Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element2 = "element2";
                          checkElement2 = !checkElement2;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement2==true){
                            flipElement2();
                          }
                          else{
                            element2 = "2";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/CircleYellow.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,4);
                          screenDetails(details, 4, 1);
                          element5Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("4");
                          sucessCardCount();

                          str2 = str.replaceRange(7, 7 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[3]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element5Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element5 = "element5";
                          checkElement5 = !checkElement5;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement5==true){
                            flipElement5();
                          }
                          else{
                            element5 = "5";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Triangle.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,5);
                          screenDetails(details, 5, 1);
                          element7Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("5");
                          sucessCardCount();

                          str2 = str.replaceRange(9, 9 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[4]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element7Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element7 = "element7";
                          checkElement7 = !checkElement7;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement7==true){
                            flipElement7();
                          }
                          else{
                            element7 = "7";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Polygon.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,6);
                          screenDetails(details, 6, 1);
                          element9Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("6");
                          sucessCardCount();

                          str2 = str.replaceRange(11, 11 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[5]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element9Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element9 = "element9";
                          checkElement9 = !checkElement9;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement9==true){
                            flipElement9();
                          }
                          else{
                            element9 = "9";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Rectangle.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,7);
                          screenDetails(details, 7, 1);
                          element4Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("7");
                          sucessCardCount();

                          str2 = str.replaceRange(13, 13 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[6]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element4Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element4 = "element4";
                          checkElement4 = !checkElement4;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement4==true){
                            flipElement4();
                          }
                          else{
                            element4 = "4";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/TwoRectangle.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,8);
                          screenDetails(details, 8, 1);
                          element6Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("8");
                          sucessCardCount();

                          str2 = str.replaceRange(15, 15 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[7]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element6Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element6 = "element6";
                          checkElement6 = !checkElement6;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement6==true){
                            flipElement6();
                          }
                          else{
                            element6 = "6";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Triangle.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,9);
                          screenDetails(details, 9, 1);
                          element11Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("9");
                          sucessCardCount();

                          str2 = str.replaceRange(17, 17 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[8]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element11Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element11 = "element11";
                          checkElement11 = !checkElement11;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement11==true){
                            flipElement11();
                          }
                          else{
                            element11 = "11";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/CircleBlue.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,10);
                          screenDetails(details, 10, 1);
                          element10Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("10");
                          sucessCardCount();

                          str2 = str.replaceRange(19, 19 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[9]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element10Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element10 = "element10";
                          checkElement10 = !checkElement10;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement10==true){
                            flipElement10();
                          }
                          else{
                            element10 = "10";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Rectangle.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,11);
                          screenDetails(details, 11, 1);
                          element12Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("11");
                          sucessCardCount();

                          str2 = str.replaceRange(21, 21 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[10]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element12Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element12 = "element12";
                          checkElement12 = !checkElement12;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement12==true){
                            flipElement12();
                          }
                          else{
                            element12 = "12";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/CircleBlue.png'),
                      ),
                    ),
                    GestureDetector(
                      onTapUp: (TapUpDetails details) {
                        setState(() {
                          screenXYCoordinate(details);
                          calculatePosition(details,12);
                          screenDetails(details, 12, 1);
                          element8Card.currentState?.toggleCard();
                         });
                        },
                        onTap: (){
                          pressedCardNumber("12");
                          sucessCardCount();

                          str2 = str.replaceRange(23, 23 + 1, '1');
                          tap = true;
                          double x = c;
                          x+=0.1;
                          n[11]=x.toStringAsFixed(1);
                        },
                      child: FlipCard(
                        key: element8Card,
                        flipOnTouch: false,
                        onFlip: (){
                          element8 = "element8";
                          checkElement8 = !checkElement8;
                          if(firstFlip==false){
                              firstFlipTime = startTime;
                              firstFlip = true;
                          }
                          setState(() {
                            
                          });
                          if(checkElement8==true){
                            flipElement8();
                          }
                          else{
                            element8 = "8";
                          }
                        },
                        front: customCard(front), 
                        back: customCard('assets/images/Polygon.png'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget customCard(String path){
    return Container(
        margin: EdgeInsets.only(top:40.h),
        height: 450.h,
        width: 300.w,  
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(Radius.circular(30.sp)),
          border: Border.all(
            width: 5.sp,
          )
        ),
        child: Image(
          height: 350.h,
          width: 350.w,
          image: AssetImage(path)
        ),
    );
  }
  
List valueOfCard = [];
List<GlobalKey<FlipCardState>> cardKeys = [];

 void sucessCard(){
  int a = valueOfCard.elementAt(0);
  int b = valueOfCard.elementAt(1);
    if((a-b)!=0){
      Timer(const Duration(seconds: 1), () {
        cardKeys.elementAt(0).currentState!.toggleCard();
        cardKeys.elementAt(1).currentState!.toggleCard();
        count=0; 
        cardKeys.clear();
        valueOfCard.clear();
       }); 
    }
    else{
      s++;
      count=0; 
      cardKeys.clear();
      valueOfCard.clear();
      sucess++;
      sucessFlip.add(flip);
      sucessTime.add(startTime);
    }
 }

 

 void flipElement1(){
    // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"2nd ";
    card2++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(2);
    cardKeys.add(element1Card);
    
    if(count==2){
      sucessCard();
    }
  }
 void flipElement2(){
    // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"3rd ";
    card3++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(2);
    cardKeys.add(element2Card);

    if(count==2){
      sucessCard();
    }
  }
 void flipElement3(){
    // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"1st ";
    card1++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(4);
    cardKeys.add(element3Card);

    if(count==2){
      sucessCard();
    } 
  }
 void flipElement4(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"7th ";
    card7++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(4);
    cardKeys.add(element4Card);

    if(count==2){
      sucessCard();
    }
  }

 void flipElement5(){
   // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"4th ";
    card4++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(6);
    cardKeys.add(element5Card);

    if(count==2){
      sucessCard();
    }
  }
 void flipElement6(){
   // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"8th ";
    card8++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(6);
    cardKeys.add(element6Card);

    if(count==2){
      sucessCard();
    }
  }
 
 void flipElement7(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"5th ";
    card5++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(8);
    cardKeys.add(element7Card);

    if(count==2){
      sucessCard();
    }
  }
 void flipElement8(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"12th ";
    card12++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(8);
    cardKeys.add(element8Card);

    if(count==2){
      sucessCard();
    }
  }

 void flipElement9(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"6th ";
    card6++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(10);
    cardKeys.add(element9Card);

    if(count==2){
      sucessCard();
    }
  }
 void flipElement10(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"10th ";
    card10++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(10);
    cardKeys.add(element10Card);

    if(count==2){
      sucessCard();
    }
  } 

 void flipElement11(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"9th ";
    card9++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(12);
    cardKeys.add(element11Card);

    if(count==2){
      sucessCard();
    }
  }
 void flipElement12(){
  // ignore: prefer_interpolation_to_compose_strings
    sequence = sequence+"11th ";
    card11++;
    flip++;
    timeGap.add(startTime-prev);
    prev = startTime;
    count++;
    valueOfCard.add(12);
    cardKeys.add(element12Card);

    if(count==2){
      sucessCard();
    }
  } 
}