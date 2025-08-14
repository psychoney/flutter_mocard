import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';
import 'package:mocard/routes.dart';

import '../../../data/source/server/server_datasource.dart';
import '../../../states/option/option_list_state.dart';
import '../../../utils/locator.dart';
import '../../widgets/toast.dart';

class PurchasePage extends StatefulWidget {
  @override
  _PurchasePageState createState() => _PurchasePageState();
}

class _PurchasePageState extends State<PurchasePage> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  final List<String> _kProductIds = <String>[
    'com.boringland.mocard.VIP.1year',
    'com.boringland.mocard.VIP.1month',
    'com.boringland.mocard.VIP.1week'
  ];
  final List<String> _orderTypes = <String>['year', 'month', 'week'];
  int selectedOptionIndex = 0;
  String selectedProductId = 'com.boringland.mocard.VIP.1year';
  String selectedOrderType = 'year';

  // 产品
  List<ProductDetails> products = <ProductDetails>[];
  // 购买
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  // 监听更新
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  // 订单id
  int orderId = -1;

  @override
  void initState() {
    initInAppPurchase();
    super.initState();
  }

  Future<void> initInAppPurchase() async {
    //创建监听:
    final Stream<List<PurchaseDetails>> purchaseUpdated = _inAppPurchase.purchaseStream;
    // 获得新订阅
    _subscription = purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
    }, onError: (Object error) {
      // handle error here.
    });
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      products = <ProductDetails>[];
      _purchases = <PurchaseDetails>[];
      Toast.toast(msg: 'Store unavailable');
      return;
    }
    //结束上一次购买事物
    var paymentWrapper = SKPaymentQueueWrapper();
    var transactions = await paymentWrapper.transactions();
    transactions.forEach((transaction) async {
      await paymentWrapper.finishTransaction(transaction);
    });

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }
    // 加载待售产品
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      return;
    }
    if (productDetailResponse.productDetails.isEmpty) {
      products = productDetailResponse.productDetails;
      _purchases = <PurchaseDetails>[];
      return;
    }
    products = productDetailResponse.productDetails;
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase.getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

