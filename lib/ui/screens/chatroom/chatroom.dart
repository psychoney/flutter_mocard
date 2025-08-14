import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../../configs/colors.dart';
import '../../../core/network.dart';
import '../../../routes.dart';
import '../../widgets/chat_message.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/gradient_border.dart';

class ChatroomScreen extends StatefulWidget {
  const ChatroomScreen({Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatroomScreen> {
  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  final TextEditingController _messageController = TextEditingController();
  final StreamController<List<ChatMessage>> _messagesController =
      StreamController<List<ChatMessage>>.broadcast()..add([]);
  final ScrollController _scrollController = ScrollController();

  List<ChatMessage> _messages = [];
  String _currentContent = '';
  ChatMessage _currentMessage = ChatMessage(content: '', isSender: false);

  void _addMessage(String message, bool isSender) {
    _messages.add(ChatMessage(content: message, isSender: isSender));
    _messagesController.add(_messages);
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.isEmpty) {
      return;
    }
    setState(() {
      _currentContent = '';
      _currentMessage = ChatMessage(content: _currentContent, isSender: false);
    });
    // 将发送的消息添加到 _messages 列表
    _addMessage(_messageController.text, true);
    // 滚动到底部
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    //创建sse
    var uuid = Uuid();
    String randomUid = uuid.v4();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String baseUrl = await prefs.getString('base_url') ?? '';
    String token = await prefs.getString('token') ?? '';
    final String createSseUrl = baseUrl! + 'chat/createSse';

    ///GET REQUEST
    SSEClient.subscribeToSSE(method: SSERequestType.GET, url: createSseUrl, header: {
      "uid": randomUid,
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
      "X-Accel-Buffering": "no",
      "access-token": token,
    }).listen((event) async {
      print('event:' + event.toString());
      print('Id: ' + event.id!);
      print('Data: ' + event.data!);
      if (event.id == "[TOKENS]") {
        return;
      }
      if (event.id == "[DONE]") {
        print('sse close');
        SSEClient.unsubscribeFromSSE();
        _addMessage(_currentContent, false);
        // 存储消息
        await _storeMessages();
        return;
      }
      final parsedData = jsonDecode(event.data ?? "{}");
      if (parsedData['content'] == null || parsedData['content'] == "") {
        return;
      }
      final content = parsedData['content'];
      final receivedMessage = ChatMessage(content: content, isSender: false);

      // 将新消息添加到 _currentMessages 列表中
      setState(() {
        _currentContent = _currentContent + content;
        _currentMessage = ChatMessage(content: _currentContent, isSender: false);
      });
      // 更新 _messagesController
      _messagesController.add([..._messages, _currentMessage]);
      // 滚动到底部
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }, onError: (error) {
      print('Error: ' + error.toString());
    }, onDone: () {
      print('sse close');
      SSEClient.unsubscribeFromSSE();
    });

    final String chatUrl = 'chat/chat';
    final NetworkManager networkManager = NetworkManager();
    final response = await networkManager.request(
      RequestMethod.post,
      chatUrl,
      data: {
        'msg': _messageController.text,
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
    await prefs.setStringList('chat_messages', stringMessages);
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> cachedMessages = prefs.getStringList('chat_messages') ?? [];

    _messages = cachedMessages.map<ChatMessage>((dynamic item) {
      Map<String, dynamic> messageMap = jsonDecode(item);
      return ChatMessage(content: messageMap['content'], isSender: messageMap['isSender']);
    }).toList();
    _messagesController.add(_messages);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: '聊天',
        gradient: LinearGradient(
          colors: [AppColors.teal, AppColors.blue], // 为渐变设置颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<ChatMessage>>(
                stream: _messagesController.stream,
                builder: (BuildContext context, AsyncSnapshot<List<ChatMessage>> snapshot) {
                  final messages = snapshot.data ?? [];
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      // 当索引为最后一项时，显示当前接收到的消息
                      if (index == messages.length) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: _buildMessageBubble(_currentMessage),
                              ),
                            ],
                          ),
                        );
                      }
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: _buildMessageBubble(messages[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
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
                              AppColors.teal,
                              Colors.blue,
                            ], // 设置边框的渐变颜色
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: GradientBorder(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.teal,
                              AppColors.blue,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        suffixIcon: IconButton(
                          onPressed: _sendMessage,
                          icon: Icon(Icons.send),
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
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.85, // 限制消息气泡的最大宽度为屏幕宽度的60%
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: message.isSender
                  ? [AppColors.teal, AppColors.blue]
                  : [AppColors.lightCyan, AppColors.lightGreen],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: SelectableText(
            message.content,
          ),
        ),
      ),
    );
  }
}
