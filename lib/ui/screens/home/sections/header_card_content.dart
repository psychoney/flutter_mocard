part of '../home.dart';

class _HeaderCardContent extends StatelessWidget {
  static const double height = 500;

  void _onSelectCategory(Category category) {
    AppNavigator.push(category.route);
  }

  @override
  Widget build(BuildContext context) {
    var themeCubit = BlocProvider.of<ThemeCubit>(context, listen: true);
    var isDark = themeCubit.isDark;

    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(10)),
      ),
      child: PokeballBackground(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Updated this
                children: [
                  IconButton(
                      onPressed: () {
                        // Function to toggle theme
                        themeCubit.toggleTheme();
                      },
                      padding: EdgeInsets.only(
                        left: 28,
                      ),
                      icon: Icon(
                        isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                        color: isDark ? Colors.yellow : Colors.black,
                        size: 25,
                      )),
                  IconButton(
                      onPressed: () {
                        AppNavigator.push(Routes.settings);
                      },
                      padding: EdgeInsets.only(
                        right: 28, // Updated this
                      ),
                      icon: Icon(
                        Icons.settings,
                        color: isDark ? Colors.yellow : Colors.black,
                        size: 25,
                      )),
                ],
              ),
            ),
            _buildTitle(),
            _buildCategories(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      height: 100, // 设置你希望的高度
      padding: EdgeInsets.all(28),
      alignment: Alignment.bottomLeft,
      child: Text(
        'Mocard魔法卡片',
        style: TextStyle(
          fontSize: 30,
          height: 1.6,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }

  Widget _buildCategories(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(28, 42, 28, 62),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        childAspectRatio: 2.6,
        mainAxisSpacing: 15,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        return CategoryCard(
          categories[index],
          onPress: () => _onSelectCategory(categories[index]),
        );
      },
    );
  }
}
