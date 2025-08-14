import 'package:flutter/material.dart';
import 'package:mocard/configs/colors.dart';
import 'package:mocard/domain/entities/card.dart' as moCard;
import 'package:mocard/ui/widgets/card_image.dart';
import 'dart:math' as math;

class MoCard extends StatelessWidget {
  static const double _cardFraction = 0.76;

  final moCard.Card card;
  final void Function()? onPress;

  const MoCard(
    this.card, {
    this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constrains) {
        final itemHeight = constrains.maxHeight;

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: card.appColor.withOpacity(0.4),
                blurRadius: 15,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  transform: GradientRotation(math.pi / 10),
                  colors: [
                    // Replace these colors with the desired gradient colors
                    card.appColor,
                    AppColors.whiteGrey,
                  ],
                ),
              ),
              child: InkWell(
                onTap: onPress,
                splashColor: Colors.white10,
                highlightColor: Colors.white10,
                child: Stack(
                  children: [
                    _buildCard(height: itemHeight),
                    _buildCardNumber(),
                    _CardContent(card),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildCard({required double height}) {
    final cardSize = height * _cardFraction;

    return Positioned(
      bottom: -2,
      right: 2,
      child: CardImage(
        size: Size.square(cardSize),
        card: card,
      ),
    );
  }

  Widget _buildCardNumber() {
    return Positioned(
      top: 10,
      right: 14,
      child: Text(
        card.id,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.black12,
        ),
      ),
    );
  }
}

class _CardContent extends StatelessWidget {
  final moCard.Card card;

  const _CardContent(this.card, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Hero(
              tag: card.title,
              child: Text(
                card.title,
                style: TextStyle(
                  fontSize: 14,
                  height: 0.7,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteGrey,
                ),
              ),
            ),
            SizedBox(height: 10),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 60),
              child: Text(
                card.description,
                style: TextStyle(
                  fontSize: 9, // Change this value to your desired font size
                  color: AppColors.whiteGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
