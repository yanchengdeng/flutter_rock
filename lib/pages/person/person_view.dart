import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'person_logic.dart';
import 'person_state.dart';
import '../../widgets/search_bar.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class PersonPage extends StatelessWidget {
  final PersonLogic logic = Get.put(PersonLogic());
  final PersonState state = Get.find<PersonLogic>().state;
  Widget item(BuildContext context, var item, int index, int last) {
    return Column(
      children: [
        ListTile(
            // contentPadding: EdgeInsets.fromLTRB(0, 0, 0, 0),
            title: Text('华东院'),
            leading: Container(
              height: 44,
              width: 44,
              margin: EdgeInsets.only(right: 5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      NetworkImage('http://www.hdec.com/cn/images/banner1.jpg'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
            ),
            subtitle: Text('工程数字化'),
            trailing: Icon(Icons.keyboard_arrow_right),
            onTap: () {
              print("点击的index" + index.toString());
            }),
        Divider(
          height: 0.0,
          indent: 0.0,
          color: Color(0x3f333333),
        )
      ],
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
          title: SearchBar(
            hintText: '输入公司名搜索',
            // inputCallBack: logic.onSearchTextChanged,
            // cleanCallBack: logic.onCleanSearch
          ),
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
                // logic.request(state.input);
              },
            ),
            InkWell(
              child: Container(
                width: 40,
                height: 40,
                margin: EdgeInsets.only(right: 12, left: 2),
                child: Center(
                  child: Text("新建",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.normal)),
                ),
              ),
              onTap: () {
                Get.toNamed('/newproject');
              },
            )
          ],
        ),
        body: Obx(() => EasyRefresh(
            controller: _controller,
            firstRefresh: true,
            onRefresh: () async {
              // logic.getPersonInfo();
            },
            onLoad: () async {
              print('上拉加载');
            },
            child: ListView.builder(
                itemCount: state.list.length,
                itemBuilder: (context, index) {
                  return item(
                      context, state.list[index], index, state.list.length);
                }))));
  }
}
