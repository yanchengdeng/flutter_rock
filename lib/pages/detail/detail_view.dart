import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';

import 'detail_logic.dart';
import 'detail_state.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

/// @description:
/// @author
/// @date: 2021/08/09 16:47:47
class DetailPage extends StatelessWidget {
  final DetailLogic logic = Get.put(DetailLogic());
  final DetailState state = Get.find<DetailLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //图片
          Container(
            child: swiperBlock(),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(12, 15, 12, 5),
            alignment: Alignment.topLeft,
            child: Text(
              '高风化程度的岩石',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                  alignment: Alignment.topLeft,
                  child: Row(
                    children: [
                      Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue),
                        child: Image(
                          image: NetworkImage(state.headImg),
                          fit: BoxFit.cover,
                        ),
                        clipBehavior: Clip.antiAlias,
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        // height: 1000,
                        // color: Colors.red,
                        child: Text(
                          '王梓豪',
                          style: TextStyle(fontSize: 18),
                        ),
                      )
                    ],
                  )),
              Container(
                padding: EdgeInsets.all(15),
                alignment: Alignment.topRight,
                child: Text(
                  '2021/8/1',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),
          //位置
          Container(
              padding: EdgeInsets.only(left: 12, right: 12, bottom: 5, top: 5),
              child: Row(
                children: [
                  Icon(
                    Icons.location_on,
                    size: 15,
                    color: Colors.blue,
                  ),
                  Text(
                    '${state.location}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.blue),
                    textAlign: TextAlign.left,
                  ),
                ],
              )),
          Expanded(
              flex: 1,
              child: Container(
                color: Colors.grey[200],
                child: ListView(
                  padding: EdgeInsets.only(top: 0),
                  children: [
                    Container(
                        child: Card(
                            margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                            //调整间距
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                            clipBehavior: Clip.antiAlias,
                            color: Colors.white, //////////卡片内颜色
                            elevation: 0,
                            child: Container(
                                padding: EdgeInsets.fromLTRB(12, 0, 12, 0),
                                child: Wrap(
                                  spacing: 5,
                                  children: [
                                    Chip(
                                      label: Text(
                                        '火成岩',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Colors.red,
                                    ),
                                    Chip(
                                      label: Text('强风化',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.blue,
                                    ),
                                    Chip(
                                      label: Text('较为完整',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.blue,
                                    ),
                                    Chip(
                                      label: Text('颜色：褐色',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.green,
                                    ),
                                    Chip(
                                      label: Text('岩石产状：水平岩层',
                                          style:
                                              TextStyle(color: Colors.white)),
                                      backgroundColor: Colors.green,
                                    ),
                                  ],
                                )))),
                    //描述
                    Container(
                        child: Card(
                      margin: EdgeInsets.fromLTRB(12, 12, 12, 0),
                      //调整间距
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)),
                      clipBehavior: Clip.antiAlias,
                      color: Colors.white, //////////卡片内颜色
                      elevation: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width - 30,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.all(15),
                              alignment: Alignment.topLeft,
                              child: Text(
                                '${state.desc}',
                                // maxLines: 10,
                                // overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),

                    //标题
                  ],
                ),
              )),

          // Container(
          //   child: ,
          // ),
        ],
      ),
    );
  }

  Widget swiperBlock() {
    return state.img.length > 0
        ? Stack(
            children: [
              Container(
                  color: Colors.black,
                  height: MediaQuery.of(Get.context).size.height / 3,
                  margin: EdgeInsets.only(bottom: 12),
                  child: Swiper(
                      itemBuilder: (BuildContext context, int index) {
                        return index != 0
                            ? Image.network(
                                state.img[index],
                                fit: BoxFit.fill,
                              )
                            : videoSnip();
                      },
                      onTap: (index) {
                        if (index != 0) {
                          Get.toNamed('/medeia',
                              arguments: {'images': state.img, 'index': index});
                        } else {
                          logic.playVideo();
                        }
                      },
                      itemCount: state.img.length,
                      pagination: SwiperPagination(
                          alignment: Alignment.bottomCenter,
                          margin: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          builder: DotSwiperPaginationBuilder(
                            space: 3, // 点之间的间隔
                            size: 5, // 没选中时的大小
                            activeSize: 8, // 选中时的大小
                            color: Colors.grey, // 没选中时的颜色
                            activeColor: Colors.white, // 选中时的颜色
                          )))),
              Positioned(
                //右上角关闭按钮
                left: 10,
                top: 40,
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios_new,
                    size: 30,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
            ],
          )
        : Container();
  }

  Widget videoSnip() {
    return GestureDetector(
        child: Obx(() => Container(
            padding: EdgeInsets.only(left: 12, bottom: 12),
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: [
                Container(
                  child: FutureBuilder(
                    //显示缩略图
                    future: state.initializeVideoPlayerFuture.value,
                    builder: (context, snapshot) {
                      print(snapshot.connectionState);
                      if (snapshot.hasError) print(snapshot.error);
                      if (snapshot.connectionState == ConnectionState.done) {
                        return AspectRatio(
                          aspectRatio: 16 / 9,
                          child: VideoPlayer(state.controller.value),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
                Positioned(
                    child: Container(
                        height: 32,
                        width: 32,
                        child: Image.asset('assets/images/icon/play.png')))
              ],
            ))));
  }
}
