import 'dart:math';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class AnimatedLoading extends StatefulWidget {
  final String? image;
  final String? name;
  final String? switchType;
  const AnimatedLoading({Key? key, this.name, this.image, this.switchType})
      : super(key: key);

  @override
  State<AnimatedLoading> createState() => _AnimatedLoadingState();
}

class _AnimatedLoadingState extends State<AnimatedLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> animation_rotation;
  late Animation<double> animation_radius_in;
  late Animation<double> animation_radius_out;
  double initialRadius = 30.0;
  double radius = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 5));
    animation_rotation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.linear)));

    animation_radius_in = Tween<double>(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.75, 1.0, curve: Curves.elasticIn)));

    animation_radius_out = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 0.25, curve: Curves.elasticOut)));

    _controller.addListener(() {
      setState(() {
        if (_controller.value >= 0.75 && _controller.value <= 1.0) {
          radius = animation_radius_in.value * initialRadius;
        } else if (_controller.value >= 0.0 && _controller.value <= 0.25) {
          radius = animation_radius_out.value * initialRadius;
        }
      });
    });
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 50.0,
          height: 50,
          child: Center(
            child: Stack(
              children: [
                widget.image == null
                    ? Container()
                    : widget.image == 'empty'
                        ? Center(
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  widget.name!.substring(0, 1).toUpperCase(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Center(
                            child: Container(
                              width: 30.0,
                              height: 30.0,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: myCachedNetworkImageCircle(
                                30.0,
                                30.0,
                                widget.image,
                                BoxFit.cover,
                              ),
                            ),
                          ),

                // widget.image != null
                //     ? Center(
                //         child: Container(
                //           width: 30.0,
                //           height: 30.0,
                //           decoration: const BoxDecoration(
                //             shape: BoxShape.circle,
                //           ),
                //           child: myCachedNetworkImageCircle(
                //             30.0,
                //             30.0,
                //             widget.image,
                //             BoxFit.cover,
                //           ),
                //         ),
                //       )
                //     : Container(),
                RotationTransition(
                  turns: animation_rotation,
                  child: Stack(
                    children: [
                      const Dot(
                        radius: 30.0,
                        color: Color.fromARGB(31, 160, 160, 160),
                      ),
                      Transform.translate(
                        offset:
                            Offset(radius * cos(pi / 4), radius * sin(pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(2 * pi / 4), radius * sin(2 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColor,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(3 * pi / 4), radius * sin(3 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(4 * pi / 4), radius * sin(4 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColor,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(5 * pi / 4), radius * sin(5 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(6 * pi / 4), radius * sin(6 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColor,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(7 * pi / 4), radius * sin(7 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColorDark,
                        ),
                      ),
                      Transform.translate(
                        offset: Offset(
                            radius * cos(8 * pi / 4), radius * sin(8 * pi / 4)),
                        child: Dot(
                          radius: 5.0,
                          color: myColor.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        widget.image != null ? const SizedBox24() : Container(),
        widget.image != null
            ? RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: widget.switchType != null
                      ? 'Switching to\n'
                      : 'Returning to\n',
                  style: kStyleNormal.copyWith(
                    fontSize: 14.0,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: widget.switchType ?? 'User',
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }
}

class Dot extends StatelessWidget {
  final double radius;
  final Color color;

  const Dot({Key? key, required this.radius, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          )),
    );
  }
}
