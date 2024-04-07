import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/widgets/myCustomAppBar.dart';

class ReferFriendPage extends StatefulWidget {
  final ProfileModel profileModel;

  const ReferFriendPage({Key? key, required this.profileModel})
      : super(key: key);

  @override
  State<ReferFriendPage> createState() => RreferStateFriendPage();
}

class RreferStateFriendPage extends State<ReferFriendPage> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _firstName, _lastName, _address, _id, _myEmail, _friendsEmail;

  @override
  void initState() {
    super.initState();
    _myEmail = widget.profileModel.member!.email;
    _id = sharedPrefs.getUserID('userID');
  }

  void _referBtn() async {
    setState(() {
      _isLoading = true;
    });
    int statusCode;

    var isValid = _form.currentState?.validate();
    if (!isValid!) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    statusCode = await API().postData(
        context,
        PostReferFriendModel(
          email: _myEmail,
          referralEmail: _friendsEmail.toString(),
          address: _address.toString(),
          firstName: _firstName.toString(),
          gdId: int.parse(_id.toString()),
          lastName: _lastName.toString(),
        ),
        endpoints.postReferAFriend);

    if (statusCode == 200) {
      setState(() {
        _isLoading = false;
      });
      mySnackbar.mySnackBar(context, 'no Error: $statusCode', Colors.green);
      _form.currentState!.reset();
    } else {
      mySnackbar.mySnackBar(
          context, 'Can\'t refer! Error: $statusCode', Colors.red);

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: myCustomAppBar(
        title: 'Refer a Friend',
        color: backgroundColor,
        borderRadius: 12.0,
      ),
      body: GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
          width: maxWidth(context),
          margin: const EdgeInsets.only(top: 12.0),
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: myColor.dialogBackgroundColor,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(25),
              topLeft: Radius.circular(25),
            ),
          ),
          height: maxHeight(context),
          child: SingleChildScrollView(
            child: Form(
              key: _form,
              child: Column(
                children: [
                  const SizedBox12(),
                  mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Friend\'s First Name',
                    _firstName,
                    'Enter your friend\'s first name',
                    _firstName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _firstName = value;
                    },
                  ),
                  mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Friend\'s Last Name',
                    _lastName,
                    'Enter your friend\'s last name',
                    _lastName,
                    Icons.perm_identity_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _lastName = value;
                    },
                  ),
                  mytextFormFieldWithPrefixIcon(
                    context,
                    FocusNode(),
                    'Friend\'s Address',
                    _address,
                    'Enter your friend\'s address',
                    _address,
                    Icons.location_on_outlined,
                    kWhite.withOpacity(0.4),
                    onValueChanged: (value) {
                      _address = value;
                    },
                  ),
                  myEmailTextFormFieldWithPrefixIcon(
                      context,
                      'Friend\'s Email',
                      _friendsEmail,
                      _friendsEmail,
                      Icons.email_outlined,
                      kWhite.withOpacity(0.4), onValueChanged: (v) {
                    _friendsEmail = v;
                  })
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _isLoading
          ? Container(
              height: 68.0,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              color: myColor.dialogBackgroundColor,
              child: Center(
                child: CircularProgressIndicator(
                    color: myColor.primaryColor,
                    backgroundColor: myColor.primaryColorDark),
              ),
            )
          : Container(
              height: 68.0,
              color: myColor.dialogBackgroundColor,
              padding:
                  const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
              width: maxWidth(context),
              child: myCustomButton(
                  context,
                  myColor.primaryColorDark,
                  'Submit',
                  kStyleNormal.copyWith(color: Colors.white, fontSize: 16.0),
                  _referBtn),
            ),
    );
  }

  Widget myRefertextFormFieldWithPrefixIcon(BuildContext context, titleText,
      labelText, errorMessage, textValue, intialIcon,
      {required ValueChanged<String>? onValueChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        TextFormField(
          style: kStyleNormal.copyWith(
              // color: focusNode.hasFocus ? Colors.black : Colors.grey[400]),
              color: Colors.grey[400]),
          onChanged: (String value) {
            onValueChanged!(value);
          },
          onTap: () {},
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide:
                  BorderSide(color: myColor.primaryColorDark, width: 1.5),
            ),
            errorStyle:
                kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
            prefixIcon: Icon(
              intialIcon,
              size: 20,
              color: Colors.grey[300],
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: labelText,
            hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return errorMessage;
            }
            return null;
          },
          onSaved: (v) {
            textValue = v;
          },
        ),
        const SizedBox12(),
      ],
    );
  }

  Widget myReferEmailTextFormFieldWithPrefixIcon(
      BuildContext context, titleText, labelText, textValue, intialIcon,
      {required ValueChanged<String>? onValueChanged}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleText,
          style: kStyleNormal.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox12(),
        TextFormField(
          onChanged: (String value) {
            onValueChanged!(value);
          },
          style: kStyleNormal.copyWith(
              // color: focusNode.hasFocus ? Colors.black : Colors.grey[400]),
              color: Colors.grey[400]),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: Colors.white, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide:
                  BorderSide(color: myColor.primaryColorDark, width: 1.5),
            ),
            errorStyle:
                kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
            prefixIcon: Icon(
              intialIcon,
              size: 20,
              color: Colors.grey[300],
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: labelText,
            hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
          ),
          validator: (v) {
            return EmailValidator.validate(v!)
                ? null
                : "Please enter a valid email";
          },
          onSaved: (v) {
            textValue = v;
          },
        ),
      ],
    );
  }
}
