/*
 * @Author: 凡琛
 * @Date: 2021-07-13 11:24:04
 * @LastEditTime: 2021-08-09 16:04:51
 * @LastEditors: Please set LastEditors
 * @Description: 地图页面
 * @FilePath: /Rocks_Flutter/lib/pages/amap/amap_logic.dart
 */
import 'package:get/get.dart';
// import 'package:amap_all_fluttify/amap_all_fluttify.dart';
import 'amap_state.dart';

class AmapLogic extends GetxController {
  final state = AmapState();
  @override
  void onInit() async {
    state.showSave.value = Get.parameters['showSave'] == 'true' ? true : false;
    super.onInit();
  }

  void submit() {
    Get.back(
        result: {'latitude': state.latitude, 'longitude': state.longitude});
  }

  void createMark(double latitude, double longitude) {
    state.latitude = latitude;
    state.longitude = longitude;
  }
}
