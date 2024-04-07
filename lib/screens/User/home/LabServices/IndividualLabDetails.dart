import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/payment%20gateways/khalti.dart';
import 'package:ghargharmadoctor/screens/User/side%20navigation/MyLabs/MyLabs.dart';
import 'package:ghargharmadoctor/widgets/SucessScreen.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class IndividualLabDetails extends StatefulWidget {
  final Labtests? labtests;
  final Labprofiles? labprofiles;
  const IndividualLabDetails({Key? key, this.labtests, this.labprofiles})
      : super(key: key);

  @override
  State<IndividualLabDetails> createState() => _IndividualLabDetailsState();
}

class _IndividualLabDetailsState extends State<IndividualLabDetails> {
  bool formOpenFlag = true;
  String? timeInput;
  TextEditingController dateInput = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final _form = GlobalKey<FormState>();
  bool isSwitched = false;
  String selectedPaymentMethod = 'esewa';
  StateHandlerBloc? bookBtnBloc;
  PostLabBookingModel? postLabBookingModel;
  final ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    bookBtnBloc = StateHandlerBloc();
  }

  void bookServiceBtn(context) async {
    myfocusRemover(context);
    var isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    } else {
      if (widget.labprofiles != null) {
        postLabBookingModel = PostLabBookingModel(
          date: dateInput.text,
          labProfileId: widget.labprofiles!.id,
          price: widget.labprofiles!.price.toString(),
          time: timeInput,
        );
      } else {
        postLabBookingModel = PostLabBookingModel(
          date: dateInput.text,
          labtestId: widget.labtests!.id,
          price: widget.labtests!.labprofile!.price.toString(),
          time: timeInput,
        );
      }
      if (isSwitched == true) {
        bookBtnBloc!.storeData(true);
        int statusCode;
        statusCode = await API().postData(
            context, postLabBookingModel, endpoints.postLabBookingEndpoint);

        if (statusCode == 200) {
          bookBtnBloc!.storeData(false);
          goThere(
              context,
              SucessScreen(
                btnText: 'View Labs',
                model: postLabBookingModel,
                screen: const MyLabs(),
                subTitle: 'Tap View Labs Button to find more details.',
                title: 'Lab Booked',
              ));
        } else {
          bookBtnBloc!.storeData(false);
        }
      } else {
        switch (selectedPaymentMethod) {
          case 'esewa':
            break;

          case 'khalti':
            myKhalti(
              context,
              widget.labprofiles != null
                  ? widget.labprofiles!.price.toString()
                  : widget.labtests!.labprofile!.price.toString(),
              'isLabBooking',
              postLabBookingModel,
              detailsModel: widget.labprofiles ?? widget.labtests,
              labType: widget.labprofiles != null ? 'labProfile' : 'labTest',
            );
            break;

          case 'fonePay':
            break;

          case 'imePay':
            break;

          case 'connectIPS':
            break;

          case 'prabhuPay':
            break;

          default:
        }
      }
    }
  }

  void _scrollDown() {
    _controller.animateTo(
      _controller.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: widget.labprofiles != null
              ? widget.labprofiles!.profileName.toString()
              : widget.labtests!.tests.toString(),
          color: backgroundColor,
          borderRadius: 0.0,
        ),
        body: Column(children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15.0),
            color: backgroundColor,
            width: maxWidth(context),
            height: 30.0,
          ),
          Expanded(
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: maxWidth(context),
                  padding: const EdgeInsets.symmetric(horizontal: 14.0),
                  decoration: BoxDecoration(
                    color: myColor.dialogBackgroundColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(22.0),
                      topRight: Radius.circular(22.0),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox16(),
                      Text(
                        widget.labprofiles != null
                            ? 'Included Test :'
                            : widget.labtests!.labdepartment!.department
                                .toString(),
                        style: kStyleNormal.copyWith(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox16(),
                      widget.labprofiles != null
                          ? widget.labprofiles!.labtest!.isEmpty
                              ? testCard('No any test')
                              : SizedBox(
                                  width: maxWidth(context) / 2,
                                  child: Wrap(
                                    direction: Axis.horizontal,
                                    alignment: WrapAlignment.start,
                                    spacing: 10.0,
                                    runSpacing: 10.0,
                                    children: List.generate(
                                      widget.labprofiles!.labtest!.length,
                                      (index) => testCard(widget
                                          .labprofiles!.labtest![index].tests
                                          .toString()),
                                    ),
                                  ),
                                )
                          : testCard(widget.labtests!.labprofile!.profileName
                              .toString()),
                      const SizedBox12(),
                      const Divider(),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _controller,
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              Theme(
                                data: Theme.of(context).copyWith(
                                  unselectedWidgetColor: Colors.black,
                                  primaryColor: Colors.black,
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                    key: GlobalKey(),
                                    initiallyExpanded: formOpenFlag,
                                    onExpansionChanged: (val) {
                                      formOpenFlag = val;
                                    },
                                    iconColor: myColor.primaryColorDark,
                                    childrenPadding: EdgeInsets.zero,
                                    tilePadding: EdgeInsets.zero,
                                    title: MediaQuery.removePadding(
                                      context: context,
                                      removeTop: true,
                                      removeBottom: true,
                                      child: Text(
                                        'Description',
                                        style: kStyleNormal.copyWith(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    children: <Widget>[
                                      Text(
                                        'a',
                                        // '${widget.getAllLabServicesModel.description.toString()} Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eum a nulla minus cum magnam inventore delectus repellendus repudiandae veritatis rerum dolores, ut, laudantium alias earum error temporibus tempora cumque in modi facere velit. Rem dolor deserunt ullam expedita perspiciatis id!Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eum a nulla minus cum magnam inventore delectus repellendus repudiandae veritatis rerum dolores, ut, laudantium alias earum error temporibus tempora cumque in modi facere velit. Rem dolor deserunt ullam expedita perspiciatis id!Lorem ipsum dolor sit, amet consectetur adipisicing elit. Eum a nulla minus cum magnam inventore delectus repellendus repudiandae veritatis rerum dolores, ut, laudantium alias earum error temporibus tempora cumque in modi facere velit. Rem dolor deserunt ullam expedita perspiciatis id! ',
                                        textAlign: TextAlign.justify,
                                        style: kStyleNormal.copyWith(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    ]),
                              ),
                              formOpenFlag
                                  ? Container()
                                  : Form(
                                      key: _form,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox8(),
                                          const Divider(),
                                          const SizedBox8(),
                                          Text(
                                            'Select Date',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          const SizedBox12(),
                                          TextFormField(
                                            controller: dateInput,
                                            style: kStyleNormal.copyWith(
                                              fontSize: 12.0,
                                            ),
                                            readOnly: true,
                                            onTap: () async {
                                              final DateTime? picked =
                                                  await showDatePicker(
                                                      builder:
                                                          (context, child) {
                                                        return Theme(
                                                          data:
                                                              Theme.of(context)
                                                                  .copyWith(
                                                            colorScheme:
                                                                ColorScheme
                                                                    .light(
                                                              primary: myColor
                                                                  .primaryColorDark, // header background color
                                                              onPrimary: Colors
                                                                  .white, // header text color
                                                              onSurface: Colors
                                                                  .black, // body text color
                                                            ),
                                                            textButtonTheme:
                                                                TextButtonThemeData(
                                                              style: TextButton
                                                                  .styleFrom(
                                                                foregroundColor:
                                                                    myColor
                                                                        .primaryColorDark, // button text color
                                                              ),
                                                            ),
                                                          ),
                                                          child: child!,
                                                        );
                                                      },
                                                      context: context,
                                                      initialDate: selectedDate,
                                                      firstDate:
                                                          DateTime(2015, 8),
                                                      lastDate: DateTime(2101));
                                              if (picked != null &&
                                                  picked != selectedDate) {
                                                setState(() {
                                                  selectedDate = picked;
                                                  dateInput.text = selectedDate
                                                      .toLocal()
                                                      .toString()
                                                      .split(' ')[0];
                                                });
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12.0,
                                                      vertical: 16.0),
                                              filled: true,
                                              fillColor:
                                                  Colors.white.withOpacity(0.4),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                borderSide: BorderSide(
                                                    color: Colors.white
                                                        .withOpacity(0.4),
                                                    width: 0.0),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                                borderSide: BorderSide(
                                                    color: myColor
                                                        .primaryColorDark,
                                                    width: 1.5),
                                              ),
                                              errorStyle: kStyleNormal.copyWith(
                                                  color: const Color.fromRGBO(
                                                      244, 67, 54, 1),
                                                  fontSize: 12.0),
                                              suffixIcon: Icon(
                                                FontAwesomeIcons.calendar,
                                                size: 14,
                                                color: myColor.primaryColorDark,
                                              ),
                                              border: const OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(10.0),
                                                ),
                                              ),
                                              hintText: 'Select Date',
                                              hintStyle: kStyleNormal.copyWith(
                                                fontSize: 12.0,
                                              ),
                                            ),
                                            validator: (v) {
                                              if (v!.isEmpty) {
                                                return 'Select Date';
                                              }
                                              return null;
                                            },
                                          ),
                                          const SizedBox16(),
                                          Text(
                                            'Select Time',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          const SizedBox12(),
                                          myTimePicker(
                                              context,
                                              timeInput,
                                              'Select Time',
                                              kWhite.withOpacity(0.2),
                                              'Select Time',
                                              onValueChanged: (v) {
                                            timeInput = v;
                                          }),
                                          const SizedBox16(),
                                          Text(
                                            'Payment Method',
                                            style: kStyleNormal.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.0,
                                            ),
                                          ),
                                          const SizedBox12(),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: kWhite.withOpacity(0.4),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(
                                                    isSwitched ? 12 : 0),
                                                bottomRight: Radius.circular(
                                                    isSwitched ? 12 : 0),
                                                topLeft:
                                                    const Radius.circular(12),
                                                topRight:
                                                    const Radius.circular(12.0),
                                              ),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 14.0,
                                                vertical: 16.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Pay Later',
                                                  style: kStyleNormal.copyWith(
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                                      SizedBox(
                                                  height: 20.0,
                                                  child: Switch(
                                                    value: isSwitched,
                                                    onChanged: (value) async {
                                                      myfocusRemover(context);
                                                      setState(() {
                                                        isSwitched = value;
                                                        if (isSwitched ==
                                                            false) {
                                                          _scrollDown();
                                                        }
                                                      });
                                                    },
                                                    activeTrackColor: myColor
                                                        .primaryColorDark
                                                        .withOpacity(0.3),
                                                    activeColor: myColor
                                                        .primaryColorDark,
                                                    inactiveTrackColor:
                                                        Colors.grey[200],
                                                  ),
                                                ),
                   ],
                                            ),
                                          ),
                                          isSwitched
                                              ? AnimatedSize(
                                                  curve: Curves.easeIn,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  child: SizedBox(
                                                    width: maxWidth(context),
                                                    height: 210.0,
                                                  ))
                                              : AnimatedSize(
                                                  curve: Curves.easeInOut,
                                                  duration: const Duration(
                                                      milliseconds: 200),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                isSwitched
                                                                    ? 12
                                                                    : 0),
                                                        topRight:
                                                            Radius.circular(
                                                                isSwitched
                                                                    ? 12
                                                                    : 0),
                                                        bottomLeft: const Radius
                                                            .circular(12),
                                                        bottomRight:
                                                            const Radius
                                                                .circular(12.0),
                                                      ),
                                                    ),
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 14.0,
                                                        vertical: 12.0),
                                                    child: paymentMethod(
                                                        context, false, true,
                                                        onValueChanged:
                                                            (String value) {
                                                      selectedPaymentMethod =
                                                          value;
                                                    }),
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  right: 20.0,
                  top: -30.0,
                  child: Container(
                    width: 120,
                    height: 120.0,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 0.3,
                              color: myColor.dialogBackgroundColor
                                  .withOpacity(0.8),
                              spreadRadius: 1)
                        ],
                        color: backgroundColor.withOpacity(0.4),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(12.0))),
                    child: myCachedNetworkImage(
                      maxWidth(context),
                      maxHeight(context),
                      'aa',
                      // widget.getAllLabServicesModel.serviceName,
                      const BorderRadius.all(Radius.circular(12.0)),
                      BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]),
        bottomNavigationBar: Container(
          color: myColor.dialogBackgroundColor,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          width: maxWidth(context),
          height: 85.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox8(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 60.0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Price',
                            style: kStyleNormal.copyWith(
                              fontSize: 14.0,
                            ),
                          ),
                          Text.rich(
                            TextSpan(
                              text: 'Rs  ',
                              style: kStyleNormal.copyWith(
                                fontSize: 22.0,
                                fontWeight: FontWeight.bold,
                              ),
                              children: <InlineSpan>[
                                TextSpan(
                                  text: widget.labprofiles != null
                                      ? widget.labprofiles!.price.toString()
                                      : widget.labtests!.labprofile!.price
                                          .toString(),
                                  style: kStyleNormal.copyWith(
                                    fontSize: 22.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: formOpenFlag
                        ? SizedBox(
                            height: 50.0,
                            child: myCustomButton(
                              context,
                              myColor.primaryColorDark,
                              'Proceed',
                              kStyleNormal.copyWith(
                                  fontSize: 14.0, color: Colors.white),
                              () {
                                setState(() {
                                  formOpenFlag = false;
                                });
                              },
                            ),
                          )
                        : StreamBuilder<dynamic>(
                            initialData: false,
                            stream: bookBtnBloc!.stateStream,
                            builder: (context, snapshot) {
                              if (snapshot.data == false) {
                                return SizedBox(
                                  height: 50.0,
                                  child: myCustomButton(
                                    context,
                                    myColor.primaryColorDark,
                                    'Book Service',
                                    kStyleNormal.copyWith(
                                        fontSize: 14.0, color: Colors.white),
                                    () {
                                      bookServiceBtn(context);
                                    },
                                  ),
                                );
                              } else {
                                return myBtnLoading(context, 50.0);
                              }
                            }),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testCard(test) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.0),
        color: kWhite.withOpacity(0.4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Text(
        test,
        style: kStyleNormal.copyWith(
          fontSize: 12.0,
        ),
      ),
    );
  }
}
