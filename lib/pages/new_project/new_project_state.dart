/*
 * @Author: 凡琛
 * @Date: 2021-07-19 15:26:38
 * @LastEditTime: 2021-07-26 10:28:07
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/new_project/new_project_state.dart
 */
import 'package:get/state_manager.dart';

class NewProjectState {
  // 标题
  RxList<String> titleList;
  RxInt tag;
  // 项目表单数据
  RxString projectName;
  RxString location;
  RxString investigator; // 勘察单位
  RxString projectDescribe;
  RxString memo3;
  RxString projectTypeStr;
  RxString stageStr;
  RxString startDateStr;
  String startDateStrd;
  RxString endDateStr;
  String endDateStrd;
  DateTime startDate;
  DateTime endDate;
  int projectType;
  int stage;
  RxList<String> projectTypeList;
  RxList<String> stageList;

  // 公司表单数据
  RxString companyName;
  RxString companyDescribe;
  RxString companyTypeStr;
  int companyType;
  RxList<String> companyTypeList;

  // 部门描述
  RxString departmentName;
  RxString departmentDescribe;

  NewProjectState() {
    titleList = ['创建项目', '新增公司', '创建部门'].obs;
    tag = 0.obs;
    // 项目
    projectName = ''.obs;
    location = ''.obs;
    investigator = ''.obs;
    projectDescribe = ''.obs;
    memo3 = ''.obs;
    projectTypeStr = ''.obs;
    stageStr = ''.obs;
    startDateStr = ''.obs;
    endDateStr = ''.obs;
    projectTypeList = ['勘察', '水利', '市政交通'].obs;
    stageList =
        ['规划', '预可', '可研', '招标', '技施', '初设', '施工图', '勘察', '详勘', '施工勘察'].obs;
    startDateStrd = '';
    endDateStrd = '';
    // 公司
    companyName = ''.obs;
    companyDescribe = ''.obs;
    companyTypeStr = ''.obs;
    companyTypeList = ['一般企业', '国企央企', '高新企业'].obs;
    // 部门
    departmentName = ''.obs;
    departmentDescribe = ''.obs;
  }
}
