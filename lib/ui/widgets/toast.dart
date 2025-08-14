import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  static void toast({required String msg}) {
    Fluttertoast.showToast(
      msg: msg,
      // gravity: ToastGravity.BOTTOM,
      // timeInSecForIosWeb: 1,
      // fontSize: 16.0,
    );
  }
}
