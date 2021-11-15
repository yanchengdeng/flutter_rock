/*
 * @Author: 凡琛
 * @Date: 2021-07-26 11:06:05
 * @LastEditTime: 2021-08-06 16:03:58
 * @LastEditors: Please set LastEditors
 * @Description: 公司主页
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_home/company_home_logic.dart
 */
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';

import 'company_home_state.dart';
import '../../../api/system.dart';
import '../../../http/http.dart';

class CompanyHomeLogic extends GetxController {
  final state = CompanyHomeState();
  @override
  void onInit() {
    state.company = Get.arguments != null ? Get.arguments['item'] : {};
    state.companyID = state.company['CompanyID'];
    state.companyName = state.company['CompanyName'];
    getCompanyInfo();
    super.onInit();
  }

  // 根据公司ID 查询获取公司&人员信息
  getCompanyInfo() {
    var req = {"CompanyID": state.companyID};
    HttpRequest.get(SystemApi.getCompanyHome, req, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['data'] != null) {
        state.list.value = data['data'];
        if (data['empty']) state.list.add({'type': 'empty'});
      }
    }, fail: (error) {});
  }

  void delete(var item) {
    var params = {
      "Staffs": [item['userId']],
      "CompanyID": state.companyID
    };
    HttpRequest.post(SystemApi.removeCompanyStaffs, params, success: (result) {
      var data = result['data'];
      if (data != null && data['success']) {
        showToast('删除成功');
        getCompanyInfo();
      }
    }, fail: (error) {});
  }

  void onTapCell(var item) {
    showToast('${item['userName']}');
  }

  void addStaffs() async {
    var list = await Get.toNamed('/seletedPage') ?? [];
    if (list.length <= 0) return;
    var params = {
      'SelectedList': list,
      'CompanyID': state.companyID,
      'CompanyName': state.companyName
    };
    HttpRequest.post(SystemApi.addCompanyStaffs, params, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] != null) {
        showToast('人员添加成功');
        getCompanyInfo(); //人员选择完成刷新列表
      } else {
        showToast('添加失败');
      }
    }, fail: (error) {
      showToast('添加失败');
    });
  }
}
