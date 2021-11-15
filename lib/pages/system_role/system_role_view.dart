/*
 * @Author: 凡琛
 * @Date: 2021-08-05 10:16:34
 * @LastEditTime: 2021-08-11 16:50:45
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/system_role/system_role_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'system_role_logic.dart';
import 'system_role_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../utils/jh_image_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class SystemRolePage extends StatelessWidget {
  final SystemRoleLogic logic = Get.put(SystemRoleLogic());
  final SystemRoleState state = Get.find<SystemRoleLogic>().state;

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
                              image:
                                  AssetImage('assets/images/icon/avatar.png'),
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
                        Text(item['RoleName'] ?? '',
                            style: new TextStyle(fontSize: 18)),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Offstage(
                            offstage: !(item['IsSystem'] == 1),
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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('系统角色管理'),
          actions: [
            Container(
              margin: EdgeInsets.only(right: 5),
              child: InkWell(
                child: IconButton(
                    icon: JhLoadAssetImage('icon/add_account', width: 28),
                    onPressed: logic.addRole),
              ),
            )
          ],
        ),
        body: Container(
            child: Obx(() => EasyRefresh(
                controller: _controller,
                firstRefresh: false,
                onRefresh: () async {
                  logic.getSyetemRoleList();
                },
                onLoad: () async {},
                child: ListView.builder(
                    itemCount: state.list.length,
                    itemBuilder: (context, index) {
                      return cell(state.list[index]);
                    })))));
  }
}
