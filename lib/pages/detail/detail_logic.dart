import 'package:get/get.dart';

import 'detail_state.dart';
import 'package:video_player/video_player.dart';


/// @description:
/// @author
/// @date: 2021/08/09 16:47:47
class DetailLogic extends GetxController {
  final state = DetailState();
  void playVideo() {
    // 跳转播放器页面
    Get.toNamed('/video', arguments: {'video': state.url});
  }

  @override
  void onReady() {
    setVideoController(
        'https://stream7.iqilu.com/10339/upload_transcode/202002/18/202002181038474liyNnnSzz.mp4');
  }

  @override
  void onClose() {
    if (state.controller != null) {
      state.controller.value.dispose();
    }
    super.onClose();
  }

  void setVideoController(String url) {
    VideoPlayerController controller = VideoPlayerController.network(url);
    controller.setLooping(false);
    Future initializeVideoPlayerFuture = controller.initialize();
    state.url = url;
    state.controller.value = controller;
    state.initializeVideoPlayerFuture.value = initializeVideoPlayerFuture;
  }
}
