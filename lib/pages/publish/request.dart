/*
 * @Author: 凡琛
 * @Date: 2021-06-30 21:33:47
 * @LastEditTime: 2021-08-12 18:53:00
 * @LastEditors: Please set LastEditors
 * @Description: 发布页请求数据处理
 * @FilePath: /Rocks_Flutter/lib/pages/publish/request.dart
 */
import 'package:dio/dio.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:http_parser/http_parser.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class PublishRequest {
  Future<void> selectAssets() async {
    // final List<AssetEntity> assets = await AssetPicker.pickAssets(Get.context);
  }

  static Future<FormData> dealWithImageData(
      List<AssetEntity> images, String fileId) async {
    List<MultipartFile> imageList = [];
    var start = DateTime.now().millisecondsSinceEpoch;
    // 改成异步上传 TD
    for (AssetEntity image in images) {
      var imageData = await image.originBytes;
      //压缩
      imageData = await FlutterImageCompress.compressWithList(imageData,
          minHeight: 1920, minWidth: 1080, quality: 80);
      MultipartFile multipartFile = new MultipartFile.fromBytes(
        imageData,
        filename: image.title,
        contentType: MediaType("image", "jpg"),
      );
      imageList.add(multipartFile);
    }
    print('convertTime:${DateTime.now().millisecondsSinceEpoch - start}}');
    FormData formData = FormData.fromMap({
      "files": imageList,
      "accessToken": "000",
      "file_id": fileId,
      "type": "image"
    });
    return formData;
  }

  static Future<FormData> dealWithVideoData(String path, String fileId) async {
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    var file = await MultipartFile.fromFile(path,
        filename: name, contentType: MediaType("video", suffix));
    FormData formData = FormData.fromMap({
      "file": file,
      "accessToken": "000",
      "file_id": fileId,
      "type": "video"
    });
    return formData;
  }

  static Future<FormData> dealWithFileData(
      String path, String fileId, String type) async {
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    var suffix = name.substring(name.lastIndexOf(".") + 1, name.length);
    // 图片压缩
    var result = await FlutterImageCompress.compressWithFile(path,
        minWidth: 1920, minHeight: 1080, quality: 80);
    var file = MultipartFile.fromBytes(result,
        filename: name, contentType: MediaType('*', suffix));
    FormData formData = FormData.fromMap(
        {"file": file, "accessToken": "000", "file_id": fileId, "type": type});
    return formData;
  }

  static Future<bool> _requestPermission() async {
    return Permission.location.request().then((it) => it.isGranted);
  }

  // 获取当前定位
  static Future<Location> getCurrentLocation() async {
    if (await _requestPermission()) {
      Location location = await AmapLocation.fetchLocation();
      return location;
    } else {
      return null;
    }
  }

  // 获取当前定位
  static stopLocation() async {
    if (await _requestPermission()) {
      AmapLocation.stopLocation();
    }
  }
}
