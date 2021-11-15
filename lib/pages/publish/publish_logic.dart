/*
 * @Author: 凡琛
 * @Date: 2021-06-30 15:25:00
 * @LastEditTime: 2021-08-13 18:15:57
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/publish/publish_logic.dart
 */
import 'dart:io';
import 'package:get/get.dart';
import 'package:hdec_flutter/pages/medeia/medeia_logic.dart';
import 'publish_state.dart';
import '../../utils/picker.dart';
import '../../http/http.dart';
import '../../api/system.dart';
import 'request.dart';
import 'package:jhtoast/jhtoast.dart';
import 'package:oktoast/oktoast.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import '../../config/projectConfig.dart';
import '../../utils/storage/localStorage.dart';
import '../../utils/dataBiz.dart';
import 'package:city_pickers/city_pickers.dart';
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import '../../widgets/bottom_sheet.dart';
import '../medeia/medeia_logic.dart';
import '../../utils/storage/authorStorage.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishLogic extends GetxController {
  final state = PublishState();
  Location location;
  final medeialogic = MedeiaLogic();
  @override
  void onReady() {
    super.onReady();
    getLocation();
    state.currentUserInfo = StorageUtils.getModelWithKey(KEY_USER_DEFAULT_INFO);
  }

  @override
  void onClose() {
    if (state.controller != null) {
      state.controller.value.dispose();
    }
    PublishRequest.stopLocation();
    super.onClose();
  }

  void getLocation() async {
    location = await PublishRequest.getCurrentLocation();
  }

  void setVideoController(File file) {
    VideoPlayerController controller = VideoPlayerController.file(file);
    controller.setLooping(false);
    Future initializeVideoPlayerFuture = controller.initialize();
    state.file = file;
    state.controller.value = controller;
    state.initializeVideoPlayerFuture.value = initializeVideoPlayerFuture;
    state.isSelectered.value = 1;
  }

// 底部弹框组件
  void bottomSheet(String title, List<String> dataList) {
    HdBottomSheet.showText(Get.context, dataArr: dataList, title: title,
        clickCallback: (index, text) {
      if (index == 0) {
        return;
      }
      switch (title) {
        case '风化程度':
          state.weathering = index;
          state.weatheringStr.value = text;
          break;
        case '完整程度':
          state.integrity = index;
          state.integrityStr.value = text;
          break;
        default:
      }
    });
  }

// 选取媒体文件为路径
  Future<List<File>> convert(List<AssetEntity> assets) async {
    print('convert_s:${DateTime.now().millisecond}');
    List<File> _assets = [];
    for (var i = 0; i < assets.length; i++) {
      AssetEntity asset = assets[i];
      File file = await asset.originFile;
      _assets.addNonNull(file);
    }
    print('convert_e:${DateTime.now().millisecond}');
    return _assets;
  }

  // 统一切换
  void dealWithSelecter(int index) async {
    switch (index) {
      case 0:
        // 关闭会返回null，组件问题😭
        state.assets.value = await getAssetFromGallery(
                state.maxImages.value, state.assets, RequestType.image) ??
            [];
        if (state.assets.isNotEmpty) {
          state.medeia = await convert(state.assets);
        }
        break;
      case 1:
        AssetEntity asset = await getTakeAssetFromCamera(false);
        state.assets.addNonNull(asset);
        break;
      case 2:
        List<AssetEntity> videoAsset =
            await getAssetFromGallery(1, state.videoAsset, RequestType.video) ??
                [];
        if (videoAsset.length > 0 &&
            videoAsset[0].duration > state.maxDuration) {
          showToast('视频超过${state.maxDuration}s');
          break;
        }
        state.videoAsset.value = videoAsset;

        File file = state.videoAsset?.isNotEmpty == true
            ? await state.videoAsset[0].originFile
            : null;
        state.file = file;
        if (file != null) {
          setVideoController(state.file);
        } else {
          state.isSelectered.value = 0;
        }
        break;
      case 3:
        AssetEntity asset =
            await getTakeAssetFromCamera(true, state.maxDuration);
        if (asset == null) break;
        if (asset != null && asset.typeInt != 2) {
          showToast('请长按录制视频');
          break;
        }
        state.file = await asset.originFile; //await getVideoFromCamera();
        setVideoController(state.file);
        break;
      default:
        break;
    }
  }

