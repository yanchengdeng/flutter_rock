/*
 * @Author: 凡琛
 * @Date: 2021-07-19 15:26:38
 * @LastEditTime: 2021-08-17 16:18:19
 * @LastEditors: Please set LastEditors
 * @Description: 新建项目
 * @FilePath: /Rocks_Flutter/lib/pages/new_project/new_project_logic.dart
 */
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'new_project_state.dart';
import 'package:city_pickers/city_pickers.dart';
import '../../widgets/bottom_sheet.dart';
import '../../widgets/picker_tool.dart';
import 'package:flutter/material.dart';
import '../../api/system.dart';
import '../../http/http.dart';

class NewProjectLogic extends GetxController {
  final state = NewProjectState();

  // 组件初始化方式
  void initState(GetBuilderState stateFormBulider) {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      state.tag.value = Get.arguments != null ? Get.arguments['tag'] : 0;
    });
  }

  // 项目
  void inputProjectName(value) {
    state.projectName.value = value;
  }

  void inputDescribeName(value) {
    state.projectDescribe.value = value;
  }

  void inputMemoName(value) {
    state.memo3.value = value;
  }

  // 公司
  void inputCompanyName(value) {
    state.companyName.value = value;
  }

  void inputCompanyDescribeName(value) {
    state.companyDescribe.value = value;
  }

  // 部门
  void inputDepartmentName(value) {
    state.departmentName.value = value;
  }

  void inputDepartmentDescribeName(value) {
    state.departmentDescribe.value = value;
  }

// 底部弹框组件
  void bottomSheet(String title, List<String> dataList) {
    HdBottomSheet.showText(Get.context, dataArr: dataList, title: title,
        clickCallback: (index, text) {
      if (index == 0) {
        return;
      }
      switch (title) {
        case '项目类型':
          state.projectType = index;
          state.projectTypeStr.value = text;
          break;
        case '项目阶段':
          state.stage = index;
          state.stageStr.value = text;
          break;
        case '公司类型':
          state.companyType = index;
          state.companyTypeStr.value = text;
          break;
        default:
      }
    });
  }

// 日期选择
  void bottomDateSheet(String tag) {
    PickerTool.showDatePicker(Get.context,
        title: tag == 'start' ? '开始时间' : '结束时间',
        clickCallback: (var str, var time, var datetime) {
      // 时间区间有效性判断
      var di;
      Duration standard = Duration(
          days: 0,
          hours: 23,
          minutes: 59,
          seconds: 59,
          microseconds: 999,
          milliseconds: 999);
      if (state.startDate != null && tag == 'end') {
        di = datetime.difference(state.startDate);
        if (di < -standard) {
          // 无效时间选择
          showToast('结束时间不得早于开始时间！');
          return;
        }
      } else if (state.endDate != null && tag == 'start') {
        di = state.endDate.difference(datetime);
        if (di < -standard) {
          // 无效时间选择
          showToast('开始时间不得晚于结束时间！');
          return;
        }
      }
      // 赋值
      if (tag == 'start') {
        state.startDateStr.value = str;
        state.startDate = datetime;
        state.startDateStrd = time;
      } else {
        state.endDateStr.value = str;
        state.endDate = datetime;
        state.endDateStrd = time;
      }
    });
  }

//地址选择
  void selectLocation() async {
    try {
      Result result =
          await CityPickers.showFullPageCityPicker(context: Get.context);
      state.location.value =
          result.provinceName + '|' + result.cityName + '|' + result.areaName;
    } catch (error) {
      print('error:$error');
    }
  }

// 获取勘察单位信息
  void getInvestigator() async {
    var res = await Get.toNamed('/company');
    state.investigator.value = res['CompanyName'] ?? '';
  }

// 创建项目
  void create() {
    String type = state.tag.value == 0
        ? 'project'
        : state.tag.value == 1
            ? 'company'
            : state.tag.value == 2
                ? 'department'
                : 'project';
    // 输入非空校验
    if (!checkData(type)) return;
    // 弹框内容
    var title = type == 'project'
        ? '创建项目'
        : type == 'company'
            ? '添加公司'
            : type == 'department'
                ? '添加部门'
                : '创建';
    // 提交复选框
    Get.defaultDialog(
        title: title,
        middleText: '是否确认当前操作？',
        textCancel: '取消',
        textConfirm: '确认',
        barrierDismissible: false,
        confirmTextColor: Colors.white,
        titleStyle: TextStyle(fontSize: 18),
        radius: 6,
        onConfirm: () => {request(type), Get.back()});
  }

  // 数据校验
  bool checkData(String type) {
    var result = false;
    switch (type) {
      case 'project':
        if (state.projectName.value == null || state.projectName.value == '') {
          showToast('项目名称不可为空');
        } else if (state.location.value == null || state.location.value == '') {
          showToast('项目地址不可为空');
        } else if (state.projectTypeStr.value == null ||
            state.projectTypeStr.value == '') {
          showToast('项目类型不可为空');
        } else if (state.stageStr.value == null || state.stageStr.value == '') {
          showToast('项目阶段不可为空');
        } else if (state.investigator.value == null ||
            state.investigator.value == '') {
          showToast('勘察单位不可为空');
        } else if (state.startDateStr.value == null ||
            state.startDateStr.value == '') {
          showToast('起始时间不可为空');
        } else if (state.endDateStr.value == null ||
            state.endDateStr.value == '') {
          showToast('结束时间不可为空');
        } else if (state.projectDescribe.value == null ||
            state.projectDescribe.value == '') {
          showToast('项目描述不可为空');
        } else {
          result = true;
        }
        break;
      case 'company':
        if (state.companyName.value == null || state.companyName.value == '') {
          showToast('公司名称不可为空');
        } else if (state.companyType == null) {
          showToast('公司类型不可为空');
        } else if (state.companyDescribe.value == null ||
            state.companyDescribe.value == '') {
          showToast('公司描述不可为空');
        } else {
          result = true;
        }
        break;
      case 'department':
        break;
      default:
    }
    return result;
  }

  // 数据请求
  void request(String type) async {
    if (type == 'project') {
      //组装数据
      final params = {
        'ProjectName': state.projectName.value,
        'ProjectType': state.projectType,
        'Stage': state.stage,
        'Investigator': state.investigator.value,
        'Location': state.location.value,
        'ProjectDescribe': state.projectDescribe.value,
        'Memo3': state.memo3.value,
        'StartDate': state.startDateStrd,
        'EndDate': state.endDateStrd
      };
      //请求项目列表
      HttpRequest.post(SystemApi.createProject, params, success: (result) {
        var data = result['data'];
        if (data != null && data['success']) {
          showToast('创建项目成功');
          Future.delayed(Duration(seconds: 1), () {
            Get.back();
          });
        } else {
          showToast('${data['msg']}');
        }
      }, fail: (error) {
        showToast('创建项目失败');
      });
    } else if (type == 'company') {
      //添加公司
      final params = {
        "CompanyName": state.companyName.value,
        "CompanyType": state.companyTypeStr.value,
        "CompanyDescribe": state.companyDescribe.value
      };
      HttpRequest.post(SystemApi.addCompany, params, success: (result) {
        var data = result['data'];
        if (data != null && data['success']) {
          showToast('添加成功');
          Future.delayed(Duration(seconds: 1), () {
            Get.back();
          });
        } else {
          showToast('${data['msg']}');
        }
      }, fail: (error) {
        showToast('添加失败');
      });
    }
  }
}
