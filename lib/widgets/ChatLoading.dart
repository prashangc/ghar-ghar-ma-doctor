import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class ChatLoading extends StatefulWidget {
  const ChatLoading({Key? key}) : super(key: key);

  @override
  State<ChatLoading> createState() => _ChatLoadingState();
}

class _ChatLoadingState extends State<ChatLoading>
    with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _currentIndex++;
          if (_currentIndex == 3) {
            _currentIndex = 0;
          }
          _animationController!.reset();
          _animationController!.forward();
        }
      });
    _animationController!.forward();
  }

  @override
  void dispose() {
    _animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController!,
      builder: (context, child) {
        return Container(
          alignment: Alignment.topCenter,
          width: 40.0,
          height: 12.0,
          child: ListView.builder(
              itemCount: 3,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 5.0,
                        backgroundColor: index == _currentIndex
                            ? myColor.primaryColorDark
                            : myColor.dialogBackgroundColor,
                      ),
                    ],
                  ),
                );
              }),
        );
      },
    );
  }
}
