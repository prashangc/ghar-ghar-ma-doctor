import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/widgets/myCustomAppBar.dart';

class HospitalizationFormPage extends StatefulWidget {
  const HospitalizationFormPage({Key? key}) : super(key: key);

  @override
  State<HospitalizationFormPage> createState() =>
      _HospitalizationFormPageState();
}

class _HospitalizationFormPageState extends State<HospitalizationFormPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myCustomAppBar(
        title: 'Hospitalization',
        color: myColor.dialogBackgroundColor,
        borderRadius: 0.0,
      ),
      body: const Center(
        child: Text('HospitalizationFormPage'),
      ),
    );
  }
}
