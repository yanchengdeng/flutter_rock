/*
 * @Author: 凡琛
 * @Date: 2021-06-30 15:25:00
 * @LastEditTime: 2021-08-17 18:02:17
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/publish/publish_state.dart
 */

import 'dart:io';
import 'package:get/state_manager.dart';
import 'package:hdec_flutter/config/systemConfig.dart';
import 'package:video_player/video_player.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishState {
  RxInt maxImages;
  int maxDuration =
      SystemConfigInstance.getSystemConfig()['maxDurationVideo'] ?? 60;
  Rx<VideoPlayerController> controller;
  Rx<Future> initializeVideoPlayerFuture;
  File file;
  String videoUrl = '';
  List imageUrls = [];
  bool isUploadVideo = false;
  bool isUploadImages = false;
  int initialType = 0; //初始化岩石类别
  //提交信息
  int projectID; // 项目ID
  RxString projectName; // 项目名称
  int projectRockID = 1; // 项目岩石类别ID
  RxString location; // 地址信息
  RxString rockName; //岩石类别名称
  RxString mineralName; //矿物类别名称
  RxString weatheringStr;
  int weathering = 3; // 风化程度
  RxString integrityStr;
  int integrity = 2; // 完整程度
  RxString color; //颜色
  RxString occurrence; //产状
  RxDouble longitude; // 经度
  RxDouble latitude; // 维度
  String geoDescribe; // 描述
  String memo; // 备注
  List<File> medeia;
  RxInt isSelectered;
  RxList<Asset> images;
  Map currentUserInfo;
  RxList<AssetEntity> assets;
  RxList<AssetEntity> videoAsset;

  PublishState() {
    isSelectered = 0.obs;
    controller = VideoPlayerController.network('').obs;
    initializeVideoPlayerFuture = controller.value.initialize().obs;
    int count = SystemConfigInstance.getSystemConfig()['maxLimitImages'] ?? 30;
    maxImages = count.obs;
    images = <Asset>[].obs;
    assets = <AssetEntity>[].obs;
    videoAsset = <AssetEntity>[].obs;
    currentUserInfo = {}.obs;
    projectName = ''.obs;
    location = ''.obs;
    rockName = ''.obs;
    mineralName = ''.obs;
    longitude = 0.0.obs;
    latitude = 0.0.obs;
    weatheringStr = ''.obs;
    integrityStr = ''.obs;
    color = ''.obs;
    occurrence = ''.obs;
  }
}
