import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'constants_imports.dart';

Widget mytextFormField(
    BuildContext context, titleText, hintText, errorMessage, textValue,
    {required ValueChanged<String>? onValueChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox8(),
      TextFormField(
        textCapitalization: TextCapitalization.words,
        style: kStyleNormal.copyWith(fontSize: 12.0),
        onChanged: (String value) {
          onValueChanged!(value);
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
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
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(8.0),
            ),
          ),
          hintText: hintText,
          hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
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
      const SizedBox8(),
    ],
  );
}

Widget mytextFormFieldWithPrefixIcon(BuildContext context, FocusNode focusNode,
    titleText, hintText, errorMessage, textValue, intialIcon, bgColor,
    {required ValueChanged<String>? onValueChanged, readOnly, validateStatus}) {
  TextEditingController myText = TextEditingController();
  myText.text = textValue ?? '';
  myText.selection = TextSelection.collapsed(offset: myText.text.length);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      titleText == null
          ? Container()
          : Text(
              titleText,
              style: kStyleNormal.copyWith(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
              ),
            ),
      titleText == null ? Container() : const SizedBox16(),
      Focus(
        focusNode: focusNode,
        child: TextFormField(
          readOnly: readOnly ?? false,
          controller: myText,
          textCapitalization: TextCapitalization.words,
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
          onChanged: (String value) {
            onValueChanged!(value);
          },
          onTap: () {},
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(vertical: 17.0, horizontal: 5.0),
            filled: true,
            fillColor: bgColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
              borderSide: BorderSide(color: bgColor, width: 0.0),
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
              size: 16.0,
              color: Colors.black,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: hintText,
            hintStyle: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          validator: (v) {
            if (validateStatus != false) {
              if (v!.isEmpty) {
                return errorMessage;
              }
              return null;
            }
            return null;
          },
          onSaved: (v) {
            textValue = v;
          },
        ),
      ),
      titleText == null ? const SizedBox12() : const SizedBox16(),
    ],
  );
}

Widget mytextFormFieldWithSuffixIcon(
    BuildContext context,
    TextEditingController controller,
    titleText,
    hintText,
    errorMessage,
    textValue,
    finalIcon,
    bgColor,
    VoidCallback myTap,
    {required ValueChanged<String>? onValueChanged}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 13.0,
        ),
      ),
      const SizedBox16(),
      TextFormField(
        style: kStyleNormal.copyWith(
          color: Colors.black,
          fontSize: 13.0,
        ),
        controller: controller,
        onChanged: (String value) {
          onValueChanged!(value);
        },
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          filled: true,
          fillColor: bgColor,
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
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
          suffixIcon: GestureDetector(
            onTap: myTap,
            child: finalIcon,
          ),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          hintText: hintText,
          hintStyle: kStyleNormal.copyWith(
            color: Colors.black,
            fontSize: 13.0,
          ),
        ),
        // validator: (v) {
        //   if (v!.isEmpty) {
        //     return errorMessage;
        //   }
        //   return null;
        // },
        onSaved: (v) {
          textValue = v;
        },
      ),
      const SizedBox16(),
    ],
  );
}

Widget myFilterSearchTextField(
    BuildContext context,
    TextEditingController myController,
    labelText,
    textValue,
    intialIcon,
    filterIcon,
    Function myOnTap,
    Function suffixTap,
    {required ValueChanged<String>? onValueChanged}) {
  return Column(
    children: [
      Container(
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: myColor.scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        height: 55.0,
        child: Row(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  style: kStyleNormal.copyWith(
                      fontSize: 14.0, color: Colors.grey[400]),
                  controller: myController,
                  textCapitalization: TextCapitalization.words,
                  onChanged: (String value) {
                    onValueChanged!(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    suffixIcon: Visibility(
                      visible: myController.text.isNotEmpty ? true : false,
                      child: GestureDetector(
                        onTap: () {
                          suffixTap();
                        },
                        child: Icon(
                          Icons.close,
                          size: 15,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    prefixIcon: Icon(
                      intialIcon,
                      size: 18,
                      color: Colors.grey[400],
                    ),
                    hintText: labelText,
                    hintStyle: kStyleNormal.copyWith(color: Colors.grey[400]),
                  ),
                  onSaved: (v) {
                    textValue = v;
                  },
                ),
              ),
            ),
            const SizedBox(width: 8.0),
            GestureDetector(
              onTap: () {
                myOnTap();
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: myColor.primaryColorDark,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Icon(
                  filterIcon,
                  color: myColor.scaffoldBackgroundColor,
                ),
              ),
            ),
            const SizedBox(width: 8.0)
          ],
        ),
      ),
      const SizedBox8(),
    ],
  );
}

final form = GlobalKey<FormState>();

