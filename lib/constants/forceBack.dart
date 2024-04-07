import 'package:flutter/cupertino.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

class MyForceBack {
  logout(BuildContext context) async {
    final showPop = await pop_upHelper.popUpLogout(context);
    return showPop ?? false;
  }

  exitApp(BuildContext context) async {
    final showPop = await pop_upHelper.popUpExitApp(context);
    return showPop ?? false;
  }
}

final myForceBack = MyForceBack();
