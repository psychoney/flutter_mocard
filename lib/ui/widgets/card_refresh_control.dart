import 'package:flutter/cupertino.dart';
import 'package:mocard/configs/images.dart';

class CardRefreshControl extends StatelessWidget {
  final Future<void> Function() onRefresh;

  const CardRefreshControl({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (_, __, ___, ____, _____) => Image(
        image: AppImages.pikloader,
      ),
    );
  }
}
