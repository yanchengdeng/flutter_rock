/*
 * @Author: 凡琛
 * @Date: 2021-07-16 14:08:08
 * @LastEditTime: 2021-08-06 15:48:18
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/home/home_state.dart
 */
import 'package:get/get_rx/get_rx.dart';

class ItemsClass {
  String title;
  String detail;
  String date;
  List imageUrl;
  String jumpUrl;
  ItemsClass(this.title, this.detail, this.date, this.imageUrl, this.jumpUrl);
}

class HomeState {
  RxList<dynamic> pagingList; // 轮播图片
  RxList<dynamic> newsList; // 新闻列表
  RxList<dynamic> entryList; // 圆饼入口
  RxString hasMoreUrl;

  HomeState() {
    pagingList = [].obs;
    entryList = [].obs;
    newsList = [].obs;
    hasMoreUrl = ''.obs;
  }
}
