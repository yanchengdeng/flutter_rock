/*
 * @Author: 凡琛
 * @Date: 2021-07-15 10:49:37
 * @LastEditTime: 2021-08-09 18:00:11
 * @LastEditors: Please set LastEditors
 * @Description: 用户登录信息
 * @FilePath: /Rocks_Flutter/lib/utils/storage/authorStorage.dart
 */

import '../../config/projectConfig.dart';
import 'localStorage.dart';

class AuthorStorage {
  // 保存用户登录信息
  static saveAuthorInfo(data) {
    StorageUtils.saveModel(KEY_USER_DEFAULT_INFO, data);
  }

  // 获取用户登录信息
  static Map getAuthorInfo() {
    return StorageUtils.getModelWithKey(KEY_USER_DEFAULT_INFO);
  }

  // 获取用户登录名 & 密码
  static Map getAuthorPasswordInfo() {
    return StorageUtils.getModelWithKey(KEY_USER_DEFAULT_BASE_INFO);
  }

  // 删除用户登录信息
  static removeAuthorInfo() {
    StorageUtils.removeWithKey(KEY_USER_DEFAULT_INFO);
  }

  // 获取用户首次登陆
  static getFirstOpenKey() {
    bool flag = StorageUtils.getBoolWithKey(KEY_FIRST_OPEN);
    if (!flag) {
      StorageUtils.saveBool(KEY_FIRST_OPEN, true);
    }
    return !flag;
  }

  //  保存用户当前发布记录
  static saveAuthorPublishInfo(data) {
    StorageUtils.saveModel(KEY_USER_PUBLISH_INFO, data);
  }

  // 获取用户上一次发布记录
  static Map getAuthorPublishInfo() {
    return StorageUtils.getModelWithKey(KEY_USER_PUBLISH_INFO);
  }

  // 获取用户快捷发布
  static bool getQuickPublish() {
    return StorageUtils.getBoolWithKey(KEY_USER_QUICK_PUBLISH_INFO);
  }

  // 获取用户快捷发布
  static saveQuickPublish() {
    StorageUtils.saveBool(KEY_USER_QUICK_PUBLISH_INFO, true);
  }
}
