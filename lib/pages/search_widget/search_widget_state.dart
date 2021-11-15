/// @description:
/// @author
/// @date: 2021/08/05 08:57:40
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
class SearchWidgetState {
  EasyRefreshController controller = EasyRefreshController();
  RxList projectname; //标题
  RxList description; //描述
  RxList location;    //位置
  RxList headImg;     //头像
  RxList userName;    //用户昵称
  RxList data;        //图片
  RxString title;     //bar的标题
  RxBool flag;
  double ratio;
  
  SearchWidgetState() {
    
    title = 'demo'.obs;
    flag = false.obs;
    projectname = [
      '岩石勘测',
      '岩石勘测',
      '岩石勘测',
      '岩石勘测',
      '岩石勘测',
      '岩石勘测',
    ].obs;
    description = [
      '岩石是由一种或几种矿物和天然玻璃组成的，具有稳定外形的固态集合体。由一种矿物组成的岩石称作单矿岩，如大理岩由方解石组成，石英岩由石英组成等；由数种矿物组成的岩石称作复矿岩，如花岗岩由石英、长石和云母等矿物组成，辉长岩由基性斜长石和辉石组成等等。没有一定外形的液体如石油、气体如天然气以及松散的沙、泥等，都不是岩石'
    ].obs;
    location = [
      '福建省厦门市集美区华侨大学668号',
      '北京市',
      '哈尔滨市',
      '福州市',
      '厦门市',
      '集美区',
    ].obs;
    headImg = [
      'https://img0.baidu.com/it/u=3311900507,1448170316&fm=26&fmt=auto&gp=0.jpg',
      'https://img1.baidu.com/it/u=2681504758,1624692466&fm=26&fmt=auto&gp=0.jpg',
      'https://img2.baidu.com/it/u=3303486781,1619191190&fm=11&fmt=auto&gp=0.jpg',
      'https://img2.baidu.com/it/u=325567737,3478266281&fm=26&fmt=auto&gp=0.jpg',
      'https://img2.baidu.com/it/u=1077360284,2857506492&fm=26&fmt=auto&gp=0.jpg',
      'https://img1.baidu.com/it/u=3229045480,3780302107&fm=26&fmt=auto&gp=0.jpg',
    ].obs;
    userName = [
      '吃货导航',
      '天猫官方',
      '全球新科技',
      '万有引力',
      '品牌店',
      '自然选择',
    ].obs;
    data = [
      'https://img2.baidu.com/it/u=638295967,918813223&fm=26&fmt=auto&gp=0.jpg',
      'https://img2.baidu.com/it/u=4187485475,840550705&fm=26&fmt=auto&gp=0.jpg',
      'https://img2.baidu.com/it/u=1953391638,758605331&fm=26&fmt=auto&gp=0.jpg',
      'https://pic.netbian.com/uploads/allimg/180826/113958-1535254798fc1c.jpg',
      'https://img1.baidu.com/it/u=1762495029,2388475333&fm=26&fmt=auto&gp=0.jpg',
      'https://img1.baidu.com/it/u=1417173206,1262890343&fm=26&fmt=auto&gp=0.jpg'
    ].obs;

    ///Initialize variables
  }
}
