import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

StateHandlerBloc logoutBloc = StateHandlerBloc();

Widget logout(context) {
  return StreamBuilder<dynamic>(
      stream: logoutBloc.stateStream,
      builder: (context, snapshot) {
        if (snapshot.data == true) {
          return logoutCard(context, isLoading: true);
        } else {
          return logoutCard(context, isLoading: false);
        }
      });
}

Widget logoutCard(context, {isLoading}) {
  return GestureDetector(
    onTap: () {
      if (isLoading == false) {
        pop_upHelper.popUpLogout(context);
      }
    },
    child: Container(
      width: maxWidth(context),
      padding: const EdgeInsets.symmetric(vertical: 14.0),
      decoration: BoxDecoration(
        color: myColor.primaryColorDark,
        borderRadius: const BorderRadius.all(
          Radius.circular(12.0),
        ),
      ),
      child: isLoading == true
          ? Center(
              child: CircularProgressIndicator(
                color: myColor.primaryColorDark,
                strokeWidth: 1.5,
                backgroundColor: myColor.primaryColor,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout,
                  color: kWhite,
                  size: 20.0,
                ),
                const SizedBox(
                  width: 8.0,
                ),
                Text(
                  'Logout',
                  style: kStyleNormal.copyWith(
                    color: kWhite,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
    ),
  );
}
