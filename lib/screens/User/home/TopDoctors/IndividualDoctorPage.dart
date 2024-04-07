import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ghargharmadoctor/api/api_imports.dart';
import 'package:ghargharmadoctor/constants/constants_imports.dart';
import 'package:ghargharmadoctor/models/ConsultationTypeModel.dart';
import 'package:ghargharmadoctor/models/Doctor%20Review/GetDoctorReview.dart';
import 'package:ghargharmadoctor/models/DoctorModel/GetAllDoctorsModel.dart';
import 'package:ghargharmadoctor/models/models.dart';
import 'package:ghargharmadoctor/screens/User/book%20appointments/reviewBooking.dart';
import 'package:ghargharmadoctor/widgets/widgets_import.dart';

class IndividualDoctorPage extends StatefulWidget {
  final Doctors doctors;
  const IndividualDoctorPage({Key? key, required this.doctors})
      : super(key: key);

  @override
  State<IndividualDoctorPage> createState() => _IndividualDoctorPageState();
}

class _IndividualDoctorPageState extends State<IndividualDoctorPage> {
  String? myDate, token, selectedTime, timeUniqueID;
  DateTime selectedDate = DateTime.now();
  int initialLength = 3;
  double rating = 5;
  List<GetDoctorReview> getDoctorReviewModel = [];
  int selectedIndexs = -1;
  int selectedIndexConsultationType = 0;
  String selectedConsultationTypeName = 'In Video';
  ApiHandlerBloc? doctorReviewsBloc;
  final TextEditingController _yourProblemController = TextEditingController();
  String ratingsText = 'Excellent';
  final TextEditingController _reviewController = TextEditingController();
  List<Bookings> list = [];
  List<Slots> slotList = [];
  @override
  void initState() {
    doctorReviewsBloc = ApiHandlerBloc();
    _refreshDoctorReviews();
    super.initState();
  }

  void _refreshDoctorReviews() {
    doctorReviewsBloc!
        .fetchAPIList('doctorReview?doctor_id=${widget.doctors.id.toString()}');
  }

