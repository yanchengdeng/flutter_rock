/*
 * @Author: 凡琛
 * @Date: 2021-08-05 14:31:11
 * @LastEditTime: 2021-08-06 14:43:45
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/personnelList/personnel_list_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'personnel_list_logic.dart';
import 'personnel_list_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class PersonnelListPage extends StatelessWidget {
  final PersonnelListLogic logic = Get.put(PersonnelListLogic());
  final PersonnelListState state = Get.find<PersonnelListLogic>().state;

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
                              image: item['User']['Avatar'] != null
                                  ? NetworkImage(item['User']['Avatar'])
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
                        Text(item['User']['RealName'] ?? '',
                            style: new TextStyle(fontSize: 18)),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Row(children: [
                          Text(item['User']['UserName'] ?? '',
                              style: new TextStyle(
                                  fontSize: 14, color: Colors.grey[400])),
                          // Icon(Icons.keyboard_arrow_right)
                        ])
                      ]),
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

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(titleSpacing: 0, title: Text('人员列表')),
        body: Obx(() => EasyRefresh(
            controller: _controller,
            firstRefresh: false,
            onRefresh: () async {
              logic.getRolePersonnalList();
            },
            onLoad: () async {
              print('上拉加载');
            },
            child: state.list.length > 0
                ? ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return cell(state.list[index]);
                    })
                : Container(
                    height: 100,
                    child: Center(
                        child: Text('该角色暂无人员，请返回添加',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[400]))),
                  ))));
  }
}
