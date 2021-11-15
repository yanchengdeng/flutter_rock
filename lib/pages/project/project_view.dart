/*
 * @Author: 凡琛
 * @Date: 2021-06-23 15:18:22
 * @LastEditTime: 2021-08-17 16:20:48
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'project_logic.dart';
import 'project_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../widgets/search_bar.dart';

class ProjectPage extends StatelessWidget {
  final ProjectLogic logic = Get.put(ProjectLogic());
  final ProjectState state = Get.find<ProjectLogic>().state;

  Widget listView(BuildContext context, List dataArr) {
    return Obx(() => Container(
        color: Colors.grey[200],
        child: ListView.builder(
            padding: EdgeInsets.only(top: 20),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: dataArr.length,
            itemBuilder: (context, index) {
              return item(context, dataArr[index]);
            })));
  }

  Widget item(BuildContext context, Map item) {
    return Container(
      child: InkWell(
          onTap: () => logic.onTapItem(item),
          child: Card(
              color: Colors.white,
              margin: EdgeInsets.fromLTRB(15, 5, 15, 5),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              child: Container(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['ProjectName'],
                        style: TextStyle(
                            color: Color(0xFF333333),
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      SizedBox(
                        height: 8.0,
                      ),
                      if (item['Department'] != null)
                        Text(
                          "责任单位：${item['Department']}",
                          style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                      Text(
                        "创建时间：${item['CreateDate']}",
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      Text(
                        "${item['ProjectDescribe']}",
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey[500],
                            fontWeight: FontWeight.normal,
                            fontSize: 14),
                      ),
                    ],
                  )))),
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          titleSpacing: 0,
          title: Obx(() => SearchBar(
              tag: state.tag.value,
              hintText: '输入项目名搜索',
              inputCallBack: logic.onSearchTextChanged,
              cleanCallBack: logic.onCleanSearch)),
          actions: [
            InkWell(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(left: 2),
                child: Center(
                  child: Text("搜索",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
              onTap: () {
                logic.request(state.input);
              },
            ),
            Obx(() => InkWell(
                  child: state.createProject.value && state.tag.value != 1
                      ? Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 12, left: 2),
                          child: Center(
                            child: Text("新建",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal)),
                          ),
                        )
                      : SizedBox(width: 12),
                  onTap: () {
                    logic.onTapCreateProject();
                  },
                ))
          ],
        ),
        // 下拉刷新、上拉加载组件与GetX结合有问题
        body: GetBuilder<ProjectLogic>(
            initState: (GetBuilderState stateFormBulider) =>
                {logic.initState(stateFormBulider)},
            dispose: (GetBuilderState stateFormBulider) =>
                {logic.myDispose(stateFormBulider)},
            didChangeDependencies: (GetBuilderState stateFormBulider) =>
                {logic.didChangeDependencies(stateFormBulider)},
            didUpdateWidget:
                (GetBuilder oldWidget, GetBuilderState stateFormBulider) =>
                    {logic.didUpdateWidget(oldWidget, stateFormBulider)},
            builder: (controller) {
              return EasyRefresh(
                child: listView(context, state.list),
                controller: _controller,
                firstRefresh: false,
                onRefresh: () async {
                  print('下拉刷新');
                  logic.request(state.input);
                },
                onLoad: () async {
                  print('上拉加载');
                },
              );
            }));
  }
}
