/*
 * @Author: 凡琛
 * @Date: 2021-07-19 15:26:38
 * @LastEditTime: 2021-08-17 16:17:44
 * @LastEditors: Please set LastEditors
 * @Description: 新建项目
 * @FilePath: /Rocks_Flutter/lib/pages/new_project/new_project_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'new_project_logic.dart';
import 'new_project_state.dart';
import '../common/form/form_select_cell.dart';
import '../common/form/form_Input_cell.dart';

class NewProjectPage extends StatelessWidget {
  final NewProjectLogic logic = Get.put(NewProjectLogic());
  final NewProjectState state = Get.find<NewProjectLogic>().state;

  Widget newItem() {
    switch (state.tag.value) {
      case 0:
        return newProjectBlock();
        break;
      case 1:
        return newCompany();
        break;
      case 2:
        return newDepartment();
        break;
      default:
        return newProjectBlock();
    }
  }

  // 创建项目
  Widget newProjectBlock() {
    return Container(
        child: Column(children: [
      HDFormInputCell(
          title: '项目名称',
          text: state.projectName.value,
          hintText: '请输入项目名称',
          showRedStar: true,
          inputCallBack: logic.inputProjectName),
      HDFormSelectCell(
          title: '项目地址',
          text: state.location.value,
          hintText: '请选择项目地址',
          showRedStar: true,
          clickCallBack: logic.selectLocation),
      HDFormSelectCell(
        title: '项目类型',
        text: state.projectTypeStr.value,
        hintText: '请选择项目类型',
        showRedStar: true,
        clickCallBack: () => {logic.bottomSheet('项目类型', state.projectTypeList)},
      ),
      HDFormSelectCell(
        title: '项目阶段',
        text: state.stageStr.value,
        hintText: '请选择项目类型',
        showRedStar: true,
        clickCallBack: () => {logic.bottomSheet('项目阶段', state.stageList)},
      ),
      HDFormSelectCell(
          title: '勘察单位',
          text: state.investigator.value,
          hintText: '请选择勘察单位',
          showRedStar: true,
          clickCallBack: logic.getInvestigator),
      HDFormSelectCell(
          title: '开始时间',
          showRedStar: true,
          text: state.startDateStr.value,
          hintText: '请选择项目开始时间',
          clickCallBack: () => {logic.bottomDateSheet('start')}),
      HDFormSelectCell(
          title: '结束时间',
          showRedStar: true,
          text: state.endDateStr.value,
          hintText: '请选择项目结束时间',
          clickCallBack: () => {logic.bottomDateSheet('end')}),
      SizedBox(height: 5),
      HDFormInputCell(
        title: "项目描述",
        hintText: "请简要描述项目概况",
        maxLines: 3,
        maxLength: 200,
        showMaxLength: true,
        hiddenLine: true,
        showRedStar: true,
        topAlign: true,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 0.6,
            style: BorderStyle.none,
            color: Colors.grey[300],
          ),
        ),
        inputCallBack: logic.inputDescribeName,
      ),
      SizedBox(height: 5),
      HDFormInputCell(
        title: "备注",
        hintText: "项目相关的备注信息",
        maxLines: 2,
        maxLength: 100,
        showMaxLength: true,
        hiddenLine: true,
        topAlign: true,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 0.6,
            style: BorderStyle.none,
            color: Colors.grey[300],
          ),
        ),
        inputCallBack: logic.inputMemoName,
      )
    ]));
  }

  // 添加公司
  Widget newCompany() {
    return Container(
        child: Column(children: [
      HDFormInputCell(
          title: '公司名称',
          text: state.companyName.value,
          hintText: '请输入公司名称',
          showRedStar: true,
          inputCallBack: logic.inputCompanyName),
      HDFormSelectCell(
        title: '公司类型',
        text: state.companyTypeStr.value,
        hintText: '请选择公司类型',
        showRedStar: true,
        clickCallBack: () => {logic.bottomSheet('公司类型', state.companyTypeList)},
      ),
      HDFormInputCell(
        title: "公司描述",
        hintText: "请简要描述公司概况",
        maxLines: 5,
        maxLength: 200,
        showMaxLength: true,
        hiddenLine: true,
        showRedStar: true,
        topAlign: true,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.none,
          ),
        ),
        inputCallBack: logic.inputCompanyDescribeName,
      ),
    ]));
  }

  // 创建部门
  Widget newDepartment() {
    return Container(
        child: Column(children: [
      HDFormInputCell(
          title: '部门名称',
          text: state.departmentName.value,
          hintText: '请输入部门名称',
          showRedStar: true,
          inputCallBack: logic.inputDepartmentName),
      HDFormInputCell(
        title: "部门描述",
        hintText: "请简要描述部门概况",
        maxLines: 3,
        maxLength: 100,
        showMaxLength: true,
        hiddenLine: true,
        topAlign: true,
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(
            width: 1,
            style: BorderStyle.none,
          ),
        ),
        inputCallBack: logic.inputDepartmentDescribeName,
      ),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Obx(() => Text(state.titleList[state.tag.value])),
          actions: [
            InkWell(
              child: Container(
                width: 50,
                height: 50,
                margin: EdgeInsets.only(right: 15),
                child: Center(
                  child: Text("创建",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
              onTap: () => {logic.create()},
            ),
          ],
        ),
        body: GetBuilder<NewProjectLogic>(
            initState: (GetBuilderState stateFormBulider) =>
                {logic.initState(stateFormBulider)},
            builder: (controller) {
              return Scrollbar(
                child: SingleChildScrollView(
                    child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Obx(() => newItem()))),
              );
            }));
  }
}
