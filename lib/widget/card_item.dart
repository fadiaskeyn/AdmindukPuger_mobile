import 'package:flutter/material.dart';

class CardItem extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback? onPress;

  const CardItem({
    required this.title,
    required this.iconPath,
    required this.onPress,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 2,
              offset: Offset(0, 1),
            ),
          ],
        ),
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.arrow_forward, color: Colors.grey, size: 35),
                Image.asset(
                  'assets/images/icons/$iconPath',
                  width: 71,
                  height: 71,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
