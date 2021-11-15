/*
 * @Author: 凡琛
 * @Date: 2021-08-05 10:16:34
 * @LastEditTime: 2021-08-06 16:03:15
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/system_role/system_role_logic.dart
 */
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'system_role_state.dart';
import '../../../api/system.dart';
import '../../../http/http.dart';
import '../common/form/form_Input_cell.dart';
import '../../../utils/dataBiz.dart';

class SystemRoleLogic extends GetxController {
  final state = SystemRoleState();
  @override
  void onInit() {
    getSyetemRoleList();
    super.onInit();
  }

  // 获取系统角色列表
  void getSyetemRoleList() {
    HttpRequest.get(SystemApi.getSystemRoles, {}, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] && data['result'] != null) {
        state.list.value = data['result'];
      }
    }, fail: (error) {});
  }

  void addRole() {
    Get.defaultDialog(
        title: '创建角色',
        barrierDismissible: false,
        content: Material(
            child: Container(
          color: Colors.green,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HDFormInputCell(
                  title: '角色名称',
                  hintText: '请输入角色名称',
                  showRedStar: true,
                  inputCallBack: (context) => {state.roleName = context}),
              HDFormInputCell(
                  title: '角色等级',
                  hintText: '请输入排序值(0~9)',
                  showRedStar: true,
                  inputCallBack: (context) => {
                        if (isNumeric(context))
                          {state.roleLevel = int.parse(context)}
                        else
                          {showToast('请输入正确数值')}
                      }),
            ],
          ),
        )),
        textCancel: '取消',
        textConfirm: '创建',
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {createRole()});
  }

  void createRole() {
    if (state.roleName == '') {
      showToast('角色名不可为空');
      return;
    }
    if (state.roleLevel == -1) {
      showToast('角色等级不可为空');
      return;
    }
    var params = {
      'RoleName': state.roleName,
      'RoleLevel': state.roleLevel,
      'IsSystem': 1
    };
    HttpRequest.post(SystemApi.createRole, params, success: (result) {
      getSyetemRoleList(); //刷新列表
      Get.back();
    }, fail: (error) {});
  }

  void onTapCell(var item) {
    Get.toNamed('/personnelList?RoleID=${item['RoleID']}');
  }

  void addStaffsToRole(var item) async {
    var list = await Get.toNamed('/seletedPage') ?? [];
    if (list.length <= 0) return;
    var selectedList = [];
    for (var item in list) {
      selectedList.add(item['UserID']);
    }
    // 添加项目人员
    var params = {'SelectedList': selectedList, 'RoleID': item['RoleID']};
    HttpRequest.post(SystemApi.addStaffsToRole, params, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] != null) {
        showToast('人员添加成功');
      } else {
        showToast('人员添加失败');
      }
    }, fail: (error) {
      showToast('人员添加失败');
    });
  }

  void editRolePermission(var item) {
    Get.toNamed(
      '/permission?RoleID=${item['RoleID']}&RoleName=${item['RoleName']}&IsSystem=${item['IsSystem']}',
    );
  }

  void delete(var item) {
    Get.defaultDialog(
        title: '移除:${item['RoleName']}',
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
    // 删除角色
    var params = {
      'Roles': [item['RoleID']],
    };
    HttpRequest.post(SystemApi.removeRole, params, success: (result) {
      var data = result['data'];
      if (data != null && data['success'] != null) {
        showToast('删除成功');
        getSyetemRoleList(); //刷新列表
      } else {
        showToast('删除失败');
      }
    }, fail: (error) {
      showToast('删除失败');
    });
  }
}
