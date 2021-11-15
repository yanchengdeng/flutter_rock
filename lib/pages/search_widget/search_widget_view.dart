import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:keyboard_actions/external/platform_check/platform_check.dart';
import 'search_widget_logic.dart';
import 'search_widget_state.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:flutter_easyrefresh/easy_refresh.dart';

/// @description:
/// @author
/// @date: 2021/08/05 08:57:40
double width;

class SearchWidgetPage extends StatelessWidget {
  final SearchWidgetLogic logic = Get.put(SearchWidgetLogic());
  final SearchWidgetState state = Get.find<SearchWidgetLogic>().state;

  @override
  Widget build(BuildContext context) {
    width = (MediaQuery.of(context).size.width - 68) / 2;
    print(width);
    state.ratio =
        MediaQuery.of(context).size.width / MediaQuery.of(context).size.height;
    return MaterialApp(
        home: Obx(
      () => Scaffold(
          backgroundColor: Colors.grey[200], //背景颜色
          appBar: AppBar(
            title: Text('鉴定'),
          ),
          body: EasyRefresh(
              controller: state.controller,
              firstRefresh: true,
              onRefresh: () async {
                logic.getPersonInfo();
              },
              onLoad: () async {
                print('上拉加载');
              },
              child: PlatformCheck.isIOS
                  //ios布局
                  ? StaggeredGridView.countBuilder(
                      // padding: EdgeInsets.only(left: 10, right: 10),
                      crossAxisCount: 2,
                      itemCount: state.data.length,
                      itemBuilder: (context, int index) {
                        return item(context, index);
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(
                              1,
                              index.isEven
                                  ? width / state.ratio / 320
                                  : width / state.ratio / 335),
                      mainAxisSpacing: 0, //子组件纵向间距
                      crossAxisSpacing: 0, //子组件水平间距
                    )
                  //安卓布局
                  : StaggeredGridView.countBuilder(
                      // padding: EdgeInsets.only(left: 10, right: 10),
                      crossAxisCount: 2,
                      itemCount: state.data.length,
                      itemBuilder: (context, int index) {
                        return item(context, index);
                      },
                      staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(
                              1,
                              index.isEven
                                  ? width / state.ratio / 240
                                  : width / state.ratio / 250),
                      mainAxisSpacing: 0, //子组件纵向间距
                      crossAxisSpacing: 0, //子组件水平间距
                    ))),
    ));
  }

  Widget item(BuildContext context, int index) {
    return Material(
        child: Obx(() => Container(
            decoration: BoxDecoration(color: Colors.grey[200]),
            padding: EdgeInsets.only(left: 0, right: 0),
            child: InkWell(
                onTap: () => {},
                child: Card(
                    margin:
                        //调整间距
                        index.isEven
                            ? logic.column(index).isEven
                                ? EdgeInsets.fromLTRB(12, 5, 12, 5)
                                : EdgeInsets.fromLTRB(12, 5, 0, 5)
                            : logic.column(index).isEven
                                ? EdgeInsets.fromLTRB(12, 5, 0, 5)
                                : EdgeInsets.fromLTRB(12, 5, 12, 5),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    clipBehavior: Clip.antiAlias,
                    color: Colors.white, //////////卡片内颜色
                    elevation: 0,
                    //图片容器
                    child: Container(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/medeia', arguments: {
                              'images': state.data,
                              'index': index
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(),
                            clipBehavior: Clip.antiAlias,
                            child: Image(
                              height: index.isEven
                                  ? state.ratio * width + 25
                                  : state.ratio * width + 15,
                              width: double.infinity,
                              image: NetworkImage(state.data[index]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed('/detail');
                          },
                          child: Container(
                              child: Column(children: [
                            Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${state.projectname[index]}',
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${state.description[0]}',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                            //位置信息
                            Container(
                                padding: EdgeInsets.only(left: 8, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 15,
                                      color: Colors.blue,
                                    ),
                                    Expanded(
                                        child: Text(
                                      '${state.location[index]}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(color: Colors.blue),
                                      textAlign: TextAlign.right,
                                    )),
                                  ],
                                )),
                          ])),
                        ),
                        //信息栏容器

                        //头像及名称
                        Flexible(fit: FlexFit.tight, child: Container()),
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        color: Colors.blue),
                                    child: Image(
                                      image: NetworkImage(state.headImg[index]),
                                      fit: BoxFit.cover,
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                  ),
                                  Container(
                                      child: Text('${state.userName[index]}')),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )))))));
  }
}
