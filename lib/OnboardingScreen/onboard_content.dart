import 'package:flutter/cupertino.dart';

class OnBoardContent {
  final String title;
  final String subtitle;
  final Widget image;
  final Color backgroundColor;
  final Color titleColor;
  final Color subtitleColor;

  OnBoardContent({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.backgroundColor,
    required this.titleColor,
    required this.subtitleColor,
  });
}

class CardUIView extends StatelessWidget {
  const CardUIView({super.key, required this.data});
  final OnBoardContent data;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        children: [
          const Spacer(),
          Flexible(flex: 20, child: data.image),
          const Spacer(),
          Center(
            child: Text(
              data.title.toUpperCase(),
              style: TextStyle(
                  fontFamily: 'Klasik',
                  color: data.titleColor,
                  fontSize: 22,
                  overflow: TextOverflow.clip),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
          const Spacer(),
          Center(
            child: Text(
              data.subtitle,
              style: TextStyle(
                fontFamily: 'Klasik',
                color: data.subtitleColor,
                fontSize: 20,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
              maxLines: 3,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
