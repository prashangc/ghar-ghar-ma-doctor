import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/screens/User/main/mainHomeScreen.dart';

class myCustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Color color;
  final double borderRadius;
  final Widget? showHomeIcon;
  final bool? isNews;
  final VoidCallback? myTap;

  const myCustomAppBar({
    Key? key,
    required this.title,
    required this.color,
    required this.borderRadius,
    this.showHomeIcon,
    this.myTap,
    this.isNews,
  }) : super(key: key);
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  State<myCustomAppBar> createState() => _myCustomAppBarState();
}

class _myCustomAppBarState extends State<myCustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: maxWidth(context),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(widget.borderRadius),
                bottomRight: Radius.circular(widget.borderRadius)),
            color: widget.color,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(
                height: 70,
                child: Center(
                  child: Text(
                    widget.title.toString(),
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                      overflow: TextOverflow.ellipsis,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 12.0,
          right: 12.0,
          child: widget.showHomeIcon != null
              ? widget.showHomeIcon!
              : GestureDetector(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const MainHomePage(index: 0, tabIndex: 0)),
                        (route) => false);
                  },
                  child: Container(
                      padding: const EdgeInsets.only(left: 12.0),
                      height: 50.0,
                      child: Icon(
                        Icons.home,
                        color: myColor.primaryColorDark,
                        size: 25.0,
                      )),
                ),
        ),
        Positioned(
          bottom: 12.0,
          left: 12.0,
          child: SizedBox(
            width: 65,
            child: GestureDetector(
              onTap: () {
                if (widget.isNews == true) {
                  widget.myTap?.call();
                } else {
                  Navigator.pop(context);
                }
              },
              child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: myColor.scaffoldBackgroundColor,
                  ),
                  margin: const EdgeInsets.only(right: 15.0, top: 12),
                  child: const Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.black,
                    size: 35.0,
                  )),
            ),
          ),
        )
      ],
    );
  }
}
