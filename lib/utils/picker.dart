/*
 * @Author: your name
 * @Date: 2021-06-22 11:54:15
 * @LastEditTime: 2021-08-13 18:17:48
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/utils/picker.dart
 */
import 'dart:io';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

final picker = ImagePicker();
File file;

// 相机拍照
Future<File> getImageFromCamera() async {
  final pickedFile = await picker.getImage(source: ImageSource.camera);
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    print('No image selected.1');
    return null;
  }
}

// 相册选择
Future<File> getImageFromGallery(bool mounted) async {
  //选择相册
  final pickerImages = await picker.getImage(source: ImageSource.gallery);
  if (mounted) {
    if (pickerImages != null) {
      return File(pickerImages.path);
    } else {
      return null;
    }
  } else {
    return null;
  }
}

//相册选择多选
Future<List<Asset>> getImagesFromGallery(
    List<Asset> images, bool mounted, int maxImages) async {
  List<Asset> resultList = <Asset>[];
  String error = 'No Error Detected';
  try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: maxImages,
      enableCamera: true,
      selectedAssets: images,
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
          actionBarColor: "#abcdef",
          allViewTitle: "所有照片",
          useDetailsView: true,
          selectCircleStrokeColor: "#000000",
          autoCloseOnSelectionLimit: true),
    );
  } on Exception catch (e) {
    error = e.toString();
  }
  if (!mounted) return images;
  return resultList;
}

//获取视频封面图
// Future<String> getVideoThumbnail(File video) async {
//   String thumbnailPath = await VideoThumbnail.thumbnailFile(
//       video: video.path,
//       imageFormat: ImageFormat.PNG,
//       maxWidth: 128,
//       quality: 25);
//   return thumbnailPath;
// }

// 拍摄视频
Future<File> getVideoFromCamera() async {
  final pickedFile = await picker.getVideo(
      source: ImageSource.camera, maxDuration: Duration(seconds: 30));
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

// 选取视频
Future getVideoFromGallery() async {
  final pickedFile = await picker.getVideo(
      source: ImageSource.gallery, maxDuration: Duration(seconds: 30));
  if (pickedFile != null) {
    return File(pickedFile.path);
  } else {
    return null;
  }
}

// wechat 多图片选择
Future<List<AssetEntity>> getAssetFromGallery(int maxAssetsCount,
    List<AssetEntity> selectedAssets, RequestType requestType) async {
  List<AssetEntity> resultList = <AssetEntity>[];
  String error;
  try {
    resultList = await AssetPicker.pickAssets(Get.context,
        maxAssets: maxAssetsCount,
        selectedAssets: selectedAssets,
        requestType: requestType);
  } on Exception catch (e) {
    error = e.toString();
    print(error);
  }
  return resultList;
}

// wechat 拍照
Future<AssetEntity> getTakeAssetFromCamera(bool enableRecording,
    [int maxDuration = 30]) async {
  var asset = await CameraPicker.pickFromCamera(Get.context,
      enableRecording: enableRecording,
      maximumRecordingDuration: Duration(seconds: maxDuration));
  return asset;
}
