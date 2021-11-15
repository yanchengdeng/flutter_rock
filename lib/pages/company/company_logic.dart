/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:08:50
 * @LastEditTime: 2021-08-17 16:11:37
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_logic.dart
 */
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'company_state.dart';
import '../../api/system.dart';
import '../../http/http.dart';

class CompanyLogic extends GetxController {
  final state = CompanyState();
  @override
  void onInit() {
    // 请求公司列表
    request('');
    int tag = Get.parameters['tag'] != null && Get.parameters['tag'] != ''
        ? int.parse(Get.parameters['tag'])
        : 0;
    state.tag.value = tag;
    super.onInit();
  }

  void request(String name) async {
    var req = {"search": name};
    HttpRequest.get(SystemApi.getCompany, req, success: (result) {
      var data = result['data'];
      if (data != null && data['data'] != null) {
        state.list.value = data['data'];
      }
    }, fail: (error) {});
  }

// 删除公司
  void delete(var item) {
    var id = item['CompanyID'];
    var req = {"CompanyID": id};
    HttpRequest.post(SystemApi.removeCompany, req, success: (result) {
      if (result['data'] != null && result['data']['success']) {
        removeCompany(id);
      }
    }, fail: (error) {
      showToast('删除失败');
    });
  }

  void removeCompany(int id) {
    for (var i = 0; i < state.list.length; i++) {
      var item = state.list[i];
      if (item['CompanyID'] == id) state.list.removeAt(i);
    }
  }

// 点击事件
  void onTapCell(var item) {
    if (state.tag.value == 0) {
      Get.back(result: item);
    } else {
      Get.toNamed('/companyHome', arguments: {'item': item});
    }
  }

  // 输入框回调
  void onSearchTextChanged(String context) => {state.input = context};
  // 清除输入框回调
  void onCleanSearch() => {state.input = '', request(state.input)};
}
