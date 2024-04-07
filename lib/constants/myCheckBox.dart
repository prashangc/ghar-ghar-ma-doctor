import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';

Widget myCheckBox(name, StateHandlerBloc? dynamicBloc,
    {ValueChanged<bool>? onValueChanged, initialData}) {
  return Row(children: [
    Expanded(
      child: Text(
        name,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    SizedBox(
      width: 30.0,
      height: 30.0,
      child: StreamBuilder<dynamic>(
          initialData: initialData ?? false,
          stream: dynamicBloc!.stateStream,
          builder: (context, snapshot) {
            return Checkbox(
                activeColor: myColor.primaryColorDark,
                side: BorderSide(width: 1.0, color: myColor.primaryColorDark),
                visualDensity: const VisualDensity(horizontal: -4),
                value: snapshot.data,
                onChanged: (bool? newValue) {
                  dynamicBloc.storeData(newValue!);
                  onValueChanged!(newValue);
                });
          }),
    ),
  ]);
}
