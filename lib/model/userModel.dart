/*
 * @Author: 凡琛
 * @Date: 2021-06-28 10:05:18
 * @LastEditTime: 2021-06-28 10:05:57
 * @LastEditors: Please set LastEditors
 * @Description: 用户模型
 * @FilePath: /Rocks_Flutter/lib/model/userModel.dart
 */

class UserModel {
  String userID;
  String userName;
  String phone;
  String pwd;
  String token;
  String avatarUrl;
  String sex; //0男，1女
  String region;
  String nickName; //昵称

  UserModel({
    this.userID,
    this.userName,
    this.phone,
    this.pwd,
    this.token,
    this.avatarUrl,
    this.sex,
    this.region,
    this.nickName,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    userID = json['userID'];
    userName = json['userName'];
    phone = json['phone'];
    pwd = json['pwd'];
    token = json['token'];
    avatarUrl = json['avatarUrl'];
    sex = json['sex'];
    region = json['region'];
    nickName = json['nickName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['userID'] = this.userID;
    data['userName'] = this.userName;
    data['phone'] = this.phone;
    data['pwd'] = this.pwd;
    data['token'] = this.token;
    data['avatarUrl'] = this.avatarUrl;
    data['sex'] = this.sex;
    data['region'] = this.region;
    data['nickName'] = this.nickName;
    return data;
  }
}
