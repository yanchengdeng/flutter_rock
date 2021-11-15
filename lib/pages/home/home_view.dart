/*
 * @Author: 凡琛
 * @Date: 2021-07-16 14:08:08
 * @LastEditTime: 2021-08-13 08:53:28
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /Rocks_Flutter/lib/pages/home/home_view.dart
 */
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import '../../utils/jh_image_utils.dart';

import 'home_logic.dart';
import 'home_state.dart';

class HomePage extends StatelessWidget {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;
  // 轮播图
  Widget swiperBlock() {
    return state.pagingList.length > 0
        ? Card(
            margin: EdgeInsets.fromLTRB(12, 12, 12, 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            clipBehavior: Clip.antiAlias,
            color: Colors.white,
            child: Container(
                height: 135,
                child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return Image.network(
                        state.pagingList[index]['imageUrl'],
                        fit: BoxFit.fill,
                      );
                    },
                    onTap: (index) {
                      logic.onTapPaging(index);
                    },
                    autoplay: true,
                    itemCount: state.pagingList.length,
                    pagination: SwiperPagination(
                        alignment: Alignment.bottomCenter,
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                        builder: DotSwiperPaginationBuilder(
                          space: 3, // 点之间的间隔
                          size: 5, // 没选中时的大小
                          activeSize: 8, // 选中时的大小
                          color: Colors.grey[400], // 没选中时的颜色
                          activeColor: Colors.white, // 选中时的颜色
                        )))), //////////卡片内颜色
            elevation: 0)
        : Container();
  }

//首页圆饼入口
  Widget entryButton(Map item) {
    return state.entryList.length > 0
        ? GestureDetector(
            onTap: () => logic.onTapEntry(item),
            child: new Container(
              child: Center(
                  child: Column(
                children: [
                  Material(
                    shadowColor: Colors.blueGrey,
                    borderRadius: BorderRadius.circular(32.0),
                    color: Color(item['color']),
                    child: Container(
                      height: 60,
                      width: 60,
                      child: Center(
                        child: JhLoadAssetImage(item['icon'], width: 28),
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    item['name'],
                    style: new TextStyle(
                        color: Color(0xFF333333),
                        fontWeight: FontWeight.bold,
                        fontSize: 14),
                  ),
                ],
              )),
            ))
        : Container();
  }

//首页圆饼入口
  Widget entryBlock() {
    List<Widget> list = [];
    for (var item in state.entryList) {
      list.add(entryButton(item));
    }
    return state.entryList.length > 0
        ? Container(
            margin: EdgeInsets.only(left: 12, right: 12),
            child: Material(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                child: Container(
                    padding: EdgeInsets.only(top: 12, bottom: 12),
                    child: SingleChildScrollView(
                        child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: list,
                    )))))
        : Container();
  }

  Widget newTitle(BuildContext context) {
    return state.newsList.length > 0
        ? Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 16, bottom: 5),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          margin: EdgeInsets.only(left: 22, right: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "新闻公告",
                                style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Offstage(
                                offstage: state.hasMoreUrl.value.isEmpty,
                                child: InkWell(
                                  onTap: logic.onTapHasMore,
                                  child: Text(
                                    "查看更多",
                                    style: new TextStyle(
                                        fontSize: 14, color: Color(0xFF515151)),
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  //新闻公告模板item
  Widget newItem(ItemsClass item) {
    List<Widget> imageWidget = [];
    int n = item.imageUrl.length;
    for (var i = 0; i < n; i++) {
      var image = item.imageUrl[i];
      if (imageWidget.length > 3) continue;
      imageWidget.add(Expanded(
          flex: 100 ~/ n,
          child: GestureDetector(
            onTap: () => {
              Get.toNamed('/medeia',
                  arguments: {'images': item.imageUrl, 'index': i})
            },
            child: Container(
              height: n == 1
                  ? 180
                  : n == 2
                      ? 120
                      : n == 3
                          ? 90
                          : 90,
              margin: EdgeInsets.only(right: i == n - 1 ? 0 : 5),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(image),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(6.0),
                ),
              ),
            ),
          )));
    }
    return GestureDetector(
        onTap: () {
          logic.onTapNewItem(item);
        },
        child: Container(
            padding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
            child: Material(
              borderRadius: BorderRadius.circular(8.0),
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: new TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 18)),
                    Container(
                      margin: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: imageWidget,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Text(
                          item.detail,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: new TextStyle(
                              fontWeight: FontWeight.w300, fontSize: 14),
                        )),
                  ],
                ),
              ),
            )));
  }

// 首页主体内容
  Widget homeBlock(BuildContext context) {
    // 添加数据
    List<Widget> list = [];
    list.add(swiperBlock());
    list.add(entryBlock());
    list.add(newTitle(context));
    for (var item in state.newsList) {
      ItemsClass _item = new ItemsClass(item['title'], item['detail'],
          item['date'], item['imageUrl'], item['jumpUrl']);
      list.add(newItem(_item));
    }
    return Container(
        child: ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: list,
    ));
  }

  @override
  Widget build(BuildContext context) {
    EasyRefreshController _controller = EasyRefreshController();
    return Scaffold(
        backgroundColor: Color(0xFFF5F5F5),
        //导航栏
        appBar: AppBar(
          title: Text("华东勘测设计研究院"),
        ),
        // 页面主体，逐级元素节点布局
        body: EasyRefresh(
          child: Obx(() => homeBlock(context)),
          controller: _controller,
          firstRefresh: true,
          onRefresh: () async {
            print('下拉刷新');
            logic.getHomeList();
          },
          onLoad: () async {
            print('上拉加载');
          },
        ));
  }
}