// 项目列表页
  void openProjectPage() async {
    var result = await Get.toNamed('/project', arguments: {'tag': 1});
    //处理返回结果
    if (result != null) {
      state.projectID = result['ProjectID'];
      state.projectName.value = result['ProjectName'];
    }
  }

  // 地址选择
  void openLocationPage() async {
    try {
      Result result =
          await CityPickers.showFullPageCityPicker(context: Get.context);
      state.location.value =
          result.provinceName + '|' + result.cityName + '|' + result.areaName;
    } catch (error) {
      print('error:$error');
    }
  }

  // 地图选点
  void openMapPage() async {
    var result = await Get.toNamed('/amap?showSave=true');
    if (result != null) {
      state.longitude.value = result['longitude'];
      state.latitude.value = result['latitude'];
    }
  }

  void openMedeiaPage(RxList images) async {
    await Get.toNamed('/mediea', arguments: {'tag': 1});
  }

// 点击图片cell跳转
  void onTapImageAsset(var asset, int index) {
    if (state.medeia != null) {
      Get.toNamed('/medeia',
          arguments: {'images': state.medeia, 'index': index});
    }
  }

  // 删除图片
  void onRemoveAsset(index) {
    state.assets.removeAt(index);
  }

  // 岩石 & 矿物选择页面
  void openSelecterPage(String type) async {
    var result = await Get.toNamed('/selecter', arguments: {'tag': type});
    if (result != null) {
      state.rockName.value = result.name;
      state.initialType = int.parse(result.code);
    }
  }

  //播放视频
  void playVideo() {
    // 跳转播放器页面
    if (state.file != null) {
      Get.toNamed('/video', arguments: {'video': state.file.path});
    }
  }

  // 图片批量上传
  Future uploadImages(String fileId) async {
    if (state.assets.length <= 0) return;
    state.isUploadImages = true;
    var formData = await PublishRequest.dealWithImageData(state.assets, fileId);
    // 图片上传接口
    await HttpRequest.post(SystemApi.upLoadFiles, formData,
        success: (result) {
          state.imageUrls = result['data']['urls'];
          state.isUploadImages = false;
          return result['data']['urls'];
        },
        fail: (error) {},
        progress: (int sent, int total) {
          print("$sent - $total");
        });
  }

  // 视频上传
  Future uploadVideo(String fileId) async {
    if (state.file == null) {
      return;
    }
    String path = state.file.path;
    state.isUploadVideo = true;
    var formData = await PublishRequest.dealWithVideoData(path, fileId);
    // 上传接口
    await HttpRequest.post(SystemApi.upLoadFile, formData, success: (result) {
      state.videoUrl = result['data']['url'];
      state.isUploadVideo = false;
      return result['data']['url'];
    }, fail: (error) {});
  }

  // 描述输入
  describe(String context) {
    state.geoDescribe = context;
    print(context);
  }

  // 备注输入
  memo(String context) {
    state.memo = context;
    print(context);
  }

  // 发布
  publish(BuildContext context) async {
    if (state.isUploadImages || state.isUploadVideo) {
      return;
    }
    //非空数据校验
    if (isEmpty(state.currentUserInfo['userId']) ||
        isEmpty(state.projectID) ||
        isEmpty(state.projectRockID) ||
        isEmpty(state.initialType) ||
        state.assets.length <= 0) {
      showToast("数据不合法");
      return;
    }
    // 上传事件会阻塞动画TODO
    var hide = JhToast.showIOSLoadingText(
      context,
      msg: "图片&视频上传中...",
    );
    // 异步上传文件
    Future.wait([
      uploadImages(state.initialType.toString()),
      uploadVideo(state.initialType.toString())
    ]).then((value) {
      submit(context);
    }).then((value) {
      hide();
    });
  }

  // 提交
  void submit(BuildContext context) {
    // 组装数据
    var publishInfo = {
      "Submitter": state.currentUserInfo['userId'],
      "ProjectID": state.projectID,
      "ProjectRockID": state.projectRockID,
      "InitialType": state.initialType,
      "Location": state.location.value,
      "Longitude": location.latLng.longitude,
      "Latitude": location.latLng.latitude,
      "LongitudeMarker": state.longitude.value,
      "LatitudeMarker": state.latitude.value,
      "videoUrl": state.videoUrl,
      "imageUrls": state.imageUrls,
      "GeoDescribe": state.geoDescribe,
      "Memo": state.memo,
      'Integrity': state.integrity,
      'IntegrityStr': state.integrityStr.value,
      'Weathering': state.weathering,
      'WeatheringStr': state.weatheringStr.value,
      "Occurrence": state.occurrence.value,
      "Color": state.color.value
    };
    // 本地缓存当前发布记录
    AuthorStorage.saveAuthorPublishInfo({'publishInfo': publishInfo});
    //发布接口
    HttpRequest.post(SystemApi.publishSampleImage, publishInfo,
        success: (result) {
          showToast('发布成功');
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
          });
        },
        fail: (error) {},
        progress: (int sent, int total) {
          print("$sent - $total");
        });
  }
}
