/*
 * @Author: 凡琛
 * @Date: 2021-07-28 14:44:31
 * @LastEditTime: 2021-08-16 17:37:21
 * @LastEditors: Please set LastEditors
 * @Description: 项目主页
 * @FilePath: /Rocks_Flutter/lib/pages/project/project_home/project_home_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'project_home_logic.dart';
import 'project_home_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../utils/jh_image_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sticky_headers/sticky_headers.dart';

class ProjectHomePage extends StatelessWidget {
  final ProjectHomeLogic logic = Get.put(ProjectHomeLogic());
  final ProjectHomeState state = Get.find<ProjectHomeLogic>().state;

  Widget item(RxList<String> list, int index) {
    // 根据数据类别返回
    Widget result;
    if (list[index] == 'header') {
      result = (state.list != null && state.list.length >= 1)
          ? header(state.list[0])
          : Container();
    } else {
      result = tabList();
    }
    return result;
  }

// 项目头部信息
  Widget header(Map item) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Material(
          child: Stack(
        alignment: AlignmentDirectional.centerStart,
        children: [
          Container(
            height: 155,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              image: DecorationImage(
                image: AssetImage('assets/images/banner/banner.png'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
          ),
          Positioned(
            child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['projectName'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 26,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 8.0,
                    ),
                    Text(item['investigator'] ?? '',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(item['projectDescribe'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: new TextStyle(
                            fontSize: 15,
                            color: Colors.grey[200],
                            fontWeight: FontWeight.normal))
                  ],
                )),
          )
        ],
      )),
    );
  }

  Widget tabList() {
    return DefaultTabController(
        length: 2,
        initialIndex: state.tabIndex.value,
        child: StickyHeader(
            header: Offstage(
                offstage: !(state.roles != null && state.roles.length > 1),
                child: Container(
                    margin: EdgeInsets.only(left: 12, right: 12),
                    color: Color(0xff5f5f5),
                    width: MediaQuery.of(Get.context).size.width,
                    child: Container(
                      color: Colors.white,
                      child: TabBar(
                        isScrollable: true,
                        tabs: [
                          Tab(text: '人员'),
                          Tab(text: '角色'),
                        ],
                        labelColor: Colors.blue,
                        labelStyle: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                        unselectedLabelStyle: TextStyle(fontSize: 14),
                        unselectedLabelColor: Colors.grey[400],
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.label,
                        labelPadding:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 15.0),
                        onTap: logic.onTapTab,
                      ),
                    ))),
            content: Column(children: buildGroup(state.list))));
  }

// 人员列表
  Widget cell(var item) {
    return Container(
        color: Colors.white,
        child: InkWell(
            onTap: () {
              logic.onTapCell(item);
            },
            child: Slidable(
              actionPane: SlidableScrollActionPane(),
              //滑出选项的面板 动画
              actionExtentRatio: 0.25,
              enabled: state.add.value,
              child: Container(
                  padding: EdgeInsets.fromLTRB(20, 15, 20, 5),
                  child: Column(
                    children: [
                      Row(children: [
                        Container(
                          height: 32,
                          width: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: DecorationImage(
                              image: item['Avatar'] != null
                                  ? NetworkImage(item['Avatar'])
                                  : AssetImage('assets/images/icon/avatar.png'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(16.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        Text(item['name'] ?? '',
                            style: new TextStyle(fontSize: 18)),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Offstage(
                            offstage: !(item['tag'] == 'role'),
                            child: Row(children: [
                              InkWell(
                                child: Container(
                                    height: 36,
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Center(
                                        child: Text('添加人员' ?? '',
                                            style: new TextStyle(
                                                fontSize: 14,
                                                color: Colors.blue)))),
                                onTap: () {
                                  logic.addStaffsToRole(item);
                                },
                              ),
                              InkWell(
                                child: Container(
                                  height: 36,
                                  margin: EdgeInsets.only(left: 5, right: 5),
                                  child: Center(
                                      child: Text('编辑角色' ?? '',
                                          style: new TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue))),
                                ),
                                onTap: () {
                                  logic.editRolePermission(item);
                                },
                              )
                            ])),
                        Offstage(
                          offstage: !(item['tag'] == 'staff'),
                          child: Row(children: [
                            Text(item['detail'] ?? '',
                                style: new TextStyle(
                                    fontSize: 14, color: Colors.grey[400])),
                            // Icon(Icons.keyboard_arrow_right)
                          ]),
                        ),
                      ]),
                      // SizedBox(height: 15),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(left: 5, right: 5, top: 15),
                        color: Color(0x0f333333),
                      )
                    ],
                  )),
              actions: <Widget>[],
              secondaryActions: <Widget>[
                //右侧按钮列表
                IconSlideAction(
                  caption: '删除',
                  color: Colors.red,
                  icon: Icons.delete,
                  closeOnTap: true,
                  onTap: () {
                    logic.delete(item);
                  },
                ),
              ],
            )));
  }

// 空白提示
  Widget empty(String title) {
    return Container(
        height: 100,
        child: Center(
            child: Text(
          '联系管理员，添加$title',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0x8f333333)),
        )));
  }

// 列表内容
  List<Widget> buildGroup(
    List group,
  ) {
    return group.map((item) {
      if (item['type'] == 'header') return Container();
      if (item['type'] == 'empty') return empty(item['title']);
      return cell(item);
    }).toList();
  }

  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Obx(() => Text(state.title.value)),
          actions: [
            Obx(() => Offstage(
                offstage: !state.add.value,
                child: Container(
                  margin: EdgeInsets.only(right: 5),
                  child: InkWell(
                    child: IconButton(
                        icon: JhLoadAssetImage('icon/add_account', width: 28),
                        onPressed: logic.addStaffs),
                  ),
                )))
          ],
        ),
        body: Container(
            child: EasyRefresh(
                controller: _controller,
                firstRefresh: false,
                onRefresh: () async {
                  logic.getProjectInfo();
                },
                onLoad: () async {},
                child: ListView.builder(
                    itemCount: state.data.length,
                    itemBuilder: (context, index) {
                      return Obx(() => item(state.data, index));
                    }))));
  }
}
