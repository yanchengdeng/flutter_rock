import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'intro_logic.dart';
import 'intro_state.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// @description:
/// @author
/// @date: 2021/07/21 11:39:46
class IntroPage extends StatelessWidget {
  final IntroLogic logic = Get.put(IntroLogic());
  final IntroState state = Get.find<IntroLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: buildNewFeatureWidget());
  }

  Widget buildNewFeatureWidget() {
    return Swiper(
      scrollDirection: Axis.horizontal,
      itemCount: state.imgWidgets.length,
      autoplay: false,
      loop: false,
      onIndexChanged: (index) {
        state.index = index;
      },
      itemBuilder: (BuildContext context, int index) {
        if (index != state.imgWidgets.length - 1) {
          return state.imgWidgets[index];
        } else {
          return Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              state.imgWidgets[index],
              Positioned(
                  bottom: 100,
                  child: GestureDetector(
                    child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.blue,
                          ),
                          child: Text('开 始 新 征 程',
                              style:
                                  TextStyle(fontSize: 30, color: Colors.white)),
                        ),
                        onTap: () => _jumpMain()),
                  ))
            ],
          );
        }
      },
      // 点击事件 onTap
      onTap: (index) {},
      // 分页指示器
      pagination: SwiperPagination(
          // 位置 Alignment.bottomCenter 底部中间
          alignment: Alignment.bottomCenter,
          // 距离调整
          margin: const EdgeInsets.fromLTRB(0, 0, 0, 50),
          builder: DotSwiperPaginationBuilder(
              space: 5,
              size: state.index == state.imgWidgets.length - 1 ? 0 : 10,
              activeSize: state.index == state.imgWidgets.length - 1 ? 0 : 12,
              color: Colors.white,
              activeColor: Colors.green)),
      // 页面控制器 左右翻页按钮
//          control: new SwiperControl(color: Colors.pink),
    );
  }

  _jumpMain() {
    Get.offNamedUntil(
      '/login',
      (Route<dynamic> route) => false,
    );
  }
}
