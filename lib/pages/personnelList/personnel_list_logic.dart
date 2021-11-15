/*
 * @Author: 凡琛
 * @Date: 2021-07-23 09:08:50
 * @LastEditTime: 2021-08-06 10:35:34
 * @LastEditors: Please set LastEditors
 * @Description: 人员列表
 * @FilePath: 
 */
import 'package:get/get.dart';
import 'personnel_list_state.dart';
import '../../../api/system.dart';
import '../../../http/http.dart';
import 'package:flutter/material.dart';

class PersonnelListLogic extends GetxController {
  final state = PersonnelListState();
  @override
  void onInit() {
    getRolePersonnalList();
    super.onInit();
  }

  void onTapCell(var item) {}
  void delete(var item) {
    print(item);
    Get.defaultDialog(
        title: '移除:${item['User']['RealName']}',
        middleText: '是否继续？',
        textCancel: '取消',
        textConfirm: '确认',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {removeItem(item), Get.back()});
  }

  void removeItem(var item) {
    HttpRequest.post(SystemApi.removeStaffsFromRole, {
      'UserID': item['UserID'],
      'RoleID': item['RoleID']
    }, success: (result) {
      getRolePersonnalList();
    }, fail: (error) {});
  }

  void getRolePersonnalList() {
    HttpRequest.post(SystemApi.getRolePersonnalList, Get.parameters,
        success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['result'] != null) {
        state.list.value = data['result'];
      }
    }, fail: (error) {});
  }
}
