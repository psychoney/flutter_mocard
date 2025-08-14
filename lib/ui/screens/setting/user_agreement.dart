import 'package:flutter/material.dart';

import '../../../configs/colors.dart';
import '../../widgets/gradient_app_bar.dart';

class UserAgreementPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: '用户协议',
        gradient: LinearGradient(
          colors: [AppColors.red, AppColors.violet], // 为渐变设置颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: RichText(
          text: TextSpan(
            style: Theme.of(context).textTheme.bodyLarge,
            children: <TextSpan>[
              TextSpan(text: "1.关于本协议\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本协议是您（下文称为“用户”）与本 app 的所有者（下文称为“我们”）之间关于您使用本 app 所订立的协议。本协议描述了用户使用本 app 的权利和义务。使用本 app 即表示您同意接受本协议的所有条款。如果您不同意本协议的任何条款，请勿使用本 app。\n\n"),
              TextSpan(text: "2.用户内容\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: "本 app 允许用户存储和发送问题记录到服务器。用户应当对自己存储和发送的内容负责，并保证其不违反任何法律、法规或本协议。\n\n"),
              TextSpan(text: "3.使用规则\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "用户在使用本 app 时，应遵守以下规则：\n●不得发布、传播任何违法、淫秽、色情、赌博、暴力、恐怖或者教唆犯罪的内容；\n●不得发布、传播任何侵犯他人知识产权或其它合法权益的内容；\n●不得发布、传播任何误导、欺骗、虚假信息或者进行任何不诚实的行为；\n●不得发布、传播任何政治宣传或者进行任何政治活动；\n●不得进行任何危害网络安全的行为，包括但不限于：恶意攻击、恶意破坏、恶意干扰等；\n●不得进行任何影响本 app 正常运行的行为，包括但不限于：非法使用本 app 的资源、恶意注册、恶意请求等；\n如果用户违反了上述规则，我们有权立即终止本协议并禁止用户使用本 app。\n\n"),
              TextSpan(text: "4.知识产权\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本 app 包含的所有内容，包括但不限于文字、图片、音频、视频、软件、代码、商标、商业信息等，均受著作权、商标权、专利权及其它知识产权法律的保护。未经我们书面同意，用户不得使用、复制、修改、拷贝、发布、出售、出租、传播本 app 的任何内容。\n\n"),
              TextSpan(text: "5.服务器回答内容责任\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本app的服务器会根据用户的问题进行回答，但用户需要自行判断回答的内容的正确性和可靠性，并自行承担使用回答内容的风险。我们不对回答内容的准确性、可靠性、完整性、有效性、及时性、适用性等作出任何保证或承诺。\n\n"),
              TextSpan(text: "6.隐私保护\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "我们尊重用户的隐私权，并承诺在使用用户的个人信息时遵守相关法律法规。我们将采取合理的安全措施来保护用户的个人信息，但不对因不可抗力或非因我们的原因导致的信息泄露承担责任。\n\n"),
              TextSpan(text: "7.免责声明\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本 app 提供的信息和服务仅供参考，不构成任何担保或承诺。我们不保证本 app 的信息和服务的准确性、可靠性、完整性、有效性、及时性、适用性。用户使用本 app 的信息和服务所产生的风险由用户自行承担。\n\n"),
              TextSpan(text: "8.变更和终止\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "我们有权随时变更本协议的任何条款，并将变更后的协议在本 app 上公布。如果用户继续使用本 app，即表示用户同意受变更后的协议的约束。如果用户不同意变更后的协议，应当立即停止使用本 app。\n我们有权在任何时候终止本协议，并无需事先通知用户。在协议终止后，用户无权继续使用本 app。\n\n"),
              TextSpan(text: "9.适用法律\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本协议的订立、执行、解释及争议的解决均适用中华人民共和国法律。如发生本协议与中华人民共和国法律相抵触时，应当以中华人民共和国法律的明文规定为准。\n如双方就本协议内容或执行发生任何争议，双方应尽力友好协商解决；协商不成时，可向被告所在地的人民法院提起诉讼。\n\n"),
              TextSpan(text: "10.其他\n", style: TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(
                  text:
                      "本协议构成双方对本协议之约定事项及其他有关事宜的完整协议，除本协议规定的之外，未赋予本协议各方其他权利。\n如本协议中的任何条款无论因何种原因完全或部分无效或不具有执行力，本协议的其余条款仍应有效并且有约束力。\n本协议中的标题仅供方便参阅，不具有实际意义，不能作为本协议涵义解释的依据。\n本协议未尽事宜，您需遵守我们不时发布的其他服务条款和操作规则。\n本协议自您接受之日起生效，对我们和用户均具有约束力。"),
            ],
          ),
        ),
      ),
    );
  }
}
