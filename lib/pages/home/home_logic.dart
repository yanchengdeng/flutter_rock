/*
 * @Author: 凡琛
 * @Date: 2021-07-16 14:08:08
 * @LastEditTime: 2021-08-17 15:41:31
 * @LastEditors: Please set LastEditors
 * @Description: 首页
 * @FilePath: /Rocks_Flutter/lib/pages/home/home_logic.dart
 */

import 'package:get/get.dart';
import '../../http/http.dart';
import '../../api/system.dart';
import 'home_state.dart';

class HomeLogic extends GetxController {
  final state = HomeState();
  @override
  void onReady() {
    getHomeList();
    super.onReady();
  }

  // 点击轮播图
  void onTapPaging(int index) async {
    var item = state.pagingList[index];
    Get.toNamed('/web', arguments: {'url': '${item['jumpUrl']}'});
  }

  // 点击查看更多
  void onTapHasMore() {
    Get.toNamed(state.hasMoreUrl.value);
  }

  // 单击新闻item
  void onTapNewItem(var item) {
    if (item.jumpUrl != null && item.jumpUrl != '') {
      Get.toNamed('/web',
          arguments: {'url': '${item.jumpUrl}', 'title': '${item.title}'});
    }
  }

  void onTapEntry(Map item) {
    Get.toNamed(item['jumpUrl'], arguments: {'tag': 1});
  }

  getHomeList() async {
    HttpRequest.get(SystemApi.homeList, {}, success: (result) {
      if (result != null &&
          result['data'] != null &&
          result['data']['list'] != null) {
        var res = result['data']['list'];
        state.pagingList.value = res['pagingList'] ?? [];
        state.entryList.value = res['entryList'] ?? [];
        state.newsList.value = res['newsList'] ?? [];
        state.hasMoreUrl.value = res['hasMoreUrl'] ?? '';
      }
    }, fail: (error) {
      print(error);
    });
  }
}
