import 'package:flutter/material.dart';

class ContentView extends StatefulWidget {
  final Color contentBackgroundColor;
  final String imageUrls;
  final String description;

  const ContentView({
    super.key,
    required this.contentBackgroundColor,
    required this.imageUrls,
    required this.description,
  });

  @override
  State<ContentView> createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Image.asset(
                  widget.imageUrls,
                  height: 450,
                  width: 450,
                ),
              ),
              Center(
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      widget.description,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black,
                      ),
                    )),
              )
            ],
          ),
        ],
      ),
    );
  }
}
