/*
 * @Author: 凡琛
 * @Date: 2021-06-23 17:01:20
 * @LastEditTime: 2021-08-17 18:08:15
 * @LastEditors: Please set LastEditors
 * @Description: 系统层面API
 * @FilePath: /Rocks_Flutter/lib/api/system.dart
 */

//统一配置系统接口
class SystemApi {
  static final bool isLocaltion = false;
  static final bool isCpolar = false;
  static final String domain = isLocaltion
      ? "http://127.0.0.1:3000"
      : isCpolar
          ? 'http://rockrec.cpolar.io'
          : 'http://10.218.66.200:3000';

  static final String systemConfig = domain + "/system/systemConfig";
  static final String getCompany = domain + "/system/getCompanyList";
  static final String getCompanyHome = domain + "/system/getCompanyHome";
  static final String addCompany = domain + "/system/addCompany";
  static final String removeCompany = domain + "/system/removeCompany";
  static final String addCompanyStaffs = domain + "/system/addCompanyStaffs";
  static final String removeCompanyStaffs =
      domain + "/system/removeCompanyStaffs";
  static final String getRoleListFromProject =
      domain + "/system/getRoleListFromProject";
  static final String getPersmissionList =
      domain + "/system/getPersmissionList";
  static final String authorize = domain + "/system/authorize";
  static final String createRole = domain + "/system/createRole";
  static final String removeRole = domain + "/system/removeRole";
  static final String getSystemRoles = domain + "/system/getSystemRoles";
  static final String addStaffsToRole = domain + "/system/addStaffsToRole";
  static final String removeStaffsFromRole =
      domain + "/system/removeStaffsFromRole";
  static final String getRolePersonnalList =
      domain + "/system/getRolePersonnalList";
  static final String userAllPermissions =
      domain + "/system/userAllPermissions";

  // 用户接口
  static final String login = domain + '/login';
  static final String logout = domain + '/logout';
  static final String createUser = domain + '/createUser';
  static final String deleteUser = domain + '/deleteUser';
  static final String editUser = domain + '/editUser';
  static final String getUserList = domain + '/getUserList';
  static final String infoModify = domain + '/infoModify';
  // 项目管理接口
  static final String getRecommendList = domain + "/publish/getRecommendList";
  static final String getProject = domain + "/getProjectList";
  static final String createProject = domain + "/createProject";
  static final String deleteProject = domain + "/deleteProject";
  static final String editProject = domain + "/editProject";
  static final String getProjectHome = domain + "/getProjectHome";
  static final String addProjectStaffs = domain + "/project/addProjectStaffs";
  static final String removeProjectStaffs =
      domain + "/project/removeProjectStaffs";
  static final String removeProjectRole = domain + "/project/removeProjectRole";

  // 文件上传
  static final String upLoadFile = domain + "/upLoadFile";
  static final String upLoadFiles = domain + "/upLoadFiles";
  static final String getSignUpInfo = domain + "/getSignUpInfo";

  // 发布接口
  static final String publishSampleImage =
      domain + "/publish/publishSampleImage";

  // 个人信息查询接口
  static final String getPersonalInfo = domain + "/mine/getPersonalInfo";

  // 首页数据获取
  static final String homeList = domain + "/common/homeList";

  // 获取岩石类别接口
  static final String getRockClassToJson = domain + "/getRockClassToJson";
}

// 权限配置获取
class Auth {
  // 系统级
  static final String projectCreate = "system/project:create";
  static final String companyCreate = 'system/company:create';
  // 项目级
  static final String projectEdit = 'project:edit'; // 编辑项目
  static final String projectDelete = 'project:delete'; //删除项目
  static final String projectCheck = 'project:check'; // 核查
  static final String projectExamine = 'project:examine'; // 检查
  static final String projectAudit = 'project:audit'; // 审查
  static final String projectApprove = 'project:approve'; // 确认
  static final String projectAddStaff = "project:addstaff"; // 添加项目人员
  static final String projectAddRole = 'project:addrole'; //添加项目角色
}

// 全局广播通知
class Emit {
  static final String updatePermission = "updatePermission";
  static final String updateSystemConfig = "updateSystemConfig";
}
