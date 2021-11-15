
import 'package:get/get.dart';

import 'search_widget_state.dart';
import '../../http/http.dart';
import '../../api/system.dart';
/// @description:
/// @author
/// @date: 2021/08/05 08:57:40
class SearchWidgetLogic extends GetxController {
  final state = SearchWidgetState();
  @override
  void onReady() {
    
    // state.data
    super.onReady();
  }

  getPersonInfo() async {
    var version = '0.0.1';
    // if (GetPlatform.isAndroid || GetPlatform.isIOS || GetPlatform.isMacOS) {
    //   PackageInfo packageInfo = await PackageInfo.fromPlatform();
    //   version = packageInfo.version;
    // }
    HttpRequest.post(SystemApi.getRecommendList, {'version': version},
        success: (result) {
      if (result != null &&
          result['data'] != null &&
          result['data']['mineData'] != null) {
        var res = result['data']['mineData'];
        List list = res['list'];
        print(list);
        print('111111111111');
      }
    }, fail: (error) {
      print(error);
    });
  }

  int column(int index) {
    if (index == 0 || index == 1) {
      return 1;
    } else if (index % 2 == 0) {
      return ((index + 2) / 2).toInt();
    } else {
      return ((index + 1) / 2).toInt();
    }
  }

}