  void submitReviewBtn() async {
    int statusCode;
    if (_reviewController.text.toString().isEmpty) {
      myToast.toast('empty');
    } else {
      statusCode = await API().postData(
        context,
        PostDoctorReviewModel(
          doctorId: widget.doctors.id,
          comment: _reviewController.text.toString(),
          rating: rating.toString().substring(0, 1),
        ),
        endpoints.postDoctorReviewEndpoint,
      );
      if (statusCode == 200) {
        Navigator.pop(context);
        _refreshDoctorReviews();
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    myDate = selectedDate.toLocal().toString().split(' ')[0];
    list = widget.doctors.bookings!
        .where((element) => myDate == element.date)
        .toList();
    if (list.isNotEmpty) {
      slotList = list[0]
          .slots!
          .where(
              (element) => selectedConsultationTypeName == element.serviceType)
          .toList();
    } else {
      slotList = [];
    }
    return GestureDetector(
      onTap: () {
        myfocusRemover(context);
      },
      child: Scaffold(
        backgroundColor: backgroundColor,
        appBar: myCustomAppBar(
          title: widget.doctors.salutation == null
              ? 'Dr. ${widget.doctors.user!.name.toString().capitalize()}'
              : '${widget.doctors.salutation.toString().capitalize()}  ${widget.doctors.user!.name.toString().capitalize()}',
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
                            widget.doctors.imagePath.toString(),
                            BoxFit.contain,
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: kTransparent,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15.0, vertical: 20.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    // mainAxisAlignment:
                                    //     MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          '${widget.doctors.salutation.toString().capitalize()}  ${widget.doctors.user!.name.toString().capitalize()}',
                                          overflow: TextOverflow.clip,
                                          style: kStyleNormal.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Icon(
                                        Icons.verified,
                                        color: myColor.primaryColorDark,
                                        size: 15.0,
                                      ),
                                    ],
                                  ),
                                  const SizedBox2(),
                                  const SizedBox2(),
                                  specCard(widget
                                      .doctors.departments!.department
                                      .toString()),
                                  const SizedBox2(),
                                  specCard(
                                      widget.doctors.specialization.toString()),
                                  const SizedBox2(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  FontAwesomeIcons.thumbsUp,
                                  'Ratings',
                                  widget.doctors.averageRating.toString(),
                                ),
                                myDivider(),
                                myContainer(
                                  FontAwesomeIcons.comment,
                                  'Patient Feedback',
                                  widget.doctors.averageReview.toString(),
                                ),
                                myDivider(),
                                myContainer(
                                  Icons.medical_information,
                                  'Experience',
                                  '${widget.doctors.yearPracticed.toString()} Years',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox12(),
                          const SizedBox12(),
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
                                  Icons.gps_fixed,
                                  'Current Location',
                                  widget.doctors.address.toString(),
                                ),
                                myDivider(),
                                myContainer(
                                  Icons.location_on,
                                  'Place for appointment',
                                  widget.doctors.address.toString(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox16(),
                    const Divider(),
                    chooseConsultationTypeWidget(),
                    const SizedBox16(),
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
                      'Rs ${widget.doctors.fee.toString()}',
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
                              'Select  Date',
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
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Choose Time',
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
                      height: 40.0,
                      child: slotList.isEmpty
                          ? noTimeCard()
                          : ListView.builder(
                              itemCount: slotList.length,
                              scrollDirection: Axis.horizontal,
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              itemBuilder: (ctx, i) {
                                var data = slotList[i];
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndexs = i;
                                    });
                                    timeUniqueID = data.id.toString();
                                    selectedTime = data.slot.toString();
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
                                        8.0,
                                      ),
                                    ),
                                    width: 100,
                                    child: Center(
                                      child: Text(
                                        data.slot.toString(),
                                        textAlign: TextAlign.center,
                                        overflow: TextOverflow.clip,
                                        style: kStyleNormal.copyWith(
                                            color: selectedIndexs == i
                                                ? Colors.white
                                                : myColor.primaryColorDark),
                                      ),
                                    ),
                                  ),
                                );
                              }),
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
                        textInputAction: TextInputAction.go,
                        controller: _yourProblemController,
                        maxLines: 4,
                        style: kStyleNormal.copyWith(fontSize: 12.0),
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
                      stream: doctorReviewsBloc!.apiListStream,
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
                              getDoctorReviewModel = List<GetDoctorReview>.from(
                                  snapshot.data!.data
                                      .map((i) => GetDoctorReview.fromJson(i)));
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${getDoctorReviewModel.length} Reviews',
                                    textAlign: TextAlign.start,
                                    style: kStyleNormal.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.0,
                                    ),
                                  ),
                                  const SizedBox12(),
                                  ListView.builder(
                                      itemCount: getDoctorReviewModel.length >
                                              initialLength
                                          ? initialLength
                                          : getDoctorReviewModel.length,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return reviewsCard(
                                            getDoctorReviewModel[index]);
                                      }),
                                  const SizedBox(
                                    height: 5.0,
                                  ),
                                  getDoctorReviewModel.length > initialLength
                                      ? Center(
                                          child: GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                initialLength =
                                                    getDoctorReviewModel.length;
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
                                      : getDoctorReviewModel.length <
                                              initialLength
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
                if (selectedTime == null) {
                  myToast.toast('Please choose a time');
                } else if (_yourProblemController.text.isEmpty) {
                  myToast.toast('Please write a message');
                } else {
                  if (token == null) {
                    showLoginPopUp(
                      context,
                      'bookDoctor',
                      GuestLoginNavigationModel(
                        dateValue: myDate.toString(),
                        doctors: widget.doctors,
                        timeUniqueID: timeUniqueID.toString(),
                        shiftValue: selectedTime.toString(),
                        yourProblem: _yourProblemController.text,
                        selectedTimeShiftID: selectedIndexConsultationType + 1,
                      ),
                    );
                  } else {
                    goThere(
                        context,
                        ReviewBooking(
                          dateValue: myDate.toString(),
                          doctors: widget.doctors,
                          timeUniqueID: timeUniqueID.toString(),
                          timeValue: selectedTime.toString(),
                          yourProblem: _yourProblemController.text,
                          consultationType: selectedIndexConsultationType + 1,
                        ));
                  }
                }
              })),
        ),
      ),
    );
  }

  Widget noTimeCard() {
    return Container(
        width: maxWidth(context),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: const BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        child: Center(
          child: Text('Not available',
              style: kStyleNormal.copyWith(fontSize: 14.0)),
        ));
  }

  Widget myContainer(myIcon, myTitle, myDesc) {
    return Expanded(
      flex: 1,
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              myDesc,
              maxLines: 3,
              textAlign: TextAlign.center,
              overflow: TextOverflow.clip,
              style: kStyleNormal.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 11.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget reviewsCard(GetDoctorReview getReviewModel) {
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

  Widget myDivider() {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        height: 64,
        width: 1,
        color: backgroundColor);
  }

  Widget specCard(name) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const Icon(
          Icons.keyboard_arrow_right_outlined,
          size: 12.0,
        ),
        const SizedBox(width: 4.0),
        Text(
          name,
          style: kStyleNormal.copyWith(fontSize: 12.0),
        ),
      ],
    );
  }

  Widget chooseConsultationTypeWidget() {
    return SizedBox(
      width: maxWidth(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Consultation Type',
            style: kStyleNormal.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          const SizedBox12(),
          SizedBox(
            height: 35.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: consultationTypeList.length,
              shrinkWrap: true,
              itemBuilder: (ctx, i) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndexConsultationType = i;
                      selectedConsultationTypeName =
                          consultationTypeList[i].type!;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(4.0),
                      ),
                      border: Border.all(
                        color: selectedIndexConsultationType == i
                            ? myColor.primaryColorDark
                            : Colors.white,
                      ),
                      color: selectedIndexConsultationType == i
                          ? myColor.primaryColorDark
                          : Colors.white,
                    ),
                    height: 10.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          consultationTypeList[i].icon,
                          color: selectedIndexConsultationType == i
                              ? Colors.white
                              : myColor.primaryColorDark,
                          size: 14.0,
                        ),
                        const SizedBox(width: 10.0),
                        Text(consultationTypeList[i].type.toString(),
                            style: kStyleNormal.copyWith(
                                fontSize: 12.0,
                                color: selectedIndexConsultationType == i
                                    ? Colors.white
                                    : Colors.black)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
