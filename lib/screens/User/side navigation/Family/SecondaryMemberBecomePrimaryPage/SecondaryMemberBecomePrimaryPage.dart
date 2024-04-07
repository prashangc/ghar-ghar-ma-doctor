import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class SecondaryMemberBecomePrimaryPage extends StatefulWidget {
  const SecondaryMemberBecomePrimaryPage({super.key});

  @override
  State<SecondaryMemberBecomePrimaryPage> createState() =>
      _SecondaryMemberBecomePrimaryPageState();
}

class _SecondaryMemberBecomePrimaryPageState
    extends State<SecondaryMemberBecomePrimaryPage> {
  String? familyRelationName, base64, changeReason;
  bool checkBoxValue = true;
  StateHandlerBloc checkBoxBloc = StateHandlerBloc();
  StateHandlerBloc loadingBloc = StateHandlerBloc();
  final _form = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: 'Become Primary',
          color: backgroundColor,
          borderRadius: 0.0,
        ),
        body: Container(
          margin: const EdgeInsets.only(top: 10.0),
          width: maxWidth(context),
          height: maxHeight(context),
          padding: const EdgeInsets.fromLTRB(12.0, 15.0, 12.0, 0.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          child: Form(
            key: _form,
            child: Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox8(),
                    mytextFormFieldWithPrefixIcon(
                      context,
                      FocusNode(),
                      'Family Relation',
                      familyRelationName ?? 'Enter your family relation',
                      'Enter your family relation',
                      familyRelationName,
                      Icons.perm_identity_outlined,
                      kWhite.withOpacity(0.4),
                      onValueChanged: (value) {
                        familyRelationName = value;
                      },
                    ),
                    Text(
                      'Reason',
                      style: kStyleNormal.copyWith(
                        fontSize: 13.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox16(),
                    myTextArea(context, kWhite.withOpacity(0.4),
                        changeReason ?? 'Enter your reason',
                        errorMessage: 'Enter your reason', onValueChanged: (v) {
                      changeReason = v;
                    }),
                    const SizedBox16(),
                    myCheckBox(
                      'Is Death ?',
                      checkBoxBloc,
                      onValueChanged: (v) {
                        setState(() {
                          checkBoxValue = v;
                        });
                      },
                      initialData: true,
                    ),
                    checkBoxValue == false ? Container() : const SizedBox16(),
                    checkBoxValue == false
                        ? Container()
                        : Text(
                            'Death Certificate',
                            style: kStyleNormal.copyWith(
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                    checkBoxValue == false ? Container() : const SizedBox16(),
                    checkBoxValue == false
                        ? Container()
                        : myImagePicker(
                            bgColor: kWhite.withOpacity(0.4),
                            onValueChanged: (v) {
                              myfocusRemover(context);
                              base64 = v.base64String;
                            },
                            textValue: 'Upload Death Certificate',
                          ),
                    const SizedBox16(),
                    StreamBuilder<dynamic>(
                        initialData: false,
                        stream: loadingBloc.stateStream,
                        builder: (c, s) {
                          return s.data == true
                              ? Center(
                                  child: Container(
                                    alignment: Alignment.center,
                                    width: 50.0,
                                    height: 50.0,
                                    child: CircularProgressIndicator(
                                      backgroundColor: myColor.primaryColorDark,
                                      color: kWhite,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: maxWidth(context),
                                  height: 50.0,
                                  child: myCustomButton(
                                    context,
                                    myColor.primaryColorDark,
                                    'Request Switch',
                                    kStyleNormal.copyWith(
                                      color: kWhite,
                                      fontSize: 14.0,
                                    ),
                                    () {
                                      requestSwitch(context);
                                    },
                                  ),
                                );
                        }),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  requestSwitch(context) {
    print(checkBoxValue);
    var isValid = _form.currentState?.validate();
    if (isValid == true) {
      if (checkBoxValue == false) {
        apiPost(context, false);
      } else {
        if (base64 != null) {
          apiPost(context, true);
        } else {
          myToast.toast("Upload Death Certificate");
        }
      }
    }
  }

  apiPost(context, boolValue) async {
    loadingBloc.storeData(true);
    int statusCode = await API().postData(
        context,
        SecondaryMemberBecomePrimaryModel(
          changeReason: changeReason,
          deathCase: boolValue == true ? 1 : 0,
          deathCertificate: base64,
          familyRelation: familyRelationName,
        ),
        endpoints.postBecomeSecondaryToPrimaryMemberEndpoint);

    if (statusCode == 200) {
      loadingBloc.storeData(false);
      mySnackbar.mySnackBar(
          context, 'Primary request sent successfully', kGreen);
      Navigator.pop(context);
    } else {
      loadingBloc.storeData(false);
    }
  }
}
