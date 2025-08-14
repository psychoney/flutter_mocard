import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:mocard/ui/screens/atelier/widgets/chat_message.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../../../configs/colors.dart';
import '../../../core/network.dart';
import '../../../routes.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_border.dart';

class AtelierScreen extends StatefulWidget {
  const AtelierScreen({Key? key}) : super(key: key);

  @override
  _AtelierScreenState createState() => _AtelierScreenState();
}

class _AtelierScreenState extends State<AtelierScreen> {
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  NavigatorState? _navigator;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _navigator = Navigator.of(context);
  }

  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  List<ChatMessage> _messages = [];

  void _addMessage(ChatMessage chatMessage) {
    setState(() {
      _messages.add(chatMessage);
    });

    // 滚动到底部
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      return;
    }

    // 将发送的消息添加到 _messages 列表
    _addMessage(ChatMessage(content: _messageController.text, messageType: 'text', isSender: true));
    //创建sse
    var uuid = Uuid();
    String randomUid = uuid.v4();
    final String createSseUrl = 'http://120.48.73.246:8091/boringland-mini/sse/createSse';

    ///GET REQUEST
    SSEClient.subscribeToSSE(method: SSERequestType.GET, url: createSseUrl, header: {
      "uid": randomUid,
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
      "X-Accel-Buffering": "no",
    }).listen((event) async {
      print('Id: ' + event.id!);
      print('Data: ' + event.data!);
      if (event.id == "[DONE]") {
        print('sse close');
        SSEClient.unsubscribeFromSSE();

        return;
      }

      final _receivedMessage =
          ChatMessage(content: '', imageUrl: event.data!.trim(), isSender: false);
      _addMessage(_receivedMessage);
      // 存储消息
      await _storeMessages();
    }, onError: (error) {
      print('Error: ' + error.toString());
    }, onDone: () {
      print('sse close');
      SSEClient.unsubscribeFromSSE();
    });

    final Dio dio = Dio();

    //发送消息
    final String chatUrl = 'chat/draw';
    final NetworkManager networkManager = NetworkManager();
    final response = await networkManager.request(
      RequestMethod.post,
      chatUrl,
      data: {
        'text': _messageController.text,
      },
      headers: {
        "uid": randomUid,
      },
    );

    if (response.data['code'] == 2002) {
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('提示'),
            content: Text('今日免费次数已用完，请购买会员继续使用'),
            actions: <Widget>[
              TextButton(
                child: Text('确定'),
                onPressed: () async {
                  Navigator.of(context).pop(); // 关闭对话框
                  await AppNavigator.push(Routes.purchase); // 跳转到购买页面
                },
              ),
            ],
          );
        },
      );
    }

    // 清除输入框
    _messageController.clear();
  }

  Future<void> _storeMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> stringMessages = _messages.map((message) => jsonEncode(message.toJson())).toList();
    await prefs.setStringList('draw_messages', stringMessages);
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> cachedMessages = prefs.getStringList('draw_messages') ?? [];
    setState(() {
      _messages = cachedMessages.map<ChatMessage>((dynamic item) {
        Map<String, dynamic> messageMap = jsonDecode(item);
        return ChatMessage(
            content: messageMap['content'],
            imageUrl: messageMap['imageUrl'],
            messageType: messageMap['messageType'],
            isSender: messageMap['isSender']);
      }).toList();
    });
  }

  void _showImageActionsDialog(BuildContext context, String imageUrl, Offset tapPosition) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(tapPosition.dx, tapPosition.dy, tapPosition.dx, 0),
      items: <PopupMenuEntry>[
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.save),
              SizedBox(width: 8.0),
              Text('保存'),
            ],
          ),
          value: 'save',
        ),
        PopupMenuDivider(),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.share),
              SizedBox(width: 8.0),
              Text('分享'),
            ],
          ),
          value: 'share',
        ),
      ],
      elevation: 8.0,
    ).then<void>((value) {
      if (value == null) return;
      if (value == 'save') {
        _saveImageToGallery(imageUrl);
      } else if (value == 'share') {
        _shareImage(imageUrl);
      }
    });
  }

  Future<void> _shareImage(String imageUrl) async {
    // 下载图片
    final response = await http.get(Uri.parse(imageUrl));

    // 将图片文件保存到缓存目录
    final tempDir = await getTemporaryDirectory();
    final file = await File('${tempDir.path}/${DateTime.now().toIso8601String()}.png').create();
    await file.writeAsBytes(response.bodyBytes);

    // 使用 shareXFiles 分享图片文件
    Share.shareXFiles([XFile(file.path)], text: '分享图片');
  }

  // 动态申请权限，需要区分android和ios，很多时候它两配置权限时各自的名称不同
  Future<bool> requestPermission() async {
    late PermissionStatus status;
    // 1、读取系统权限的弹框
    if (Platform.isIOS) {
      status = await Permission.photosAddOnly.request();
    } else {
      status = await Permission.storage.request();
    }
    // 2、假如你点not allow后，下次点击不会在出现系统权限的弹框（系统权限的弹框只会出现一次），
    // 这时候需要你自己写一个弹框，然后去打开app权限的页面
    if (status != PermissionStatus.granted) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: const Text('You need to grant album permissions'),
              content: const Text(
                  'Please go to your mobile phone to set the permission to open the corresponding album'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('cancle'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('confirm'),
                  onPressed: () {
                    Navigator.pop(context);
                    // 打开手机上该app权限的页面
                    openAppSettings();
                  },
                ),
              ],
            );
          });
    } else {
      return true;
    }
    return false;
  }

  Future<void> _saveImageToGallery(String imageUrl) async {
    bool permission = await requestPermission();
    if (!permission) {
      return;
    }
    // 请求成功后保存图片
    var response = await http.get(Uri.parse(imageUrl));
    final result = await ImageGallerySaver.saveImage(response.bodyBytes);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        // Automatically dismiss the dialog after 2 seconds
        unawaited(Future.delayed(Duration(seconds: 1), () {
          if (mounted && _navigator != null) {
            _navigator!.pop();
          }
        }));

        return Dialog(
          insetPadding: EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              width: 50,
              height: 30,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      result['isSuccess'] == true ? '保存成功！' : '保存失败，请重试！',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: '画画',
        gradient: LinearGradient(
          colors: [AppColors.red, AppColors.yellow], // 为渐变设置颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              controller: _scrollController,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildMessageBubble(_messages[index]),
                  ),
                );
              },
            )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '说点什么吧...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        enabledBorder: GradientBorder(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.red,
                              Colors.yellow,
                            ], // 设置边框的渐变颜色
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: GradientBorder(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.red,
                              AppColors.yellow,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(
                            Icons.send,
                            color: AppColors.red,
                          ),
                        ),
                      ),
                      onSubmitted: (text) {
                        _sendMessage();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: message.isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: GestureDetector(
          onTapUp: (TapUpDetails details) {
            if (message.imageUrl.isNotEmpty) {
              RenderBox box = context.findRenderObject() as RenderBox;
              Offset localPosition = box.globalToLocal(details.globalPosition);
              _showImageActionsDialog(context, message.imageUrl, localPosition);
            }
          },
          child: Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.85, // 限制消息气泡的最大宽度为屏幕宽度的85%
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: message.isSender
                    ? [AppColors.teal, AppColors.blue]
                    : [AppColors.grey, AppColors.grey],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            child: message.imageUrl.isNotEmpty
                ? Image.network(
                    message.imageUrl,
                    width: 150,
                    height: 150,
                    fit: BoxFit.cover,
                  )
                : Text(
                    message.content,
                  ),
          ),
        ),
      ),
    );
  }
}