//商品回调   处理购买更新
  Future<void> _listenToPurchaseUpdated(List<PurchaseDetails> purchaseDetailsList) async {
    //排序
    final sortedList = List.from(purchaseDetailsList);
    sortedList.sort((a, b) => (int.tryParse(b.transactionDate ?? '') ?? 0)
        .compareTo(int.tryParse(a.transactionDate ?? '') ?? 0));
    // 商品列表
    for (final PurchaseDetails purchaseDetails in sortedList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        Toast.toast(msg: '请等待支付结果');
        showLoadingDialog(context);
      } else {
        //支付错误
        if (purchaseDetails.status == PurchaseStatus.error ||
            purchaseDetails.status == PurchaseStatus.canceled) {
          Toast.toast(msg: '${purchaseDetails.error!}');
          hideLoadingDialog(context);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          //购买成功  到服务器验证
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          //恢复购买  到服务器验证
          final bool valid = await _verifyPurchase(purchaseDetails);
          await _inAppPurchase.completePurchase(purchaseDetails);
          if (valid) {
            unawaited(deliverProduct(purchaseDetails));
            return;
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        }
      }
      if (purchaseDetails.pendingCompletePurchase) {
        hideLoadingDialog(context);
        await _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    Toast.toast(msg: '购买成功！');
    Navigator.of(context).pop();
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    final resultMap = await locator<ServerDataSource>().handleReceipt(
        productId: purchaseDetails.productID,
        transactionId: purchaseDetails.purchaseID!,
        receipt: purchaseDetails.verificationData.serverVerificationData,
        orderId: orderId,
        purchaseStatus: purchaseDetails.status.toString());
    print('resultMap: $resultMap');
    return resultMap?['success'] ?? false;
  }

  Future<int> _createOrder() async {
    final orderMap = await locator<ServerDataSource>().createOrder(orderType: selectedOrderType);
    print('orderMap: $orderMap');
    if (orderMap != null) {
      orderId = orderMap['id'];
      return orderId;
    } else {
      return orderId;
    }
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    Toast.toast(msg: '购买失败，请稍后再试！');
  }

  Future<void> pay() async {
    if (products.isEmpty) {
      Toast.toast(msg: 'No item to be paid was found, please try again later');
      return;
    }
    late PurchaseParam purchaseParam;
    ProductDetails productDetails = products.firstWhere(
      (product) => product.id == selectedProductId,
    );
    ;

    purchaseParam = PurchaseParam(
      productDetails: productDetails,
    );
    await _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  Future<void> restoringPurchase() async {
    showLoadingDialog(context);
    final bool isAvailable = await InAppPurchase.instance.isAvailable();
    if (!isAvailable) {
      Toast.toast(msg: 'Store unavailable');
      return;
    }
    await InAppPurchase.instance.restorePurchases();
  }

  void showLoadingDialog(BuildContext context) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: CupertinoActivityIndicator(
              radius: 20,
            ),
          ),
        );
      },
    );
  }

  void hideLoadingDialog(BuildContext context) {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent, // 设置背景为透明
        elevation: 0.0, // 去掉AppBar下方的阴影
        automaticallyImplyLeading: true, // 自动添加返回按钮
        iconTheme: Theme.of(context).iconTheme,
        actions: <Widget>[
          // 添加一个新的Action按钮
          TextButton(
            onPressed: () {
              restoringPurchase();
              print('恢复购买');
            },
            child: Text(
              '恢复购买',
              style: TextStyle(
                color: Theme.of(context).iconTheme.color, // 使用与AppBar返回按钮相同的颜色
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        children: <Widget>[
          _buildTitle(),
          _buildFeatureList(),
          SizedBox(height: 10.0),
          OptionList(
            onOptionSelected: (index) {
              setState(() {
                selectedOptionIndex = index;
                selectedProductId = _kProductIds[index];
                selectedOrderType = _orderTypes[index];
              });
            },
          ),
          SizedBox(height: 25.0),
          _buildPurchaseButton(),
          SizedBox(height: 20.0),
          _buildPolicyLinks(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ShaderMask(
        shaderCallback: (bounds) => LinearGradient(
          colors: [Colors.red, Colors.blue], // 你希望的渐变颜色
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(bounds),
        child: const Text(
          '升级高级会员\n解锁全部功能',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 50.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureList() {
    return Column(
      children: <Widget>[
        _buildFeatureItem('聊天创作次数无限制'),
        _buildFeatureItem('聊天创作字数无限制'),
        _buildFeatureItem('提升消息回复速度'),
        _buildFeatureItem('100%完全无广告'),
      ],
    );
  }

  Widget _buildFeatureItem(String feature) {
    final gradient = LinearGradient(
      colors: [Colors.red, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ShaderMask(
                shaderCallback: (bounds) => gradient.createShader(bounds),
                child: Icon(Icons.check, size: 30, color: Colors.white),
              ),
              SizedBox(width: 5),
              Expanded(
                child: ShaderMask(
                  shaderCallback: (bounds) => gradient.createShader(bounds),
                  child: Text(feature, style: TextStyle(color: Colors.white, fontSize: 18)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPurchaseButton() {
    final gradient = LinearGradient(
      colors: [Colors.red, Colors.blue],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Container(
      width: MediaQuery.of(context).size.width * 0.85, // 设置按钮的宽度
      height: 50.0, // 设置按钮的高度
      child: ElevatedButton(
        onPressed: () async {
          // handle purchase
          await _createOrder();
          await pay();
        },
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all(Size(0, 50)), // 设置按钮的最小尺寸
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25.0), // 设置按钮的圆角
            ),
          ),
          backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent), // 设置背景颜色为透明
          overlayColor: MaterialStateProperty.all<Color>(Colors.transparent), // 设置点击时的覆盖颜色为透明
          elevation: MaterialStateProperty.all<double>(0), // 去掉阴影
        ),
        child: Ink(
          decoration: BoxDecoration(
            gradient: gradient, // 设置渐变背景
            borderRadius: BorderRadius.circular(5.0), // 设置按钮的圆角
          ),
          child: Container(
            constraints:
                BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85), // 限制按钮的最大宽度
            alignment: Alignment.center,
            child: Text(
              '立即订阅',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPolicyLinks() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.075),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodySmall,
              children: [
                TextSpan(
                  text:
                      '确认购买后，订阅费用将通过您的iTunes账户进行支付。您的订阅将自动续期，除非在当前期限结束前至少24小时取消。购买后可在系统「设置」-「iTunesStore与App Store」-「App ID」进行退订。',
                ),
                TextSpan(
                  text: '用户协议',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      AppNavigator.push(Routes.userAgreement);
                    },
                ),
                TextSpan(text: '   '),
                TextSpan(
                  text: '隐私政策',
                  style: TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      AppNavigator.push(Routes.privacyPolicy);
                    },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
