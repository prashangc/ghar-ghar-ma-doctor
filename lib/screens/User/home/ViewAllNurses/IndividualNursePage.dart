import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/NurseModel/AlNurseModel.dart';
import 'package:ghargharmadoctor/models/NurseReviewModel/GetNurseReview.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/home/ViewAllNurses/ReviewNurseBooking.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class IndividualNursePage extends StatefulWidget {
  final AllNurseModel nurseModel;
  const IndividualNursePage({Key? key, required this.nurseModel})
      : super(key: key);

  @override
  State<IndividualNursePage> createState() => _IndividualNursePageState();
}

class _IndividualNursePageState extends State<IndividualNursePage> {
  String? myDate, token, selectedTimeShift, timeUniqueID;
  int? selectedTimeShiftID;
  DateTime selectedDate = DateTime.now();
  int initialLength = 3;
  double rating = 5;
  int selectedIndexs = -1;
  List<GetNurseReview> getNurseReview = [];
  ApiHandlerBloc? nurseReviewsBloc;
  StateHandlerBloc addressHeightBloc = StateHandlerBloc();
  int selectedIndexConsultationType = 0;
  final TextEditingController _yourProblemController = TextEditingController();
  String ratingsText = 'Excellent';
  final TextEditingController _reviewController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nurseReviewsBloc = ApiHandlerBloc();
    _refreshNurseReviews();
  }

  void _refreshNurseReviews() {
    nurseReviewsBloc!.fetchAPIList(
        'nurseReview?nurse_id=${widget.nurseModel.id.toString()}');
  }

  void submitReviewBtn() async {
    int statusCode;
    if (_reviewController.text.toString().isEmpty) {
      print("is empty");
      myToast.toast('empty');
    } else {
      statusCode = await API().postData(
        context,
        PostNurseReviewModel(
          nurseId: widget.nurseModel.id,
          comment: _reviewController.text.toString(),
          rating: rating.toString().substring(0, 1),
        ),
        endpoints.postNurseReviewEndpoint,
      );
      if (statusCode == 200) {
        Navigator.pop(context);
        _refreshNurseReviews();
        setState(() {});
      }
    }
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
          title: widget.nurseModel.user!.name.toString().capitalize(),
          color: myColor.dialogBackgroundColor,
          borderRadius: 12.0,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: myCachedNetworkImageCircle(
                            maxWidth(context) / 3,
                            150.0,
                            widget.nurseModel.imagePath.toString(),
                            BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.nurseModel.user!.name
                                        .toString()
                                        .capitalize(),
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                    ),
                                  ),
                                  Text(
                                    widget.nurseModel.qualification.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    widget.nurseModel.qualification.toString(),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    widget.nurseModel.updatedAt
                                        .toString()
                                        .substring(0, 10),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Text(
                                    widget.nurseModel.updatedAt
                                        .toString()
                                        .substring(0, 10),
                                    style: kStyleNormal.copyWith(
                                      fontSize: 14.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox12(),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: kWhite,
                      ),
                      child: Column(
                        children: [
                          Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              children: [
                                myContainer(
                                  maxWidth(context) / 3 - 9,
                                  FontAwesomeIcons.thumbsUp,
                                  'Ratings',
                                  '4.7',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: VerticalDivider(
                                    width: 1.5,
                                  ),
                                ),
                                myContainer(
                                  maxWidth(context) / 3 - 9,
                                  FontAwesomeIcons.comment,
                                  'Patient Feedback',
                                  '21',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: VerticalDivider(
                                    width: 1.5,
                                  ),
                                ),
                                myContainer(
                                  maxWidth(context) / 3 - 9,
                                  Icons.medical_information,
                                  'Experience',
                                  '${widget.nurseModel.yearPracticed.toString()} Years',
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12.0),
                            child: Divider(),
                          ),
                          Container(
                            width: maxWidth(context),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: Colors.transparent,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                myContainer(
                                  maxWidth(context) / 2 - 12.75,
                                  Icons.gps_fixed,
                                  'Current Location',
                                  widget.nurseModel.address.toString(),
                                  type: 'address',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10.0),
                                  child: VerticalDivider(
                                    width: 1.5,
                                  ),
                                ),
                                myContainer(
                                  maxWidth(context) / 2 - 12.75,
                                  Icons.location_on,
                                  'Place for appointment',
                                  widget.nurseModel.address.toString(),
                                  type: 'address',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox16(),

                    // const Divider(),
                    // chooseShiftTypeWidget(),
                    // const SizedBox16(),
                  ],
                ),
              ),
              Container(
                color: myColor.dialogBackgroundColor,
                width: maxWidth(context),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: myColor.primaryColorDark,
                          child: Icon(
                            selectedIndexConsultationType == 1
                                ? Icons.person
                                : FontAwesomeIcons.video,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          'Consultation Fee',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Rs 1000',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox16(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Select Date',
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox2(),
                            Text(
                              selectedDate.toString().substring(0, 10),
                              style: kStyleNormal.copyWith(
                                  fontSize: 13.0, color: Colors.grey[400]),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {
                            final DateTime? picked = await showDatePicker(
                                builder: (context, child) {
                                  return Theme(
                                    data: Theme.of(context).copyWith(
                                      colorScheme: ColorScheme.light(
                                        primary: myColor
                                            .primaryColorDark, // header background color
                                        onPrimary:
                                            Colors.white, // header text color
                                        onSurface:
                                            Colors.black, // body text color
                                      ),
                                      textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                          foregroundColor: myColor
                                              .primaryColorDark, // button text color
                                        ),
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2015, 8),
                                lastDate: DateTime(2101));
                            if (picked != null && picked != selectedDate) {
                              setState(() {
                                selectedDate = picked;
                              });
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: myColor.primaryColorDark,
                            child: const Icon(
                              FontAwesomeIcons.calendar,
                              color: Colors.white,
                              size: 18.0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox8(),
                    const Divider(),
                    const SizedBox8(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose Time Shift',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                        ),
                        Text(
                          'Today',
                          style: kStyleNormal.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13.0,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox16(),
                    SizedBox(
                      width: maxWidth(context),
                      height: 30.0,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: widget.nurseModel.shifts!.length,
                        itemBuilder: (context, i) {
                          myDate =
                              selectedDate.toLocal().toString().split(' ')[0];
                          print(widget.nurseModel.shifts![i].date.toString());
                          return widget.nurseModel.shifts![i].date.toString() ==
                                  myDate
                              ? GestureDetector(
                                  onTap: () {
                                    print(i);

                                    setState(() {
                                      selectedTimeShiftID =
                                          widget.nurseModel.shifts![i].id;
                                      selectedIndexs = i;
                                    });
                                    selectedTimeShift = widget
                                        .nurseModel.shifts![i].shift
                                        .toString();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(right: 10.0),
                                    decoration: BoxDecoration(
                                      color: selectedIndexs == i
                                          ? myColor.primaryColorDark
                                          : Colors.transparent,
                                      border: Border.all(
                                          color: myColor.primaryColorDark,
                                          width: 1.0),
                                      borderRadius: BorderRadius.circular(
                                        6.0,
                                      ),
                                    ),
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        widget.nurseModel.shifts![i].shift
                                            .toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.clip,
                                        style: kStyleNormal.copyWith(
                                            color: selectedIndexs == i
                                                ? Colors.white
                                                : myColor.primaryColorDark),
                                      ),
                                    ),
                                  ),
                                )
                              : Container();
                        },
                      ),
                    ),
                    const SizedBox12(),
                    Text(
                      'Your Problem',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox12(),
                    SizedBox(
                      width: maxWidth(context),
                      child: TextField(
                        style: kStyleNormal.copyWith(fontSize: 12.0),
                        textInputAction: TextInputAction.go,
                        controller: _yourProblemController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12.0, vertical: 16.0),
                          filled: true,
                          fillColor: Colors.white,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: const BorderSide(
                                color: Colors.white, width: 0.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: myColor.primaryColorDark, width: 1.5),
                          ),
                          hintText: 'Enter your problem here',
                          hintStyle:
                              kStyleNormal.copyWith(color: Colors.grey[400]),
                        ),
                      ),
                    ),
                    const SizedBox12(),
                    const Divider(),
                    Text(
                      'Patients Feedback',
                      style: kStyleNormal.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const SizedBox8(),
                    Text(
                      'These feedback represent patient opinions and experiences. They do not reflect the doctor’ medical capabilities.',
                      textAlign: TextAlign.justify,
                      style: kStyleNormal.copyWith(
                        fontSize: 14.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox12(),
                    const Divider(),
                    StreamBuilder<ApiResponse<dynamic>>(
                      stream: nurseReviewsBloc!.apiListStream,
                      builder: ((context, snapshot) {
                        if (snapshot.hasData) {
                          switch (snapshot.data!.status) {
                            case Status.LOADING:
                              return Container(
                                width: maxWidth(context),
                                height: 120.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const AnimatedLoading(),
                              );
                            case Status.COMPLETED:
                              if (snapshot.data!.data.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 10.0),
                                  child: Center(
                                    child: Text(
                                      'No any reviews',
                                      style: kStyleNormal.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              getNurseReview = List<GetNurseReview>.from(
                                  snapshot.data!.data
                                      .map((i) => GetNurseReview.fromJson(i)));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${getNurseReview.length} Reviews',
                                    textAlign: TextAlign.start,
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  const SizedBox12(),
                                  ListView.builder(
                                      itemCount:
                                          getNurseReview.length > initialLength
                                              ? initialLength
                                              : getNurseReview.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return reviewsCard(
                                            getNurseReview[index]);
                                      }),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  getNurseReview.length > initialLength
                                      ? Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                initialLength =
                                                    getNurseReview.length;
                                              });
                                            },
                                            child: Text(
                                              'See more',
                                              style: kStyleNormal.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.0,
                                              ),
                                            ),
                                          ),
                                        )
                                      : getNurseReview.length < initialLength
                                          // &&
                                          //         getReviewModel.length ==
                                          //             initialLength
                                          ? Center(
                                              child: Text(
                                                'No more reviews',
                                                style: kStyleNormal.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.0,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  initialLength = 3;
                                                });
                                              },
                                              child: Center(
                                                child: Text(
                                                  'See less',
                                                  style: kStyleNormal.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                  const SizedBox12(),
                                ],
                              );
                            case Status.ERROR:
                              return Container(
                                width: maxWidth(context),
                                height: 135.0,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: Text('Server Error'),
                                ),
                              );
                          }
                        }
                        return SizedBox(
                          width: maxWidth(context),
                        );
                      }),
                    ),
                    const SizedBox12(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 15.0),
          height: 55,
          child: SizedBox(
              width: maxWidth(context),
              child: myButton(context, myColor.primaryColorDark, 'Proceed', () {
                token = sharedPrefs.getFromDevice('token');
                if (selectedTimeShift == null) {
                  myToast.toast('Please choose a time shift');
                } else if (_yourProblemController.text.isEmpty) {
                  myToast.toast('Please write a  message');
                } else {
                  if (token == null) {
                    showLoginPopUp(
                      context,
                      'bookNurse',
                      GuestLoginNavigationModel(
                        allNurseModel: widget.nurseModel,
                        dateValue: selectedDate.toString().substring(0, 10),
                        shiftValue: selectedTimeShift!,
                        yourProblem: _yourProblemController.text,
                        totalAmount: '1000',
                        selectedTimeShiftID: selectedTimeShiftID!,
                      ),
                    );
                  } else {
                    goThere(
                        context,
                        ReviewNurseBooking(
                          allNurseModel: widget.nurseModel,
                          dateValue: selectedDate.toString().substring(0, 10),
                          shiftValue: selectedTimeShift!,
                          yourProblem: _yourProblemController.text,
                          totalAmount: '1000',
                          selectedTimeShiftID: selectedTimeShiftID!,
                        ));
                  }
                }
              })),
        ),
      ),
    );
  }

  Widget myContainer(myWidth, myIcon, myTitle, myDesc, {type}) {
    return SizedBox(
      width: myWidth,
      child: Column(
        children: [
          const SizedBox(height: 8.0),
          Icon(
            myIcon,
            size: 20.0,
            color: myColor.primaryColorDark,
          ),
          const SizedBox(height: 5.0),
          Text(
            myTitle,
            style: kStyleNormal.copyWith(
              color: Colors.grey[400],
              fontSize: 10.0,
            ),
          ),
          const SizedBox(height: 2.0),
          StreamBuilder<dynamic>(
              initialData: false,
              stream: addressHeightBloc.stateStream,
              builder: (context, snapshot) {
                return GestureDetector(
                  onTap: () {
                    if (type == 'address') {
                      if (snapshot.data == false) {
                        addressHeightBloc.storeData(true);
                      } else {
                        addressHeightBloc.storeData(false);
                      }
                    }
                  },
                  child: Text(
                    myDesc,
                    maxLines: snapshot.data == true ? 100 : 1,
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 11.0,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget reviewsCard(GetNurseReview getReviewModel) {
    return Container(
      width: maxWidth(context),
      decoration: BoxDecoration(
        color: myColor.dialogBackgroundColor,
        borderRadius: BorderRadius.circular(12.0),
      ),
      margin: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: maxWidth(context),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                myCachedNetworkImage(
                  50.0,
                  50.0,
                  getReviewModel.member!.imagePath.toString(),
                  const BorderRadius.all(Radius.circular(8.0)),
                  BoxFit.cover,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        getReviewModel.member!.user!.name.toString(),
                        style: kStyleNormal.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox8(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              RatingBar.builder(
                                minRating: 1,
                                itemBuilder: (context, _) {
                                  return const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  );
                                },
                                itemCount: 1,
                                initialRating: rating,
                                updateOnDrag: true,
                                itemSize: 20.0,
                                itemPadding: const EdgeInsets.only(right: 2.0),
                                onRatingUpdate: (rating) => setState(() {
                                  this.rating = rating;
                                }),
                              ),
                              const SizedBox(
                                width: 6.0,
                              ),
                              Text(
                                getReviewModel.rating.toString(),
                                style: kStyleNormal,
                              ),
                            ],
                          ),
                          Text(
                            getReviewModel.updatedAt
                                .toString()
                                .substring(0, 10),
                            style: kStyleNormal,
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Text(
              getReviewModel.comment.toString(),
              style: kStyleNormal.copyWith(
                fontSize: 12.0,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.justify,
            ),
          ),
          const SizedBox12(),
        ],
      ),
    );
  }

  Widget addReviewBottomSheet() {
    return StatefulBuilder(builder: (context, setState) {
      return GestureDetector(
        onTap: () {
          myfocusRemover(context);
        },
        child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox12(),
                  Text(
                    'Give Ratings',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox12(),
                  Container(
                    width: maxWidth(context),
                    padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RatingBar.builder(
                                minRating: 1,
                                itemBuilder: (context, index) {
                                  switch (index) {
                                    case 0:
                                      return Icon(
                                          Icons.sentiment_very_dissatisfied,
                                          color: myColor.primaryColor);
                                    case 1:
                                      return Icon(
                                        Icons.sentiment_dissatisfied,
                                        color: myColor.primaryColor,
                                      );
                                    case 2:
                                      return Icon(
                                        Icons.sentiment_neutral,
                                        color: myColor.primaryColor,
                                      );
                                    case 3:
                                      return Icon(
                                        Icons.sentiment_satisfied,
                                        color: myColor.primaryColorDark,
                                      );
                                    case 4:
                                      return Icon(
                                        Icons.sentiment_very_satisfied,
                                        color: myColor.primaryColorDark,
                                      );
                                  }
                                  return const Icon(
                                    Icons.sentiment_very_satisfied,
                                    color: Colors.green,
                                  );
                                },
                                initialRating: rating,
                                updateOnDrag: true,
                                itemSize: 30.0,
                                itemPadding: const EdgeInsets.only(right: 5),
                                onRatingUpdate: (newRatingValue) {
                                  setState(() {
                                    // rating = newRatingValue;
                                    rating = newRatingValue;
                                    rating == 1
                                        ? ratingsText = 'Satisfactory'
                                        : rating == 2
                                            ? ratingsText = 'Good'
                                            : rating == 3
                                                ? ratingsText = 'Average'
                                                : rating == 4
                                                    ? ratingsText = 'Best'
                                                    : rating == 5
                                                        ? ratingsText =
                                                            'Excellent'
                                                        : 'Excellent';
                                  });
                                }),
                            const SizedBox(width: 10.0),
                            Text(
                              '${rating.toString()}  ( $ratingsText )',
                              style: kStyleNormal.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 13.0,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox12(),
                  Text(
                    'Write a Review',
                    style: kStyleNormal.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.0,
                    ),
                  ),
                  const SizedBox12(),
                  Container(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom / 1.4),
                    width: 400.0,
                    child: TextField(
                      textInputAction: TextInputAction.go,
                      controller: _reviewController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8.0),
                        filled: true,
                        fillColor: Colors.white,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              const BorderSide(color: Colors.white, width: 0.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                              color: myColor.primaryColorDark, width: 1.5),
                        ),
                        hintText:
                            'Would you like to write anything about this product?',
                        hintStyle: kStyleNormal.copyWith(
                            fontSize: 12.0, color: Colors.grey[400]),
                      ),
                    ),
                  ),
                  const SizedBox32(),
                  SizedBox(
                    width: maxWidth(context),
                    height: 50.0,
                    child: myCustomButton(
                      context,
                      myColor.primaryColorDark,
                      'Submit Review',
                      kStyleNormal.copyWith(
                          color: Colors.white, fontSize: 14.0),
                      () {
                        submitReviewBtn();
                      },
                    ),
                  ),
                  const SizedBox12(),
                ])),
      );
    });
  }
}