Widget myEmailTextFormFieldWithPrefixIcon(
    BuildContext context, titleText, labelText, textValue, intialIcon, bgColor,
    {required ValueChanged<String>? onValueChanged, isReadOnly, emailOnTap}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style: kStyleNormal.copyWith(
          fontSize: 13.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox16(),
      Form(
        key: form,
        child: TextFormField(
          onTap: () {
            if (emailOnTap != null) {
              emailOnTap();
            }
          },
          readOnly: isReadOnly ?? false,
          onChanged: (String value) {
            form.currentState?.validate();
            onValueChanged!(value);
          },
          style: kStyleNormal.copyWith(
            fontSize: 12.0,
          ),
          decoration: InputDecoration(
            errorMaxLines: 2,
            contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
            filled: true,
            fillColor: bgColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(color: bgColor, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
              borderSide: BorderSide(
                  color: isReadOnly == true
                      ? kTransparent
                      : myColor.primaryColorDark,
                  width: 1.5),
            ),
            errorStyle: kStyleNormal.copyWith(color: kRed, fontSize: 12.0),
            prefixIcon: Icon(
              intialIcon,
              size: 16.0,
              color: Colors.black,
            ),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            hintText: labelText,
            hintStyle: kStyleNormal.copyWith(
              fontSize: 12.0,
            ),
          ),
          validator: (v) {
            if (v!.isEmpty) {
              return 'Enter your email';
            } else if (!RegExp(r'^[a-zA-Z0-9.@-]+$').hasMatch(v)) {
              return '* Sorry, only letters (a-z), numbers (0-9), and periods(.) are allowed.';
            }
            return null;
          },
          onSaved: (v) {
            textValue = v;
          },
        ),
      ),
      const SizedBox16(),
    ],
  );
}

Widget myNumberTextFormField(
    titleText, labelText, errorMessage, textValue, initialIcon, bgColor,
    {ValueChanged<String>? onValueChanged, readOnlyStatus}) {
  TextEditingController myText = TextEditingController();
  if (textValue == '') {
    myText.text = '';
  } else {
    myText.text = textValue ?? '';
  }
  myText.selection = TextSelection.collapsed(offset: myText.text.length);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        titleText,
        style:
            kStyleNormal.copyWith(fontWeight: FontWeight.bold, fontSize: 13.0),
      ),
      const SizedBox16(),
      TextFormField(
        readOnly: readOnlyStatus ?? false,
        controller: myText,
        style: kStyleNormal.copyWith(fontSize: 12.0),
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
        ],
        keyboardType: TextInputType.number,
        onChanged: (String value) {
          onValueChanged!(value);
        },
        decoration: InputDecoration(
          prefixIcon: Icon(
            initialIcon,
            size: 16,
            color: Colors.black,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
          filled: true,
          fillColor: bgColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide:
                BorderSide(color: Colors.white.withOpacity(0.4), width: 0.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: const BorderRadius.all(
              Radius.circular(8.0),
            ),
            borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
          ),
          errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
          ),
          hintText: labelText,
          hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
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
      const SizedBox16(),
    ],
  );
}

Widget myNumberTextFormFieldWithoutIcon(
    hintText, errorMessage, textValue, bgColor,
    {ValueChanged<String>? onValueChanged,
    void Function(String)? myOnFieldSubmitted}) {
  return TextFormField(
    style: kStyleNormal.copyWith(fontSize: 12.0),
    inputFormatters: [
      LengthLimitingTextInputFormatter(10),
    ],
    keyboardType: TextInputType.number,
    onChanged: (String value) {
      onValueChanged!(value);
    },
    onFieldSubmitted: (String value) {
      myOnFieldSubmitted!(value);
    },
    decoration: InputDecoration(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
      filled: true,
      fillColor: bgColor,
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
        borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
      ),
      errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(5.0),
        ),
      ),
      hintText: hintText,
      hintStyle: kStyleNormal.copyWith(fontSize: 12.0),
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
  );
}

Widget myTextArea(context, color, myHintText,
    {ValueChanged<String>? onValueChanged, errorMessage, validationCheck}) {
  return SizedBox(
    width: maxWidth(context),
    child: TextFormField(
      maxLines: 4,
      style: kStyleNormal.copyWith(fontSize: 12.0),
      onChanged: (String value) {
        onValueChanged!(value);
      },
      textInputAction: TextInputAction.go,
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
        filled: true,
        fillColor: color,
        enabledBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: color, width: 0.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: myHintText,
        hintStyle: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
      validator: (v) {
        if (validationCheck == null) {
          if (v!.isEmpty) {
            return errorMessage;
          }
        }
        return null;
      },
    ),
  );
}

Widget myPasswordTextField(
    context, myObscureText, myValidateText, myHintText, password, bgColor,
    {required ValueChanged<String>? onValueChanged}) {
  return StatefulBuilder(builder: (context, setState) {
    return TextFormField(
      style: kStyleNormal.copyWith(fontSize: 12.0, color: Colors.black),
      obscureText: myObscureText,
      onChanged: (String value) {
        onValueChanged!(value);
      },
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0),
        filled: true,
        fillColor: bgColor,
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
          borderSide: BorderSide(color: myColor.primaryColorDark, width: 1.5),
        ),
        errorStyle: kStyleNormal.copyWith(color: Colors.red, fontSize: 12.0),
        prefixIcon: const Icon(
          Icons.lock_outline,
          size: 16.0,
          color: Colors.black,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              myObscureText = !myObscureText;
            });
          },
          child: Icon(
            myObscureText ? Icons.visibility_off : Icons.visibility,
            size: 16.0,
            color: Colors.black,
          ),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10.0),
          ),
        ),
        hintText: myHintText,
        hintStyle: kStyleNormal.copyWith(fontSize: 12.0, color: Colors.black),
      ),
      validator: (v) {
        if (v!.isEmpty) {
          return myValidateText;
        }
        return null;
      },
      onSaved: (v) {
        password = v;
      },
    );
  });
}
