import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'company_logic.dart';
import 'company_state.dart';
import '../../widgets/search_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompanyPage extends StatelessWidget {
  final CompanyLogic logic = Get.put(CompanyLogic());
  final CompanyState state = Get.find<CompanyLogic>().state;

  Widget slidCell(BuildContext context, var item, int index) {
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      //滑出选项的面板 动画
      enabled: state.tag.value != 0,
      actionExtentRatio: 0.25,
      child: Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                  // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  title: Text(item['CompanyName'] ?? ''),
                  leading: Container(
                    height: 33,
                    width: 32,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/icon/company.png'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(0.0),
                      ),
                    ),
                  ),
                  subtitle: Text(item['CompanyDescribe'] ?? ''),
                  trailing: state.tag.value != 0
                      ? Icon(Icons.keyboard_arrow_right, color: Colors.blue)
                      : SizedBox(),
                  onTap: () {
                    logic.onTapCell(item);
                  }),
              Divider(
                height: 0.0,
                indent: 0.0,
                color: Color(0x3f333333),
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
    );
  }

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          title: SearchBar(
              hintText: '输入公司名搜索',
              inputCallBack: logic.onSearchTextChanged,
              cleanCallBack: logic.onCleanSearch),
          actions: [
            InkWell(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(left: 2, right: 2),
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
            state.tag.value == 0
                ? SizedBox(width: 15)
                : InkWell(
                    child: Container(
                      width: 40,
                      height: 40,
                      margin: EdgeInsets.only(right: 12, left: 2),
                      child: Center(
                        child: Text("添加",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.normal)),
                      ),
                    ),
                    onTap: () async {
                      await Get.toNamed('/newproject', arguments: {'tag': 1});
                      logic.request('');
                    },
                  )
          ],
        ),
        body: Obx(() => EasyRefresh(
            controller: _controller,
            firstRefresh: false,
            onRefresh: () async {
              logic.request(state.input);
            },
            onLoad: () async {
              print('上拉加载');
            },
            child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return slidCell(context, state.list[index], index);
                }))));
  }
}
