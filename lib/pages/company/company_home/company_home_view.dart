/*
 * @Author: 凡琛
 * @Date: 2021-07-26 11:06:05
 * @LastEditTime: 2021-08-06 14:33:24
 * @LastEditors: Please set LastEditors
 * @Description: 公司主页
 * @FilePath: /Rocks_Flutter/lib/pages/company/company_home/company_home_view.dart
 */
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'company_home_logic.dart';
import 'company_home_state.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import '../../../utils/jh_image_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompanyHomePage extends StatelessWidget {
  final CompanyHomeLogic logic = Get.put(CompanyHomeLogic());
  final CompanyHomeState state = Get.find<CompanyHomeLogic>().state;
  Widget item(BuildContext context, RxList list, int index) {
    var item = list[index];
    // 根据数据类别返回
    Widget result;
    switch (item['type']) {
      case 'header':
        result = header(item);
        break;
      case 'cell':
        result = cell(item);
        break;
      case 'empty':
        result = empty();
        break;
      default:
    }
    return result;
  }

// 公司头部信息
  Widget header(Map item) {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 10),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
        child: Container(
            padding: EdgeInsets.only(top: 20, bottom: 20, left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['companyName'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10.0,
                ),
                Text(item['companyDescribe'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: new TextStyle(
                        fontSize: 16,
                        color: Color(0xffb1b1b1),
                        fontWeight: FontWeight.normal))
              ],
            )),
      ),
    );
  }

// 人员列表
  Widget cell(var item) {
    return InkWell(
        onTap: () {
          logic.onTapCell(item);
        },
        child: Slidable(
          actionPane: SlidableScrollActionPane(),
          //滑出选项的面板 动画
          actionExtentRatio: 0.25,
          child: Container(
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
                              image: AssetImage(item['icon'] ??
                                  'assets/images/icon/avatar.png'),
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
                        Text(item['userName'] ?? '',
                            style: new TextStyle(fontSize: 18)),
                        Flexible(fit: FlexFit.tight, child: SizedBox()),
                        Text(item['detail'] ?? '',
                            style: new TextStyle(
                                fontSize: 16, color: Colors.grey[400])),
                      ]),
                      Container(
                        height: 1,
                        margin: EdgeInsets.only(left: 5, right: 5, top: 15),
                        color: Color(0x0f333333),
                      )
                    ],
                  ))),
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
        ));
  }

  Widget empty() {
    return Container(
        height: 100,
        child: Center(
            child: Text(
          '联系管理员，添加人员',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0x8f333333)),
        )));
  }

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('公司主页'),
        actions: [
          Container(
            margin: EdgeInsets.only(right: 5),
            child: InkWell(
              child: IconButton(
                  icon: JhLoadAssetImage('icon/add_account', width: 28),
                  onPressed: logic.addStaffs),
            ),
          )
        ],
      ),
      body: Obx(() => EasyRefresh(
          controller: _controller,
          firstRefresh: false,
          onRefresh: () async {
            logic.getCompanyInfo();
          },
          onLoad: () async {},
          child: ListView.builder(
              itemCount: state.list.length,
              itemBuilder: (context, index) {
                return item(context, state.list, index);
              }))),
    );
  }
}
