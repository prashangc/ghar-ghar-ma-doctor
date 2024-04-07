import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class StoreSideNavBar extends StatefulWidget {
  const StoreSideNavBar({Key? key}) : super(key: key);

  @override
  State<StoreSideNavBar> createState() => _StoreSideNavBarState();
}

class _StoreSideNavBarState extends State<StoreSideNavBar> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: maxWidth(context) / 1.3,
      height: maxHeight(context),
      child: Column(
        children: [
          Container(
            color: myColor.primaryColorDark,
            width: maxWidth(context),
            height: 120.0,
          ),
          Expanded(
            child: Container(
              width: maxWidth(context),
              color: myColor.dialogBackgroundColor,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                        padding: const EdgeInsets.only(bottom: 60.0),
                        color: kGreen,
                        height: maxHeight(context),
                        child: ListView.builder(
                            itemCount: 100,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            itemBuilder: (ctx, i) {
                              return Text('$i');
                            })),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: kRed,
                      child: const Text('a'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
