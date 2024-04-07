import 'package:flutter/material.dart';

goThere(BuildContext context, screen) async {
  final result = await Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => screen));
  return result;
}

moveTo(BuildContext context, screen) async {
  final result = await Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => screen));
  return result;
}

swipeTo(BuildContext context, screen) async {
  final result = await Navigator.of(context)
      .push(MaterialPageRoute(builder: (BuildContext context) => screen));
  return result;
}

popNavigation(BuildContext context, screen) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
  return result;
}
