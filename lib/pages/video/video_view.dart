import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'video_logic.dart';
import 'video_state.dart';
import 'package:video_player/video_player.dart';
import '../medeia/LoadingPage.dart';

/// @description:
/// @author
/// @date: 2021/08/02 09:50:08
class VideoPage extends StatelessWidget {
  final VideoLogic logic = Get.put(VideoLogic());
  final VideoState state = Get.find<VideoLogic>().state;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.black,
        child: Stack(children: [
          Center(
            //视频播放
            child: FutureBuilder<bool>(
              future: started(),
              builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                if (snapshot.data == true) {
                  return AspectRatio(
                    aspectRatio: state.videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(state.videoPlayerController),
                  );
                } else {
                  return LoadingPage();
                }
              },
            ),
          ),
          //计时收起进度栏,单击展示或收起进度栏
          GestureDetector(
            onTap: () {
              if (state.flag.value == false) {
                state.flag.value = true;
                Future.delayed(Duration(milliseconds: 10000)).whenComplete(() {
                  state.flag.value = false;
                });
              } else
                state.flag.value = false;
            },
            //双击暂停
            onDoubleTap: () {
              if (state.dura <= 0.999999) {
                state.videoPlayerController.value.isPlaying
                    ? state.videoPlayerController.pause()
                    : state.videoPlayerController.play();
              }
            },
          ),
          //进度栏
          Obx(() => state.flag.value
              ? Positioned(
                  bottom: Get.bottomBarHeight + 10,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      textDirection: TextDirection.ltr,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            //当前时间
                            Container(
                              padding: EdgeInsets.only(left: 30),
                              width: 60,
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                '${durationTransform((state.dura.value * (state.videoPlayerController.value.duration.inSeconds)).floor())}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            //进度条
                            Container(
                              width: MediaQuery.of(context).size.width-130,
                              alignment: Alignment.bottomCenter,
                              child: SliderTheme(
                                child: Obx(
                                  () => Slider(
                                      autofocus: true,
                                      // min: 1.0,
                                      // max: 100.0,
                                      divisions: 1000,
                                      value: state.dura.value,
                                      label:
                                          "${durationTransform((state.dura.value * (state.videoPlayerController.value.duration.inSeconds)).floor())}",
                                      onChanged: (double val) {
                                        state.dura.value = val;
                                        logic.upDate();
                                      },
                                      onChangeStart: (double val) {
                                        state.videoPlayerController.pause();
                                      },
                                      onChangeEnd: (double val) {
                                        // state.dura.value=val;
                                        var value = (state.videoPlayerController
                                                .value.duration.inSeconds) *
                                            (val);
                                        state.videoPlayerController
                                            .seekTo(Duration(
                                          milliseconds: (value * 1000).toInt(),
                                        ));
                                        state.dura.value = val;
                                        state.videoPlayerController.play();
                                      }),
                                ),
                                data: SliderTheme.of(context).copyWith(
                                  trackShape: null, //轨道的形状
                                  trackHeight: 2, //trackHeight：滑轨的高度

                                  activeTrackColor: Colors.blue, //已滑过轨道的颜色
                                  inactiveTrackColor: Colors.grey, //未滑过轨道的颜色
                                  overlayColor: Colors.blue, //滑块边缘的颜色
                                  thumbShape: RoundSliderThumbShape(
                                    //可继承SliderComponentShape自定义形状
                                    disabledThumbRadius: 9, //禁用时滑块大小
                                    enabledThumbRadius: 4, //滑块大小
                                  ),

                                  overlayShape: RoundSliderOverlayShape(
                                    //可继承SliderComponentShape自定义形状
                                    overlayRadius: 14, //滑块外圈大小
                                  ),
                                ),
                              ),
                            ),
                            //总时间
                            Container(
                              width: 60,
                              padding: EdgeInsets.only(right: 30),
                              alignment: Alignment.bottomRight,
                              child: Text(
                                '${durationTransform(state.videoPlayerController.value.duration.inSeconds.floor())}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        )
                      ]),
                )
              : Text('')),
          Obx(() => state.flag.value
              ? Positioned(
                  //右上角关闭按钮
                  left: 10,
                  top: MediaQuery.of(context).padding.top,
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
                )
              : Text(''))
        ]));
  }

  Future<bool> started() async {
    await state.videoPlayerController.initialize();
    await state.videoPlayerController.play();
    return true;
  }

  //时间转换 将秒转换为小时分钟
  String durationTransform(int seconds) {
    var d = Duration(seconds: seconds);
    state.parts= d.toString().split(':');
    return '${state.parts[1]}:${state.parts[2].substring(0,2)}';
  }
}
