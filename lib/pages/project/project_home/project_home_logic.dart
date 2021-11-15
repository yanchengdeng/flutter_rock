/*
 * @Author: 凡琛
 * @Date: 2021-07-28 14:44:31
 * @LastEditTime: 2021-08-16 17:32:22
 * @LastEditors: Please set LastEditors
 * @Description: 项目主页
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_home/project_home_logic.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'project_home_state.dart';
import '../../../api/system.dart';
import '../../../http/http.dart';
import 'package:oktoast/oktoast.dart';
import '../../common/form/form_Input_cell.dart';
import '../../../utils/dataBiz.dart';
import '../../../permission/permission.dart';

class ProjectHomeLogic extends GetxController {
  final state = ProjectHomeState();

  @override
  void onInit() {
    // 获取当前项目信息
    state.project = Get.arguments != null ? Get.arguments['item'] : {};
    state.title.value = state.project['ProjectName'] ?? '项目主页';
    state.projectID = state.project['ProjectID'];
    getAccess();
    getProjectInfo();
    super.onInit();
  }

  // 获取权限
  void getAccess() async {
    // 权限判别
    state.add.value = await PermissionSharedInstance.getProjectAccess(
        state.projectID, Auth.projectAddStaff);
  }

  // 根据项目ID 查询获取项目 & 人员信息
  getProjectInfo() {
    // 获取人员 & 角色表
    HttpRequest.get(SystemApi.getProjectHome, {"ProjectID": state.projectID},
        success: (result) {
      var data = result['data'];
      if (data != null && data['result'] != null) {
        state.staffs = data['result']['staffs'];
        if (state.staffs != null && state.staffs.length <= 1) {
          state.staffs.add({'type': 'empty', 'title': '人员'});
        }
        state.roles = data['result']['roles'];
        if (state.roles != null && state.roles.length <= 1) {
          state.roles.add({'type': 'empty', 'title': '角色'});
        }
        if (state.tabIndex.value == 0) {
          state.list.value = state.staffs ?? [];
        } else {
          state.list.value = state.roles ?? [];
        }
      }
    }, fail: (error) {});
  }

  void delete(var item) {
    Get.defaultDialog(
        title: '移除:${item['name']}',
        middleText: '是否继续？',
        textCancel: '取消',
        textConfirm: '确认',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {removeStaffs(item), Get.back()});
  }

  void onTapCell(var item) {
    if (item['tag'] == 'role')
      Get.toNamed('/personnelList?RoleID=${item['id']}');
  }

  void addStaffs() async {
    if (state.tabIndex.value == 0) {
      // 添加人员
      var list = await Get.toNamed('/seletedPage') ?? [];
      if (list.length <= 0) return;
      // 添加项目人员
      var params = {
        'SelectedList': list,
        'ProjectID': state.projectID,
        'ProjectName': state.title.value
      };
      HttpRequest.post(SystemApi.addProjectStaffs, params, success: (result) {
        var data = result['data'];
        if (data != null && data['success'] != null) {
          showToast('人员添加成功');
          getProjectInfo(); //人员选择完成刷新列表
        } else {
          showToast('人员添加失败');
        }
      }, fail: (error) {
        showToast('人员添加失败');
      });
    } else if (state.tabIndex.value == 1) {
      // 创建项目角色
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
      'ProjectID': state.projectID,
      'RoleName': state.roleName,
      'RoleLevel': state.roleLevel,
    };
    HttpRequest.post(SystemApi.createRole, params, success: (result) {
      getProjectInfo(); //刷新列表
      Get.back();
    }, fail: (error) {});
  }

  //项目移除 人员 || 角色
  void removeStaffs(var item) {
    print(item);
    if (item['tag'] == 'staff') {
      //删除人员
      var params = {
        'Staffs': [item['id']],
        'ProjectID': state.projectID
      };
      HttpRequest.post(SystemApi.removeProjectStaffs, params,
          success: (result) {
        var data = result['data'];
        if (data != null && data['success'] != null) {
          showToast('删除成功');
          getProjectInfo(); //人员选择完成刷新列表
        } else {
          showToast('删除失败');
        }
      }, fail: (error) {
        showToast('删除失败');
      });
    } else if (item['tag'] == 'role') {
      // 删除角色
      var params = {
        'Roles': [item['id']],
      };
      HttpRequest.post(SystemApi.removeRole, params, success: (result) {
        var data = result['data'];
        if (data != null && data['success'] != null) {
          showToast('删除成功');
          getProjectInfo(); //刷新列表
        } else {
          showToast('删除失败');
        }
      }, fail: (error) {
        showToast('删除失败');
      });
    }
  }

  void addStaffsToRole(var item) async {
    var list =
        await Get.toNamed('/seletedPage?ProjectID=${state.projectID}') ?? [];
    if (list.length <= 0) return;
    var selectedList = [];
    for (var item in list) {
      selectedList.add(item['UserID']);
    }
    // 添加项目人员
    var params = {'SelectedList': selectedList, 'RoleID': item['id']};
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

  // 编辑权限页
  void editRolePermission(var item) async {
    Get.toNamed(
      '/permission?RoleID=${item['id']}&RoleName=${item['name']}',
    );
  }

// 点击tab
  onTapTab(int index) {
    state.tabIndex.value = index;
    if (index == 0) {
      state.list.value = state.staffs ?? [];
    } else if (index == 1) {
      state.list.value = state.roles ?? [];
    }
  }
}
