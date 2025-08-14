import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:mocard/configs/colors.dart';
import 'package:mocard/domain/entities/card.dart' as moCard;
import 'package:mocard/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../../core/network.dart';

class CardApp extends StatefulWidget {
  final moCard.Card card;
  CardApp({required this.card});

  @override
  _CardAppState createState() => _CardAppState();
}

class _CardAppState extends State<CardApp> {
  TextEditingController _textEditingController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _answer = '';
  bool _showAnswer = false;
  bool _isLoading = false;

  @override
  void didUpdateWidget(covariant CardApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.card != oldWidget.card) {
      // 如果 widget.card 发生了变化，重新初始化页面
      _initializePage();
    }
  }

  void _initializePage() {
    setState(() {
      _textEditingController.text = widget.card.demo.first['content'];
      _answer = widget.card.demo[1]['content'];
      _showAnswer = true;
    });
    _loadAnswer();
  }

  @override
  void initState() {
    super.initState();
    _initializePage();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      child: Column(
        children: [
          SizedBox(height: 28),
          _buildDescription(widget.card.description),
          SizedBox(height: 12),
          _buildLabel(),
          _buildTextField(),
          SizedBox(height: 10),
          _buildSubmitButton(),
          SizedBox(height: 20),
          _buildAnswer(),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildLabel() {
    return Text(
      '主题',
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: 380,
        height: 150,
        child: Stack(children: [
          TextField(
            controller: _textEditingController,
            maxLines: 20, // 自动换行
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0), // 设置顶部和底部内边距
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0), // 设置圆角
              ),
            ),
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {
                _textEditingController.clear();
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      width: 380,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            await _getAnswer();
          },
          child: _isLoading
              ? CircularProgressIndicator(
                  color: Colors.white,
                ) // 当加载中时，显示 CircularProgressIndicator
              : Text(
                  '确定生成',
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // 加粗字体
                    fontSize: 18, // 设置字体大小
                  ),
                ),
          style: ElevatedButton.styleFrom(
            backgroundColor: widget.card.appColor, // 设置按钮颜色
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // 设置圆角大小
            ),
          )),
    );
  }

  Widget _buildAnswer() {
    if (!_showAnswer) {
      return Container();
    }

    return Column(
      children: [
        Container(
          width: 380,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.semiGrey,
            borderRadius: BorderRadius.circular(12),
          ),
          child: SelectableText(
            _answer,
            style: TextStyle(
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(height: 8),
        Container(
          width: 380,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  setState(() {
                    _answer = ''; // 清空答案
                    _showAnswer = false; // 隐藏答案文本框
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.copy),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: _answer));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('答案已复制到剪贴板')),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      style: TextStyle(height: 1.3),
    );
  }

  Future<void> _getAnswer() async {
    String keyword = _textEditingController.text;
    if (keyword.isEmpty) {
      return;
    }
    setState(() {
      _answer = '';
      _isLoading = true; // 设置为加载中
    });
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
        // 存储消息
        await _storeAnswer();
        setState(() {
          _isLoading = false; // 设置为加载完毕
        });
        return;
      }
      final parsedData = jsonDecode(event.data ?? "{}");
      if (parsedData['content'] == null || parsedData['content'] == "") {
        return;
      }
      final content = parsedData['content'];

      setState(() {
        _answer = _answer + content;
        _showAnswer = true;
      });
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
    messages.add({'role': 'user', 'content': keyword});
    final NetworkManager networkManager = NetworkManager();
    final response = await networkManager.request(
      RequestMethod.post,
      chatUrl,
      data: {
        'messages': messages,
        'cardId': widget.card.id,
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
  }

  Future<void> _storeAnswer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> questionAnswerPair = {
      'question': _textEditingController.text,
      'answer': _answer,
    };
    String jsonString = json.encode(questionAnswerPair);
    await prefs.setString("card_app" + widget.card.id, jsonString);
  }

  Future<void> _loadAnswer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = prefs.getString("card_app" + widget.card.id) ?? '';
    if (jsonString.isNotEmpty) {
      Map<String, dynamic> questionAnswerPair = json.decode(jsonString);
      setState(() {
        _textEditingController = TextEditingController(text: questionAnswerPair['question']);
        _answer = questionAnswerPair['answer'];
        _showAnswer = true;
      });
    }
  }
}
