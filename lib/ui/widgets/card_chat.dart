import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:mocard/domain/entities/card.dart' as moCard;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../configs/colors.dart';
import '../../core/network.dart';
import '../../routes.dart';
import '../screens/atelier/widgets/chat_message.dart';

class CardChat extends StatefulWidget {
  final moCard.Card card;
  CardChat({required this.card});

  @override
  _CardChatState createState() => _CardChatState();
}

class _CardChatState extends State<CardChat> with WidgetsBindingObserver {
  double keyboardHeight = 0;

  @override
  void didUpdateWidget(covariant CardChat oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card != oldWidget.card) {
      // 如果 widget.card 发生了变化，重新初始化页面
      _initializePage();
    }
  }

  void _initializePage() {
    setState(() {
      List<ChatMessage> _messages = [];
      _messages.add(ChatMessage(content: widget.card.demo.first['content'], isSender: true));
      _messages.add(ChatMessage(content: widget.card.demo[1]['content'], isSender: false));
      _messagesController.add(_messages);
    });
    _loadMessages();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePage();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeMetrics() {
    final MediaQueryData mediaQueryData = MediaQueryData.fromWindow(WidgetsBinding.instance.window);
    setState(() {
      keyboardHeight =
          mediaQueryData.viewInsets.bottom != 0 ? mediaQueryData.viewInsets.bottom * 0.65 : 0;
    });
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

    //发送消息
    final String chatUrl = 'chat/shotPrompting';
    List<Map<String, dynamic>> messages = widget.card.role;
    messages.add({'role': 'user', 'content': _messageController.text});
    final NetworkManager networkManager = NetworkManager();
    final response = await networkManager.request(
      RequestMethod.post,
      chatUrl,
      data: {
        'messages': messages,
      },
      headers: {
        "uid": randomUid,
      },
    );
    messages.removeLast();
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
    await prefs.setStringList("card_chat" + widget.card.id, stringMessages);
  }

  Future<void> _loadMessages() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> cachedMessages = prefs.getStringList("card_chat" + widget.card.id) ?? [];

    _messages = cachedMessages.map<ChatMessage>((dynamic item) {
      Map<String, dynamic> messageMap = jsonDecode(item);
      return ChatMessage(content: messageMap['content'], isSender: messageMap['isSender']);
    }).toList();
    _messagesController.add(_messages);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 28),
        _buildDescription(widget.card.description),
        _buildChatMessages(),
        _buildTextField()
      ],
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
            color: message.isSender ? AppColors.lightCyan : AppColors.semiGrey,
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          child: SelectableText(
            message.content,
            style: TextStyle(color: Colors.black, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(height: 1.3),
    );
  }

  Widget _buildChatMessages() {
    return Expanded(
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
    );
  }

  //...
  Widget _buildTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        bottom: keyboardHeight + 30, // 加上键盘的高度
      ),
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
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: widget.card.appColor, // 设置单一颜色边框
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: AppColors.blue, // 设置单一颜色边框
                    width: 2.0,
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
    );
  }
//...
}
