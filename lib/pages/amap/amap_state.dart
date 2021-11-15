/*
 * @Author: 凡琛
 * @Date: 2021-07-13 11:24:04
 * @LastEditTime: 2021-08-09 15:52:35
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/amap/amap_state.dart
 */
import 'package:get/state_manager.dart';

class AmapState {
  double latitude;
  double longitude;
  RxBool showSave;
  AmapState() {
    showSave = false.obs;
  }
}
