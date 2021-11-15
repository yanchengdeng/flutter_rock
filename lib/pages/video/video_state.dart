/// @description:
/// @author 
/// @date: 2021/08/02 09:50:08

import 'dart:async';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:video_player/video_player.dart';
import 'package:get/get.dart';
class VideoState {
  VideoPlayerController videoPlayerController;
  dynamic videoPath;                              //视频接口
  RxDouble dura;                                  //储存进度值                         
  RxBool flag;                                    //展示或收起进度栏
  RxBool isplaying;                               //视频播放状态
  RxInt now;
  List<String> parts; 
  VideoState() {
    videoPath=Get.arguments['video'];
    isplaying=true.obs;
    dura=0.0.obs;
    flag=false.obs;

    isNetWorkVideo(videoPath)?
    videoPlayerController = VideoPlayerController.network(videoPath):
    videoPlayerController = VideoPlayerController.file(File(videoPath));
    now=videoPlayerController.value.position.inSeconds.obs;
    
    // videoPlayerController 
    ///Initialize variables
  }

    bool isNetWorkVideo(dynamic url) {
    if(url.contains('https')){
      return true;
    }
    else return false;
  }
  
}
