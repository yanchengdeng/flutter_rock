/*
 * @Author: 凡琛
 * @Date: 2021-06-25 11:03:54
 * @LastEditTime: 2021-08-09 17:59:47
 * @LastEditors: Please set LastEditors
 * @Description: 项目全局配置
 * @FilePath: /Rocks_Flutter/lib/config/projectConfig.dart
 */
import '../utils/storage/localStorage.dart';

const KEY_USER_DEFAULT_INFO = 'KEY_USER_DEFAULT_INFO';
const KEY_USER_DEFAULT_BASE_INFO = 'KEY_USER_DEFAULT_BASE_INFO';
const KEY_FIRST_OPEN = 'KEY_FIRST_OPEN';
const KEY_USER_PUBLISH_INFO = 'KEY_USER_PUBLISH_INFO';
const KEY_USER_QUICK_PUBLISH_INFO = 'KEY_USER_QUICK_PUBLISH_INFO';

class ProjectConfig {
  Map getCurrentUserInfo() {
    // 获取当前用户登录信息
    var currentUserInfo = StorageUtils.getModelWithKey(KEY_USER_DEFAULT_INFO);
    // print('获取当前用户登录信息:$currentUserInfo');
    if (currentUserInfo != null) {
      if (currentUserInfo['token'] == null)
        currentUserInfo['token'] = 'no-token';
      if (currentUserInfo['userId'] == null)
        currentUserInfo['userId'] = 'no-userId';
    } else {
      currentUserInfo = {};
    }
    return currentUserInfo;
  }
}
