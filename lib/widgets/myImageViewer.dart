import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class MyImageViewer extends StatefulWidget {
  final String url;
  const MyImageViewer({Key? key, required this.url}) : super(key: key);

  @override
  _MyImageViewerState createState() => _MyImageViewerState();
}

class _MyImageViewerState extends State<MyImageViewer> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          curve: Curves.fastOutSlowIn,
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: InteractiveViewer(
            panEnabled: true,
            minScale: 0.5,
            maxScale: 4,
            child: Center(
              child: Hero(
                tag: 'profilePic',
                child: myCachedNetworkImage(
                  maxWidth(context),
                  maxHeight(context) / 2,
                  widget.url,
                  const BorderRadius.all(
                    Radius.circular(0.0),
                  ),
                  BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.fromLTRB(12.0, 70.0, 0.0, 0.0),
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
                color: kWhite.withOpacity(0.3), shape: BoxShape.circle),
            child: Icon(Icons.keyboard_arrow_left_rounded,
                color: kWhite, size: 18.0),
          ),
        ),
      ],
    );
  }
}
