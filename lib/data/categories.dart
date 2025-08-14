import 'package:mocard/configs/colors.dart';
import 'package:mocard/domain/entities/category.dart';
import 'package:mocard/routes.dart';

const List<Category> categories = [
  Category(name: '写作', color: AppColors.cardLightGreen, route: Routes.writing),
  Category(name: '工作', color: AppColors.cardBlue, route: Routes.working),
  Category(name: '学习', color: AppColors.cardLightPink, route: Routes.learning),
  Category(name: '生活', color: AppColors.cardLightRed, route: Routes.life),
  Category(name: '聊天', color: AppColors.cardPink, route: Routes.chatroom),
  Category(name: '画画', color: AppColors.cardYellow, route: Routes.atelier),
  // Category(name: '休息', color: AppColors.cardlightBlue, route: Routes.writing),
  // Category(name: '对话', color: AppColors.cardGreen, route: Routes.writing),
];
