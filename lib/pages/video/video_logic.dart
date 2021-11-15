import 'package:get/get.dart';
import 'video_state.dart';
/// @description:
/// @author 
/// @date: 2021/08/02 09:50:08
class VideoLogic extends GetxController {
  final state = VideoState();
  @override
  void onReady(){
    state.videoPlayerController.addListener(() { 
      state.dura.value=state.videoPlayerController.value.position.inSeconds/
            state.videoPlayerController.value.duration.inSeconds;
    });
    super.onReady();
  }
   @override
  void onClose() {
    state.videoPlayerController.dispose();
    super.onClose();
    
  }
  void upDate(){
    update();
  }

  //保存视频
//   void saveVideo() async {
//     var appDocDir = await getTemporaryDirectory();
//     String savePath = appDocDir.path + "/temp.mp4";
//     await Dio().download("http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4", savePath);
//     final result = await ImageGallerySaver.saveFile(savePath);
//     if(result!=null){
//       showToast('保存成功');
//     }
//  }
}
