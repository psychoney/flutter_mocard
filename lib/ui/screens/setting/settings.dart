import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:mocard/data/source/server/server_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../configs/colors.dart';
import '../../../routes.dart';
import '../../../utils/locator.dart';
import '../../widgets/gradient_app_bar.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String uniqueID = '';
  String appVersion = '';
  String useagelimit = '';
  String usege = '';
  bool isVIP = false;
  String expireTime = '';
  String memberType = '';

  @override
  void initState() {
    super.initState();
    _getUniqueId();
    _getAppVersion();
    _getLimit();
  }

  Future<void> _getUniqueId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      uniqueID = prefs.getString('uniqueID') ?? '';
    });
  }

  Future<void> _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appVersion = packageInfo.version;
    });
  }

  Future<void> _getLimit() async {
    final limitMap = await locator<ServerDataSource>().getLimit();
    print('limitMap: $limitMap');
    setState(() {
      useagelimit = limitMap['useagelimit'].toString();
      isVIP = limitMap['isVIP'];
      usege = limitMap['useage'].toString();
      expireTime = limitMap['expiryTime'] ?? '';
      memberType = limitMap['memberType'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: '设置',
        gradient: LinearGradient(
          colors: [AppColors.red, AppColors.violet], // 为渐变设置颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: ListView(children: [
        SizedBox(height: 20.0),
        _buildVIPCard(context),
        SizedBox(height: 20.0),
        _buildCardItem(context, '推荐好友'),
        _buildCardItem(context, '好评鼓励'),
        _buildCardItem(context, '联系我们'),
        SizedBox(height: 20.0),
        _buildCardItem(context, '用户协议'),
        _buildCardItem(context, '隐私政策'),
        SizedBox(height: 20.0),
        _buildCardItem(context, '清除记录'),
        _buildMyId(context),
        _buildSysVersion(context),
      ]),
    );
  }

  Widget _buildVIPCard(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9, // 设置为屏幕宽度的90%
        height: MediaQuery.of(context).size.height * 0.16,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0), // 设置卡片的圆角
          ),
          margin: EdgeInsets.all(2.0),
          child: InkWell(
            onTap: () {
              _navigateToNewPage(context, '升级会员');
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: [AppColors.yellow, AppColors.lightBrown], // 设置渐变颜色
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 35.0), // 修改 padding 值
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  isVIP
                      ? Row(
                          children: [
                            Icon(
                              Icons.diamond_outlined, // 你的皇冠图标，如：Icons.crown
                              color: Colors.yellowAccent, // 你的图标颜色
                              size: 24.0, // 你的图标大小
                            ),
                            SizedBox(width: 5.0), // 为了在图标和文本之间提供一些空间
                            Text(
                              memberType,
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '今日已用$usege/$useagelimit次',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '升级会员',
                              style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '解锁无限制使用所有功能',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          ],
                        ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, // 水平内边距
                        vertical: 4.0, // 垂直内边距
                      ),
                      child: isVIP
                          ? Text(
                              expireTime + "到期",
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // 文字加粗
                              ),
                            )
                          : Text(
                              'PRO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold, // 文字加粗
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardItem(BuildContext context, String title) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 设置卡片的圆角
      ),
      margin: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () => _navigateToNewPage(context, title),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 16.0),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMyId(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 设置卡片的圆角
      ),
      margin: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () => _showCopyDialog(context),
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "我的ID",
                style: TextStyle(fontSize: 16.0),
              ),
              Spacer(), // 这将使Text和Icon之间的空间填满

              Text(
                uniqueID.length >= 12 ? uniqueID.substring(uniqueID.length - 12) : uniqueID,
                style: TextStyle(fontSize: 16.0),
              ),
              SizedBox(width: 10.0), // 在Text和Icon之间插入10.0像素的空间
              Icon(Icons.copy),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSysVersion(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0), // 设置卡片的圆角
      ),
      margin: EdgeInsets.all(2.0),
      child: InkWell(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "系统版本",
                style: TextStyle(fontSize: 16.0),
              ),
              Text(appVersion)
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    await _getLimit();
    setState(() {});
  }

  Future<void> _navigateToNewPage(BuildContext context, String title) async {
    switch (title) {
      case "升级会员":
        await Navigator.of(context).pushNamed('/settings/purchase').then((value) => loadData());
        // AppNavigator.push(Routes.purchase);
        return;
      case "推荐好友":
        _shareApp();
        return;
      case "好评鼓励":
        _requestReview();
        return;
      case "联系我们":
        _sendEmail(context);
        return;
      case "用户协议":
        AppNavigator.push(Routes.userAgreement);
        return;
      case "隐私政策":
        AppNavigator.push(Routes.privacyPolicy);
        return;
      case "清除记录":
        _showDeleteDialog(context);
        return;
    }
  }

  void _shareApp() {
    Share.share('https://apps.apple.com/cn/app/id6450166151');
  }

  void _requestReview() async {
    final InAppReview inAppReview = InAppReview.instance;

    // 检查设备是否支持内部应用程序审查
    if (await inAppReview.isAvailable()) {
      // 请求用户审查
      inAppReview.requestReview();
    }
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Email email = Email(
      body: '请在这里填写您的反馈意见：  \n\n\nID:$uniqueID,\n Version:$appVersion',
      subject: 'Mocard意见反馈',
      recipients: ['help@plantplanethome.com'],
      isHTML: false,
    );
    String platformResponse;
    try {
      await FlutterEmailSender.send(email);
      platformResponse = 'success';
    } catch (error) {
      print(error);
      platformResponse = error.toString();
    }
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(platformResponse),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context) async {
    // 弹出对话框
    final isConfirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('清除全部内容？'),
        content: Text('确定清除后将清除全部历史记录'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('清除'),
          ),
        ],
      ),
    );
    // 如果用户点击了清除，调用删除函数
    if (isConfirmed == true) {
      await deleteRecord();
    }
    // 显示一个 SnackBar，提示用户删除成功
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('清除成功'),
      ),
    );
  }

  void _showCopyDialog(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: uniqueID));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已复制到剪贴板')),
    );
  }

  Future<void> deleteRecord() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('chat_messages');
    prefs.remove('draw_messages');
    for (int i = 0; i < 30; i++) {
      prefs.remove('card_app' + i.toString());
    }
    await locator<ServerDataSource>().deleteFewshotHistory();
  }
}
