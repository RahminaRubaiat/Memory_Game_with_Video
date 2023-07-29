import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:research_app/pages/memory_game.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: ScreenUtil().screenHeight,
            width: ScreenUtil().screenWidth,
            color: Colors.transparent,
            child: Column(
              children: [
                GestureDetector(
                  onTap: (){
                    Get.to(const MemoryGame());
                  },
                  child: customCard("Memory Test","Flip the card to find all matching pairs of images","assets/images/Card.jpg"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

   customCard(String str,String str2,String path){
    return  Padding(
      padding: EdgeInsets.only(left:ScreenUtil().setSp(10),right: ScreenUtil().setSp(10),top:ScreenUtil().setSp(2)),
      child: Card(
        color: Colors.white,
        child: ListTile(
          leading: Image(image: AssetImage(path)),
          title: Text(str),
          subtitle: Text(str2)
        ),
      ),
    );
  }
}